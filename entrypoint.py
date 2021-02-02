from argparse import ArgumentParser

import os
import subprocess
import sys
import re

STATA_PATH = "/usr/local/stata/stata-mp"


def stream_subprocess_output(cmd):
    """Stream stdout and stderr of `cmd` in a subprocess to stdout
    """
    with subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        bufsize=1,
        universal_newlines=True,
        encoding="utf-8",
    ) as p:
        for line in p.stdout:
            # I don't understand why we need the `\r`, but when run
            # via docker apparently require a carriage return for the
            # output to display correctly
            print(line, end="\r")
        p.wait()
        if p.returncode > 0:
            raise subprocess.CalledProcessError(cmd=cmd, returncode=p.returncode)


def run_model(script_path, *args):
    args = ["-b", "do", script_path] + list(args)
    stream_subprocess_output([STATA_PATH] + args)
    # Try to predict the log file name based on the script name. I suspect this
    # can be modified by the script however, so a more robust approach might
    # be: build a list of all `*.log` files anywhere in the tree; run the
    # script; build a new list of `*.log` files and then treat any newly
    # created ones as the output of the script.
    script_name = os.path.basename(script_path)
    log_file = os.path.splitext(script_name)[0] + ".log"
    return check_output(log_file)


def check_output(log_file):
    """Check stata output and raise an exception if there are errors
    """
    # Stata insists on writing to the current
    # directory: https://stackoverflow.com/a/35051922/559140
    output = ""
    with open(log_file, "r", encoding="utf-8") as f:
        output = f.read()
        # XXX at this point, for some reason newlines are coming out
        # as escaped literals. I can't work out why and need to get on
        # for now, so have replaced `^` in this regex with `\n` + DOTALL
        if re.findall(r"\nr\([0-9]+\);$", output, re.DOTALL):
            raise RuntimeError(f"Problem found running stata script:\n\n{output}")
    return output


def main():
    license = os.environ.get('STATA_LICENSE')
    if license is None:
        sys.exit("error: STATA_LICENCE environment variable not set")

    with open('/usr/local/stata/stata.lic', 'w') as f:
        f.write(license)
  
    parser = ArgumentParser(description="Run the named Stata script")
    parser.add_argument(
        "script",
        help="Path to Stata script (relative to where the image is run from)",
        type=str,
    )
    parser.add_argument(
        "args",
        nargs="*",
        help="Optional extra positional arguments to be passed to the script",
        type=str,
    )
    options = parser.parse_args()

    os.chdir("/workspace")

    if not os.path.exists(options.script):
        raise FileNotFoundError("/workspace/" + options.script)
    run_model(options.script, *options.args)


if __name__ == "__main__":
    main()
