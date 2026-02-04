"""
This tests both the gunzip functionality and also that shipped libraries are
loaded properly by stata
"""

import gzip

from .conftest import TESTS_PATH
from .helpers import run_stata


def test_handle_gzip_csv_data():
    # create a gzipped file
    with gzip.open(TESTS_PATH / "output" / "input.csv.gz", "wb") as f:
        f.write(b"a,b,c\n1,2,3")

    gunzipped_file = TESTS_PATH / "output" / "input.csv"
    gzipped_dta_file = TESTS_PATH / "output" / "model.dta.gz"
    assert not gunzipped_file.exists()

    return_code, _, _ = run_stata("analysis/gz.do")
    assert return_code == 0

    assert gunzipped_file.exists()
    assert "1,2,3" in gunzipped_file.read_text()

    assert gzipped_dta_file.exists()
    with gzip.open(gzipped_dta_file, "rb") as gf:
        content = gf.read()
        assert b"<stata_dta>" in content, content
