import os
import subprocess
import sys
from pathlib import Path

import pytest


TESTS_PATH = Path(__file__).parent
IMAGE = "stata-mp"


@pytest.fixture(autouse=True)
def cleanup():
    """Remove any old log or output files"""
    yield
    log_files = TESTS_PATH.glob("*.log")
    output_files = TESTS_PATH / "output"
    for log_file in log_files:
        log_file.unlink()
    for output_file in output_files.iterdir():
        if output_file.name != ".keep":
            output_file.unlink()


@pytest.fixture(autouse=True)
def check_stata_license():
    if "STATA_LICENSE" not in os.environ:
        print("No STATA_LICENSE detected")
        sys.exit(1)


@pytest.fixture
def run_docker():
    def _run(command):
        filestem = Path(command.split()[0]).stem
        user = subprocess.check_output(
            "echo $(id -u):$(id -g)", shell=True, universal_newlines=True
        ).strip("\n")
        process = subprocess.run(
            f"docker run --rm --user {user} -e STATA_LICENSE -v {TESTS_PATH.resolve()}:/workspace "
            f"{IMAGE} {command}",
            shell=True,
            capture_output=True,
        )
        log_file = TESTS_PATH / f"{filestem}.log"
        # The log file should always exist, even if the .do file failed to load.
        # If it doesn't, something probably went wrong with running the container itself,
        # so fail and report the process stderr.
        if not log_file.exists():
            pytest.fail(
                f"Expected log file does not exist.\nStderr: {process.stderr.decode()}"
            )
        return (
            process.returncode,
            process.stdout.decode(),
            log_file.read_text(),
        )

    return _run
