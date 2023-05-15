def test_basic_stata_success(run_docker):
    return_code, output, log_content = run_docker("analysis/success.do a b c")
    assert return_code == 0
    for content in [output, log_content]:
        assert "OK" in content
        # cli args
        assert "aXbXc" in content


def test_basic_stata_fails(run_docker):
    return_code, output, log_content = run_docker("analysis/failure.do")
    assert return_code == 1
    for content in [output, log_content]:
        assert "badstring" in content
