# just has no idiom for setting a default value for an environment variable
# so we shell out, as we need VIRTUAL_ENV in the justfile environment
export VIRTUAL_ENV  := `echo ${VIRTUAL_ENV:-.venv}`

# TODO: make it /scripts on windows?
export BIN := VIRTUAL_ENV + "/bin"

# Load .env files by default
set dotenv-load := true

export DOCKER_BUILDKIT := "1"
export BUILD_DATE := `echo $(date +'%y-%m-%dT%H:%M:%S.%3NZ')`
export VERSION := `echo $(git rev-parse --short HEAD)`


# list available commands
default:
    @{{ just_executable() }} --list


# clean up temporary files
clean:
    rm -rf .venv


# ensure valid virtualenv
virtualenv:
    #!/usr/bin/env bash
    # allow users to specify python version in .env
    PYTHON_VERSION=${PYTHON_VERSION:-python3.11}

    # Error if venv does not contain the version of Python we expect
    if test -d $VIRTUAL_ENV; then
        test -e $BIN/$PYTHON_VERSION || \
        { echo "Did not find $PYTHON_VERSION in $VIRTUAL_ENV (try deleting the virtualenv (just clean) and letting it re-build)"; exit 1; }
    fi

    # create venv
    test -d $VIRTUAL_ENV || { uv venv --python $PYTHON_VERSION --seed; }


_compile src dst *args: virtualenv
    #!/usr/bin/env bash
    # exit if src file is older than dst file (-nt = 'newer than', but we negate with || to avoid error exit code)
    test "${FORCE:-}" = "true" -o {{ src }} -nt {{ dst }} || exit 0
    uv pip compile --allow-unsafe --generate-hashes --output-file={{ dst }} {{ src }} {{ args }}


# update requirements.prod.txt if requirements.prod.in has changed
requirements-prod *args:
    {{ just_executable() }} _compile python-requirements.in python-requirements.txt {{ args }}


# update requirements.dev.txt if requirements.dev.in has changed
requirements-dev *args: requirements-prod
    {{ just_executable() }} _compile python-requirements.dev.in python-requirements.dev.txt {{ args }}


# ensure prod requirements installed and up to date
prodenv: requirements-prod
    uv pip install -r python-requirements.txt

_env:
    #!/usr/bin/env bash
    if [[ -z "${STATA_LICENSE}" ]]; then
        export STATA_LICENSE=`echo ${STATA_LICENSE}`
    else
        export STATA_LICENSE=`echo $(cat stata.lic)`
    fi

# && dependencies are run after the recipe has run. Needs just>=0.9.9. This is
# a killer feature over Makefiles.
#
# ensure dev requirements installed and up to date
devenv: prodenv requirements-dev && install-precommit
    uv pip install -r python-requirements.dev.txt


# ensure precommit is installed
install-precommit:
    #!/usr/bin/env bash
    BASE_DIR=$(git rev-parse --show-toplevel)
    test -f $BASE_DIR/.git/hooks/pre-commit || uv run pre-commit install


# upgrade dev or prod dependencies (specify package to upgrade single package, all by default)
upgrade env package="": virtualenv
    #!/usr/bin/env bash
    opts="--upgrade"
    test -z "{{ package }}" || opts="--upgrade-package {{ package }}"
    FORCE=true {{ just_executable() }} requirements-{{ env }} $opts

black *args=".": devenv
    uv run black --check {{ args }}

ruff *args=".": devenv
    uv run ruff check {{ args }}

# run the various dev checks but does not change any files
check *args: devenv black ruff
    docker pull hadolint/hadolint
    docker run --rm -i hadolint/hadolint < Dockerfile
    shellcheck *.sh scripts/*.sh

# fix formatting and import sort ordering
fix: devenv
    uv run black .
    uv run ruff --fix .

build: _env
    docker compose build --pull stata-mp

test *args: devenv
    uv run pytest {{ args }}

# docker leaves files around as root
clean-logs:
	sudo rm -f tests/*.log
