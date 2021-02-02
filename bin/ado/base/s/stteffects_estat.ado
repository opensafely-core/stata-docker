*! version 1.0.1  20jan2015

program define stteffects_estat
	version 13

	if "`e(cmd)'" != "stteffects" {
		di as err "{help stteffects##_new:teffects} estimation " ///
		 "results not found"
		exit 301
	}
	gettoken sub rest: 0, parse(" ,")
	local lsub = length("`sub'")

	if "`sub'" == "vce" {
		estat_default `0'
	}
	else if "`sub'" == bsubstr("summarize",1,max(2,`lsub')) {
		if ("`e(stat)'"=="pomeans") estat_default `0'
		else _teffects_estat_summarize `rest'
	}
	else {
		di as err "{bf:estat `sub'} is not allowed"
		exit 321
	}
end

exit
