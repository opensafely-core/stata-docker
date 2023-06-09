from .helpers import run_stata


def test_load_custom_librarues():
    return_code, output, log_content = run_stata("analysis/custom.do")
    assert return_code == 0
    for content in [output, log_content]:
        assert "custom command called" in content
