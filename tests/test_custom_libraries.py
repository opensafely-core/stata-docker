def test_load_custom_librarues(run_docker):
    return_code, output, log_content = run_docker("analysis/custom.do")
    assert return_code == 0
    for content in [output, log_content]:
        assert "custom command called" in content
