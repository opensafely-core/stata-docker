import shutil

from .helpers import run_stata


def test_basic_stata_success():
    return_code, output, log_content = run_stata("analysis/success.do a b c")
    assert return_code == 0
    for content in [output, log_content]:
        assert "OK" in content
        # cli args
        assert "aXbXc" in content


def test_basic_stata_fails():
    return_code, output, log_content = run_stata("analysis/failure.do")
    assert return_code == 1
    for content in [output, log_content]:
        assert "badstring" in content


def test_convert_image(tmp_path):
    shutil.copy("tests/analysis/convert.do", tmp_path)

    return_code, output, log_content = run_stata("convert.do", workspace=tmp_path)
    assert return_code == 0
    assert (tmp_path / "test.png").exists()
