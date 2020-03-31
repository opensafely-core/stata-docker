*! version 1.1.0  21jun2018
program xtoprobit, eclass byable(onecall) prop(xt xtbs)
	version 13
	
	local vv : di "version " string(_caller()) ", missing:"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	
	`by' _vce_parserun xtoprobit, panel : `0'
	if "`s(exit)'" != "" {
		ereturn local cmdline `"xtoprobit `0'"'
		exit
	}
	
	if replay() {
		if "`e(cmd2)'" != "xtoprobit" {
			error 301
		}
		if _by() {
			error 190
		}
		_xtordinal_display `0'
		exit
	}
	`vv' `by' _xtordinal oprobit `0'
end

