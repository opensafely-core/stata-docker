import 'justfile.base'

set dotenv-load := true
set positional-arguments := true

export DOCKER_BUILDKIT := "1"
export BUILD_DATE := `echo $(date +'%y-%m-%dT%H:%M:%S.%3NZ')`
export VERSION := `echo $(git rev-parse --short HEAD)`
export STATA_LICENSE := `echo ${STATA_LICENSE:-$(cat stata.lic)}`

# List available commands
default:
    @"{{ just_executable() }}" --list

# Clean up temporary files
clean:
    rm -rf .venv

# Install production requirements into and remove extraneous packages from venv
prodenv:
    uv sync --no-dev

# && dependencies are run after the recipe has run. Needs just>=0.9.9. This is
# a killer feature over Makefiles.
#

# Install dev requirements into venv without removing extraneous packages
devenv: && install-precommit
    uv sync --inexact

# Ensure precommit is installed
install-precommit:
    #!/usr/bin/env bash
    set -euo pipefail

    BASE_DIR=$(git rev-parse --show-toplevel)
    test -f $BASE_DIR/.git/hooks/pre-commit || uv run pre-commit install

# Upgrade a single package to the latest version, with cooldown
upgrade-package package cooldown="7 days ago": && uvmirror devenv
    uv lock --upgrade-package {{ package }} --exclude-newer "{{ cooldown }}"

# Upgrade all packages to the latest versions, with cooldown
upgrade-all cooldown="7 days ago": && uvmirror devenv
    uv lock --upgrade --exclude-newer "{{ cooldown }}"

# update the uv mirror requirements file
uvmirror file="requirements.uvmirror":
    rm -f {{ file }}
    uv export --format requirements-txt --frozen --no-hashes --all-groups --all-extras > {{ file }}

# This is the default input command to update-dependencies action
# https://github.com/bennettoxford/update-dependencies-action

# Upgrade all dependencies with the default cooldown (7 days ago)
update-dependencies: upgrade-all

# *args is variadic, 0 or more. This allows us to do `just test -k match`, for example.

# Run the tests
test *args:
    uv run coverage run --module pytest "$@"
    uv run coverage report || uv run coverage html

format *args:
    uv run ruff format --diff --quiet "$@"

lint *args:
    uv run ruff check "$@" .

lint-actions:
    {{ docker_run_safe }} -v $(pwd):/repo:ro --workdir /repo kjanat/actionlint:{{ actionlint_version }} -color

lint-docker:
    {{ docker_run_safe }} -i ghcr.io/hadolint/hadolint:{{ hadolint_version }} < Dockerfile

shellcheck:
    {{ docker_run_safe }} -v "$PWD:/mnt:ro" koalaman/shellcheck:{{ shellcheck_version }} *.sh scripts/*.sh

# Run the various dev checks but does not change any files
check:
    #!/usr/bin/env bash
    set -euo pipefail

    failed=0

    check() {
      echo -e "\e[1m=> ${1}\e[0m"
      rc=0
      # Run it
      eval $1 || rc=$?
      # Increment the counter on failure
      if [[ $rc != 0 ]]; then
        failed=$((failed + 1))
        # Add spacing to separate the error output from the next check
        echo -e "\n"
      fi
    }

    check "just check-lockfile"
    check "just format"
    check "just lint"
    check "just lint-actions"
    check "just lint-docker"
    check "just shellcheck"

    if [[ $failed > 0 ]]; then
      echo -en "\e[1;31m"
      echo "   $failed checks failed"
      echo -e "\e[0m"
      exit 1
    fi

# validate uv.lock
check-lockfile:
    uv lock --check

# Fix formatting, import sort ordering, and justfile
fix:
    -uv run ruff check --fix .
    -uv run ruff format .
    -just --fmt --unstable

build:
    docker compose build --pull prod

# docker leaves files around as root
clean-logs:
    sudo rm -f tests/*.log



check-renovate-config:
    {{ docker_run_safe }} -v $(pwd):/repo:ro --workdir /repo renovate/renovate:{{ renovate_version }} renovate-config-validator

# Show what updates Renovate would propose.
# summary: table with version age and pending status
# packages: structured JSON of proposed package updates

# full: complete Renovate debug log
renovate-dry-run output="summary":
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Running Renovate, this may take a few minutes" >&2

    # Buffer Renovate's output so progress dots can't appear in the middle of the formatted JSON or summary table.
    log_file=$(mktemp)
    progress_pid=""

    cleanup() {
        if [[ -n "$progress_pid" ]]; then
            kill "$progress_pid" 2>/dev/null || true
            wait "$progress_pid" 2>/dev/null || true
            progress_pid=""
        fi
        rm -f "$log_file"
    }
    trap cleanup EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM

    run_renovate() {
        # We can't use docker_run_safe because --network none prevents
        # Renovate querying Docker, GitHub, PyPI, etc.
        #
        # Renovate also needs writable working/cache directories.
        # Give it a tmpfs mount and leave everything else read-only.

        # Let the user know something is still happening.
        (
            while sleep 5; do
                printf '.' >&2
            done
        ) &
        progress_pid=$!

        local status=0

        docker run --rm --read-only --tmpfs /tmp \
            --cap-drop ALL \
            --security-opt no-new-privileges:true \
            --user 65534:65534 \
            -e HOME=/tmp \
            -v "$(pwd):/repo:ro" \
            --workdir /repo \
            -e LOG_LEVEL=debug \
            -e LOG_FORMAT=json \
            renovate/renovate:{{ renovate_version }} \
            --platform=local > "$log_file" || status=$?

        # Stop the progress indicator before printing any output.
        kill "$progress_pid" 2>/dev/null || true
        wait "$progress_pid" 2>/dev/null || true
        progress_pid=""
        echo >&2

        return "$status"
    }

    # Run Renovate once, then format the buffered output.
    if ! run_renovate; then
        echo "Renovate failed. Last 30 log lines:" >&2
        tail -n 30 "$log_file" >&2
        exit 1
    fi

    case "{{ output }}" in
        summary)
            jq -rRn '
                # Truncate digests to the first 19 characters.
                # Keep the full version number.
                def format_digest:
                    if . then
                        "@" + .[:19] + "..."
                    else
                        ""
                    end;

                # Only display digests for Docker and GitHub Actions.
                def display_digest($manager):
                    if ($manager == "docker" or $manager == "github-actions") then
                        format_digest
                    else
                        ""
                    end;

                ["PACKAGE", "CURRENT", "NEW", "AGE", "STATUS"],
                (
                    inputs
                    | fromjson?
                    | objects
                    | select(.msg == "packageFiles with updates")
                    | .config[][]
                    | .manager as $manager
                    | .deps[]
                    | .depName as $name
                    | (
                        (.currentValue // .currentVersion // "-")
                        + (.currentDigest | display_digest($manager))
                    ) as $current
                    | (.updates // [])[]
                    | [
                        $name,
                        $current,
                        (
                            (.newValue // .newVersion // "-")
                            + (.newDigest | display_digest($manager))
                        ),
                        (
                            if .newVersionAgeInDays != null then
                                "\(.newVersionAgeInDays)d"
                            else
                                "-"
                            end
                        ),
                        (
                            if .pendingChecks then
                                "pending"
                            else
                                "ready"
                            end
                        )
                    ]
                )
                | @tsv
            ' "$log_file" | column -t -s $'\t'
            ;;

        packages)
            jq -R '
                fromjson?
                | objects
                | select(.msg == "packageFiles with updates")
                | .config
            ' "$log_file"
            ;;

        full)
            jq -R 'fromjson? // .' "$log_file"
            ;;

        *)
            echo "Unknown output '{{ output }}': use 'summary', 'packages' or 'full'" >&2
            exit 1
            ;;
    esac

# Run a full Renovate dry run against this branch (requires pushing the branch first)
renovate-dry-run-github branch:
    # This checks some things that renovate-dry-run (which runs against local files)
    # can't, e.g. lockFileMaintenance, which depend on it determinining what branches
    # and PRs it would need to make.
    # Note that we can't use docker_run_safe here because `--network none` stops
    # Renovate querying docker, github, pypi etc for updates. It's not --read-only
    # because it needs to install uv and npm; however, it doesn't need to mount in
    # any local files because it's pulling a remote branch.
    docker run --rm --tmpfs /tmp \
        --cap-drop ALL --security-opt no-new-privileges:true \
        -e LOG_LEVEL=debug -e LOG_FORMAT=json \
        -e RENOVATE_TOKEN="$(gh auth token)" \
        renovate/renovate:{{ renovate_version }} \
        --platform=github --dry-run=full \
        --base-branch-patterns={{ branch }} --use-base-branch-config=merge \
        opensafely-core/job-runner
