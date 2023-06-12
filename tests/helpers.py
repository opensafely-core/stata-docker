import os
import pwd
import re
import subprocess
from pathlib import Path

import pytest

from .conftest import TESTS_PATH


IMAGE = "stata-mp"
RE_WHITESPACE = re.compile(r"\s+")


def sanitize(string):
    """
    Replace all whitespaces in a string with single whitespace, to make asserting
    content more robust
    """
    return RE_WHITESPACE.sub(" ", string).strip()


def run_stata(command):
    command_list = command.split()
    filestem = Path(command_list[0]).stem
    uid = os.getuid()
    gid = pwd.getpwuid(uid).pw_gid
    process = subprocess.run(
        [
            "docker",
            "run",
            "--rm",
            "--user",
            f"{uid}:{gid}",
            "-e",
            "STATA_LICENSE",
            "-v",
            f"{TESTS_PATH.resolve()}:/workspace",
            IMAGE,
            *command_list,
        ],
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
    # Return sanitized versions of the output and log file. `sanitize` just replaces all
    # whitespace with one single whitespace.
    # This means we can assert multiline blocks of text and tables in the output/logs without
    # breaking if there's slightly different whitespace.
    return (
        process.returncode,
        sanitize(process.stdout.decode()),
        sanitize(log_file.read_text()),
    )
