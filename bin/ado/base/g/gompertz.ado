*! version 1.6.3  08aug2017
program define gompertz, eclass byable(recall) prop(ml_score)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
	version 7.0
	if replay() {
		if `"`e(cmd)'"' != "gompertz" { error 301 } 
		if _by() { error 190 }
		syntax [, Level(cilevel) noCOEF noHEADer HR *]
		if "`e(gamma)'"=="" {
	 		local ancilla = "anc"
		}
		_get_diopts diopts, `options'
	}
	else {
		syntax [varlist(fv)] [if] [in] [fweight pweight iweight] /*
			*/ [, noCOEF CLuster(varname) Dead(varname numeric) /*
			*/ DEBUG FROM(string) noHEADer HR MLMethod(string) /*
			*/ MLOpt(string) noCONstant /*
			*/ Level(cilevel) noLOg STrata(varname fv) /*
			*/ OFFset(varname numeric) ANCillary(varlist fv) /*
			*/ Robust SCore(string) T0(varname numeric) SKIP /*
			*/ moptobj(passthru) *]
		if _by() {
			_byoptnotallowed score() `"`score'"'
		}

		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		tokenize `varlist'
		local t `1'
		mac shift 
		local rhs `*'
		if "`strata'"~="" {
			if "`ancillary'"~="" {
				noi di as err /*
				*/ "options strata() and ancillary()" /*
				*/ " may not be specified together"
				exit 198
			}
			if _caller() >= 15 {
				local rhs `rhs' i.`strata'
				local ancillary i.`strata'
			}
			else {
				qui xi, prefix(_S) i.`strata'
				local rhs `rhs' _S*
				local ancillary _S*
			}
		}


		if "`cluster'"!="" {
			local cluopt cluster(`cluster')
		}
		if "`from'"!="" { local iniopt init(`from') }
		if "`mlmethod'" == "" { local mlmetho  "`mm'" }
		if "`offset'" !="" { local offopt offset(`offset') }
		_get_diopts diopts options, `options'
		mlopts options, `options'
		local coll `s(collinear)'

		if "`score'" != "" { 
			local n : word count `score'
			if `n'==1 & bsubstr("`score'",-1,1)=="*" { 
				local score = /*
				*/ bsubstr("`score'",1,length("`score'")-1)
				local score `score'1 `score'2 
				local n 2
			}
			if `n' != 2 { 
				di as err /*
			*/ "score() invalid:  two new variable names required"
				exit 198 
			}
			confirm new var `score'
			local scopt "score(`score')"
		}

		if "`weight'" != "" { 
			tempvar wv
			qui gen double `wv' `exp'
			local w [`weight'=`wv']
		}

		tempvar touse 
		mark `touse' `w' `if' `in'
		markout `touse' `t' `rhs' `dead' `t0' `offset'
		markout `touse' `cluster', strok


		if "`dead'" != "" {
			local sdead "`dead'"
			capture assert `dead'==0 | `dead'==1 if `touse'
			if _rc { 
				tempvar mydead 
				qui gen byte `mydead' = `dead'!=0 if `touse'
				local dead "`mydead'"
			}
		}
		else {
			tempvar dead 
			qui gen byte `dead'=1
			local sdead 1
		}

		if "`t0'" == "" {
			local t0 0
		}
		capture assert `t0' < `t' if `touse'
		if _rc {
			di as err "`t0' >= `t' in some obs."
			exit 498
		}

		if `fvops' {
			local rmcoll "version 11: _rmcoll"
		}
		else	local rmcoll _rmcoll
		`rmcoll' `rhs' `w' if `touse', `constant' `coll'
		local rhs "`r(varlist)'"
		global S_1

		global EREGd `dead'
		global EREGt0 `t0'

		if "`log'"!="" { local nlog="*" }
		tempvar num den
		quietly { 
			if "`weight'"=="aweight" | "`weight'"=="pweight" {
				tempvar wvn
				summ `wv' if `touse', meanonly 
				gen double `wvn' = `wv'/r(mean) if `touse'
				local wvngen 1
			}
			else if "`weight'"!="" {
				local wvn `wv'
			}
			else {
				local wvn 1
			}
			gen double `num' = sum(`wvn'*`dead'*`touse') 
			gen double `den' = sum(`wvn'*(`t'-$EREGt0)*`touse')
			local cons = ln(`num'[_N]/`den'[_N])
			drop `num' `den'
			gen double `num' = `wvn'*ln(`t') if `touse' & `dead'
			replace `num' = sum(`num') 
			global EREGa = `num'[_N]
			drop `num' 
			if "`wvngen'"!=""  { drop `wvn' }
			local initopt init(_cons=`cons' /gamma=0)
		}
		local search search(off)
		if "`constant'"!="" {
			local skip = "skip"
			local search search(quietly)
			`nlog' di as txt "Fitting full model:"
		}

		if `"`ancillary'"' == "" {
			if _caller() >= 15 {
				local fparm ", freeparm"
			}
		}

		if "`rhs'" != "" & "`skip'"=="" {
			`nlog' di ""
			`nlog' di as txt "Fitting constant-only model:"
			`vv' ///
			ml model `mlmetho' gomp_lf (`t': `t'=, `offopt' ) /*
				*/ (gamma: `ancillary' `fparm') /*
				*/ `w' if `touse', /*
				*/ `initopt'  /*
				*/ missing collin nopreserve wald(0) `mlopt' /*
				*/ max search(quietly) noout `log' `options' /*
				*/ `robust' nocnsnotes `negh'
			
			local converged_cons = e(converged)
			tempname b0
			if `converged_cons' == 0 {
				mat `b0' = e(b)
				if "`from'" == "" {
					local iniopt "init(`b0', skip)"
				}	
			}	
			else {
				local cont continue
			}			
			`nlog' di ""
			`nlog' di as txt "Fitting full model:"
		} 
		else {
			local cont wald(1)
                }

		global GLIST : all globals "EREG*"
		
		`vv' ///
		ml model `mlmetho' gomp_lf /*
			*/  (`t': `t'=`rhs', `offopt' `constant') /*
			*/ (gamma: `ancillary' `fparm') /*
			*/ `w' if `touse', `cont' noout /*
			*/ `robust' `cluopt' `scopt' `iniopt' `mlopt' /*
			*/ missing collin nopreserve  /*
			*/ max `search' `log' `options' `negh' `moptobj'

		if "`e(wtype)'" != "" {
			est local wexp `"`exp'"'
		}
		cap est hidden scalar converged_cons = `converged_cons'
		if _caller() < 15 {
			est local title2 "log relative-hazard form"
		} 
		est local predict gomper_p
		est local t0 `t0'
		est local dead `sdead'
		if "`ancillary'" == "" {
			est scalar k_aux = 1
		}
		if "`ancillary'" =="" & "`ancilla'"=="" {
			est scalar gamma= _b[/gamma]
			est local stcurve="stcurve"
		}
	
		if "`strata'" != "" {
			est local strata = "`strata'"
		}
		est local cmd gompertz 
		global S_E_cmd gompertz
	}

	global EREGw
	global EREGd
	global EREGt
	global EREGt0
	global EREGa

	if "`coef'"=="" {
		if "`hr'"!="" {
			local hr "eform(Haz. Ratio)"
		}
		else { local hr }
		if "`header'" == "" {
			di _n as txt /*
			*/ "Gompertz PH regression -- entry time `e(t0)'"
                       }
		version 9: ///
		ml di, `header' level(`level') `hr' title(`e(title2)') ///
			`diopts'
	}
end

exit
