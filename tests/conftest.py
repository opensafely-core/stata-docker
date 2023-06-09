import os
import sys
from pathlib import Path

import pytest


TESTS_PATH = Path(__file__).parent


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


@pytest.fixture(autouse=True, scope="session")
def check_stata_license():
    if "STATA_LICENSE" not in os.environ:
        print("No STATA_LICENSE detected")
        sys.exit(1)
