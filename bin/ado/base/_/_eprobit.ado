*! version 1.0.1  13sep2019
program _eprobit, eclass byable(recall) sortpreserve
	version 16.0
	syntax varlist(fv numeric ts) [if] [in] 			/*
			*/ [fweight iweight pweight], 			/*
			*/ [EXTReat(string)				/*
			*/ ENTReat(string)				/*
			*/ OFFset(passthru) 				/*
			*/ noCONstant					/*
			*/ CONSTraints(passthru)		 	/*
			*/ INTPoints(string) 	    			/*
			*/ TRIINTpoints(string)	    			/*
			*/ SELect(string)				/*
			*/ TOBITSELect(string)				/*
			*/ noLOg              				/*
			*/ from(string)					/*
			*/ vce(passthru)				/*
			*/ TECHnique(passthru)				/*
			*/ lfarg(string)	/*UNDOCUMENTED*/	/*
			*/ noTable					/*
			*/ noESTimate		/*UNDOCUMENTED*/	/*
			*/ re						/*
			*/ REINTPoints(string)				/*
			*/ REINTMethod(string)				/*
			*/ adaptlog		/*UNDOCUMENTED*/	/*
			*/ *]	// display,reporting and maximization
	if "`estimate'" == "noestimate" & `"`from'"' != "" {
		opts_exclusive "noestimate from()"
	}
	if "`re'" != "" {
		if "`lfarg'" == "" {
			local evaltype gf1
		}
		else {
			local evaltype gf`lfarg'
		}
		if "`weight'" != "" {
			"{p 0 4 2}weights are not allowed{p_end}"
			exit 498
		}
		if "`technique'" == "" {
			local technique technique(bhhh 10 nr 2)
		}
	}
	else {
		if "`lfarg'" == "" {
			local evaltype lf1
		}
		else {
			local evaltype lf`lfarg'
		}
	}

	if("`weight'" != "") {
		local wexp [`weight'`exp']
	}
	if "`re'" == "" {
		local cmdline eprobit `0'
	}
	else {
		local cmdline xteprobit `0'
	}
	gettoken depvar indepvars : varlist
	_fv_check_depvar `depvar', k(1)
	local ndv = 1
	capture assert `depvar' >= 0 
	if _rc {
		di as error "outcome must be nonnegative"
		exit 498
	}
	tempvar ddepvar
	qui gen byte `ddepvar' = `depvar' > 0 if ~missing(`depvar')
	local repanvar
	if "`re'" != "" {
		qui xtset
		local repanvar `r(panelvar)'
		local allcons allcons
		local relist 1
	}
	if "`vce'" != "" {
		qui capture qui _vce_parse, argoptlist(CLuster):, `vce'
		local clvar `r(cluster)'
	}
	marksample touse, novarlist
	if "`select'`tobitselect'" == "" {
		markout `touse' `indepvars' `repanvar'
		if "`clvar'" != "" {
			markout `touse' `clvar', strok
		}		
	}

	if "`reintmethod'" == "" {
		local reintmethod "mvaghermite"
	}
	else {
        if "`re'" == "" {
        	di as error "{p 0 4 2}{bf:reintmethod()} only "
            di as error "allowed with random effects{p_end}"
			exit 498
		}
		local len = ustrlen("`reintmethod'")
		if "`reintmethod'"!=bsubstr("ghermite",1,max(2,`len')) & ///
		   "`reintmethod'"!=bsubstr("mvaghermite",1,max(2,`len')) {
			di as err "{p 0 4 2}{bf:reintmethod()} invalid, " ///
				"{bf:`reintmethod'} not allowed"
			exit(198)
		}
		if "`reintmethod'"==bsubstr("mvaghermite", 1, max(2,`len')) {
			local reintmethod mvaghermite
		}
		if "`reintmethod'"==bsubstr("ghermite",1, max(2,`len')) {
			local reintmethod ghermite
		} 
	}
	if "`reintpoints'" == "" {
		local reintpoints = 7
	}
	else {
                if "`re'" == "" {
                        di as error "{p 0 4 2}{bf:reintpoints()} only "
                        di as error "allowed with random effects{p_end}"
                        exit 498
                }
                capture confirm integer number `reintpoints'
                local rc = _rc
                capture assert `reintpoints' > 1 & `reintpoints' < 129
                local rc = `rc' | _rc
                if (`rc') {
                        di as error "{bf:reintpoints()} must be " ///
                                "an integer greater than 1"  ///
                                " and less than 129"
                        exit 198
                }
	}
	if "`intpoints'" == "" {
		local intpoints = 128
		local intpointsspec 0
	}
	else {
		local intpointsspec 1
		capture confirm integer number `intpoints'
		local rc = _rc
		capture assert `intpoints' >= 3 & `intpoints' <= 5000 
		local rc = `rc' | _rc
		if (`rc') {
			di as error "{p 0 4 2}{bf:intpoints()} must be " ///
			"an integer greater than 2 " ///
			"and less than 5001{p_end}"
			exit 198 
		}	
	}
	local intpoints3 `triintpoints'
	if "`intpoints3'" == "" {
		local intpoints3 = 10
		local intpoints3spec 0
	}
	else {
		local intpoints3spec 1
		capture confirm integer number `triintpoints'
		local rc = _rc
		capture assert `triintpoints' >= 3 & `triintpoints' <= 5000 
		local rc = `rc' | _rc
		if (`rc') {
			di as error "{p 0 4 2}{bf:triintpoints()} must be " ///
			"an integer greater than 2 " ///
			"and less than 5001{p_end}"
			exit 198 
		}		
	}
	local initargs , depvar(`depvar') ///
		`offset' repanvar(`repanvar')
	local depvarrd `depvar'
	local rdinitargs

	// Parse treatment equation	
	if `"`extreat'"' != "" & `"`entreat'"' != "" {
		opts_exclusive "extreat() entreat()"
	}
	local notepovariance 0
	if "`extreat'" != "" {
		_erm_extreat_parse, equation(`extreat') 
		if "`s(indepvars)'" != "" {
			di as error ///
			"{p 0 4 2}invalid specification of {bf:extreat()}; "
			di as error ///
				"no treatment covariates allowed{p_end}"
			exit 198
		}
		if "`s(constant)'" != "" {
			di as error ///
			"{p 0 4 2}invalid specification of {bf:extreat()}; "
			di as error ///
				"option {bf:`s(constant)'} not allowed{p_end}"
			exit 198
		}
		if "`s(offset)'" != "" {
			di as error ///
			"{p 0 4 2}invalid specification of {bf:extreat()}; "
			di as error ///
				"option {bf:offset()} not allowed{p_end}"
			exit 198			
		}		
		local extr_depvar `s(depvar)'
		local extrconst 0
		local extr_pocovariance `s(pocorrelation)'
		if "`s(povariance)'" != "" {
			local notepovariance 1	
		}
		if "`s(main)'" != "nomain" {
			local extr_main "main"
		}
		else {
			local extrconst 1
		}
		if "`s(interact)'" != "nointeract" {
			local extr_interact "interact"
		}
		else {
			local extrconst 1
		}	
		if "`select'`tobitselect'" == "" {
			markout `touse' `extr_depvar'
		}
		sreturn clear
	}	
	if "`entreat'" != "" {
		local ndv = `ndv' + 1
		_erm_entreat_parse, equation(`entreat') 
		local tr_depvar `s(depvar)'
		local depvarrd `depvarrd' `tr_depvar'
		local tr_indepvars `s(indepvars)'
		local tr_constant `s(constant)'
		local tr_offset `s(offset)' 
		local tr_pocovariance `s(pocorrelation)'
		local trconst 0
		if "`s(povariance)'" != "" {
			local notepovariance 1	
		}
		if "`s(main)'" != "nomain" {
			local tr_main "main"
		}
		else {
			local trconst 1
		}
		local tr_re
		if "`re'" != "" & "`s(re)'" != "nore" {
			local tr_re "re"
		}
		if "`s(interact)'" != "nointeract" {
			local tr_interact "interact"
		}
		else {
			local trconst 1
		}
		markout `touse' `tr_depvar' `tr_indepvars'
		local initargs `initargs' tr_depvar(`tr_depvar')	///
			tr_indepvars(`tr_indepvars') 			///
			tr_constant(`tr_constant') 			///
			tr_offset(`tr_offset')				
		local rdinitargs `rdinitargs' tr_depvar(`tr_depvar')	///
			tr_indepvars(`tr_indepvars')
		sreturn clear
	}
	if "`extrconst'`trconst'" == "0" {
		local constant noconstant
	}
	local userecinit = 0

	// Parse multiple endogenous() instances.
	// noconstant and offset, etc. go with the first equation that 
	// the endogenous variable is used in.
	local endogfound = 1
	ParseEndog, `options'
	local options `s(rest)'
	local sendog `s(endog)'
	sreturn clear
	if "`sendog'" == "" {
		local endogfound 0
	}
	local nendog = 0
	local nbendog = 0
	local noendog = 0
	local enotbinary "{p 0 4 2}invalid specification of"
	local enotbinary "`enotbinary' {bf:endogenous(, probit)};"
	local enotbinary "`enotbinary' endogenous variables are"
	local enotbinary "`enotbinary' not binary{p_end}"
	local enotord "{p 0 4 2}invalid specification of"
	local enotord "`enotord' {bf:endogenous(, oprobit)};"
	local enotord "`enotord' endogenous variables are"
	local enotord "`enotord' not ordinal{p_end}"
	while (`endogfound' == 1) {
		_erm_endog_parse, equation(`sendog')
		local nendoginendog: word count `s(depvar)'
		local sindepvars `s(indepvars)'
		local sdepvar `s(depvar)'
		local sprobit `s(probit)'
		local smain `s(main)'
		local sconstant `s(constant)'
		local spocorrelation `s(pocorrelation)'
		local sre `s(re)'
		local spovariance `s(povariance)'
		local soprobit `s(oprobit)'
		local soffset `s(offset)'
		SubTreatment, trdepvar(`extr_depvar'`tr_depvar') ///
			invarlist(`sindepvars')			 /// 
			constant(`extrconst'`trconst')		 ///
			equation("endogenous")
		local sindepvars `r(invarlist)'
		if `"`sprobit'"' != "" {
			forvalues i = 1/`nendoginendog' {
				local prospendog: word `i' of `sdepvar'
				capture assert `prospendog'==0 | ///
					`prospendog'==1 ///
					if !missing(`prospendog')
				if _rc {
					di as error `"`enotbinary'"'
					exit 498
				}
				local new = 1
				forvalues j = 1/`nbendog' {
					if "`prospendog'"== ///
						"`bendog_depvar`j''" {
						local bendog_indepvars`j'  ///
						`bendog_indepvars`j'' ///
						`sindepvars'
						local new = 0
					}
				}
				if `new' {
					local ndv = `ndv' + 1
					local depvarrd `depvarrd' `prospendog'
					if "`smain'" != "nomain" {
						local indepvars ///
						`indepvars' i.`prospendog'	
					}
					local nbendog = `nbendog' + 1
					local bendog_depvar`nbendog' ///
						`prospendog'
					local bendog_indepvars`nbendog' ///
						`sindepvars'
					local bendog_eqn`nbendog' 	///
						, `sconstant' 
					local bendog_pocovariance`nbendog' ///
						`spocorrelation'
					local bendog_re`nbendog'
					if "`re'" != "" & ///
						"sre'" != "nore" {
						local bendog_re`nbendog' re
					}
					if "`spovariance'" != "" {
						local notepovariance 1	
					}
					local initargs `initargs' ///
					bendog_constant`nbendog'(`sconstant')
					local bendog_constant`nbendog' ///
						`sconstant'
					if "`sconstant'" == "noconstant" {
						local userecinit 1
					}
				}
			}	
		}
		else if `"`soprobit'"' != "" {
			forvalues i = 1/`nendoginendog' {
				local prospendog: word `i' of `sdepvar'
				capture assert round(`prospendog') ///
					==`prospendog' ///
					& `prospendog' >= 0 ///
					if !missing(`prospendog')
				if _rc {
					di as error `"`enotord'"'
					exit 498
				}
				local new = 1
				forvalues j = 1/`noendog' {
					if "`prospendog'"== ///
						"`oendog_depvar`j''" {
						local oendog_indepvars`j'  ///
						`oendog_indepvars`j'' ///
						`sindepvars'
						local new = 0
					}
				}
				if `new' {
					local ndv = `ndv' + 1
					local depvarrd `depvarrd' `prospendog'
					if "`smain'" != "nomain" {
						local indepvars ///
						`indepvars' i.`prospendog'	
					}
					local noendog = `noendog' + 1
					local oendog_depvar`noendog' ///
						`prospendog'
					local oendog_indepvars`noendog' ///
						`sindepvars'
					local oendog_eqn`noendog' 	///
						, noconstant 
					local oendog_pocovariance`noendog' ///
						`spocorrelation'
					if "`spovariance'" != "" {
						local notepovariance 1	
					}
					local oendog_re`noendog'
					if "`re'" != "" & "`sre'"!="nore" {
						local oendog_re`noendog' re
					}
					local initargs `initargs' /// 
					oendog_constant`noendog'(noconstant) 
					local oendog_constant`noendog' ///
						`sconstant'
				}
			}	
		}
		else {
	 		forvalues i = 1/`nendoginendog' {
				local prospendog: word `i' of `sdepvar'
				local new = 1
				forvalues j = 1/`nendog' {
					if "`prospendog'" == ////
						"`endog_depvar`j''" {
						local endog_indepvars`j' ///
							`endog_indepvars`j'' ///
							`sindepvars'
						local new = 0
					}
				}
				if `new' {
					local ndv = `ndv' + 1
					local depvarrd `depvarrd' `prospendog'
					if "`smain'" != "nomain" {
						local indepvars ///
						`indepvars' `prospendog'	
					}
					local nendog = `nendog' + 1
					local endog_depvar`nendog' ///
						`prospendog'
					local endog_indepvars`nendog' ///
						`sindepvars'
					local endog_eqn`nendog' 	///
						, `sconstant' ///
						`soffset'
					local initargs `initargs' ///
					endog_constant`nendog'(	///
						`sconstant')
					local endog_constant`nendog' ///
						`sconstant'
					local endog_re`nendog' 
					if "`re'" != "" & "`sre'"!="nore" {
						local endog_re`nendog' re
					}
				}
			}
		}
		sreturn clear
		ParseEndog, `options'
		local options `s(rest)'
		local sendog `s(endog)'
		if `"`sendog'"' != "" {
			local endogfound = 1
		}
		else {
			local endogfound = 0
		}
	}
	sreturn clear
	// Set endogenous variable equations.
	local endog_eqns
	local endog_depvars
	local endog_indepvars
	forvalues i = 1/`nendog' {
		local endog_eqn`i' (`endog_depvar`i'': `endog_depvar`i'' = ///
		`endog_indepvars`i'' `endog_eqn`i'')
		markout `touse' `endog_depvar`i'' `endog_indepvars`i''
		local endog_eqns `endog_eqns' `endog_eqn`i''
		local endog_depvars `endog_depvars' `endog_depvar`i''
		local endog_indepvars `endog_indepvars' `endog_indepvars`i'',
		local initargs `initargs' endog_depvar`i'(`endog_depvar`i'') ///
			endog_indepvars`i'(`endog_indepvars`i'')
		local rdinitargs `rdinitargs' 			///
			endog_depvar`i'(`endog_depvar`i'') 	///
			endog_indepvars`i'(`endog_indepvars`i'')

	}
	local initargs `initargs' endog_depvars(`endog_depvars') ///
		endog_indepvars(`endog_indepvars') 
	local bendog_eqns
	local bendog_depvars
	local bendog_indepvars
	forvalues i = 1/`nbendog' {
		local bendog_eqn`i' (`bendog_depvar`i'':`bendog_depvar`i''= ///
		`bendog_indepvars`i'' `bendog_eqn`i'')
		markout `touse' `bendog_depvar`i'' `bendog_indepvars`i''
		local bendog_eqns `bendog_eqns' `bendog_eqn`i''
		local bendog_depvars `bendog_depvars' `bendog_depvar`i''
		local bendog_indepvars `bendog_indepvars' ///
			`bendog_indepvars`i'',
		local initargs `initargs' 			///
			bendog_depvar`i'(`bendog_depvar`i'')	///
			bendog_indepvars`i'(`bendog_indepvars`i'')
		local rdinitargs `rdinitargs' 			///
			bendog_depvar`i'(`bendog_depvar`i'')	///
			bendog_indepvars`i'(`bendog_indepvars`i'')
	}
	local initargs `initargs' bendog_depvars(`bendog_depvars')

	local oendog_eqns
	local oendog_depvars
	local oendog_indepvars
	forvalues i = 1/`noendog' {
		local oendog_eqn`i' (`oendog_depvar`i'':`oendog_depvar`i''= ///
		`oendog_indepvars`i'' `oendog_eqn`i'')
		markout `touse' `oendog_depvar`i'' `oendog_indepvars`i''
		local oendog_eqns `oendog_eqns' `oendog_eqn`i''
		local oendog_depvars `oendog_depvars' `oendog_depvar`i''
		local oendog_indepvars `oendog_indepvars' ///
			`oendog_indepvars`i'',
		local initargs `initargs' 			///
			oendog_depvar`i'(`oendog_depvar`i'')	///
			oendog_indepvars`i'(`oendog_indepvars`i'')
		local rdinitargs `rdinitargs' 			///
			oendog_depvar`i'(`oendog_depvar`i'')	///
			oendog_indepvars`i'(`oendog_indepvars`i'')
	}
	local initargs `initargs' oendog_depvars(`oendog_depvars')

	// Parse for display options
        mlopts mlopts rest, `options'
        _get_diopts diopts, `rest'
	local options `mlopts'
	local initargs `initargs' `constant'

	// Parse select(), tobitselect()
	if "`select'" != "" & "`tobitselect'" != "" {
		opts_exclusive "select() tobitselect()"
	}
	// Setup selection equation.
	if (`"`select'"' != "") {
		local ndv = `ndv' + 1
		_erm_select_parse, equation(`select')
		local sel_depvar `s(depvar)'
		local sel_indepvars `s(indepvars)'
		local sel_constant `s(constant)'
		local sel_offset `s(offset)'
		local sconstant `s(constant)'
		local soffset `s(offset)'
		local sre `s(re)'
		local sel_re 
		SubTreatment, trdepvar(`extr_depvar'`tr_depvar') ///
			invarlist(`sel_indepvars')		 /// 
			constant(`extrconst'`trconst')		 ///
			equation("select")
		local sel_indepvars `r(invarlist)'
		if "`re'" != "" & "`sre'" != "nore" {
			local sel_re re
		}
		if "`sconstant'" == "noconstant" {
			local userecinit 1
		}
		local initargs `initargs' sel_depvar(`sel_depvar') 	///
			sel_indepvars(`sel_indepvars')			///
			sel_constant(`sel_constant')			///
			sel_offset(`sel_offset')	
		local rdinitargs `rdinitargs' sel_depvar(`sel_depvar') 	///
			sel_indepvars(`sel_indepvars')			
		markout `touse' `sel_indepvars'
		if ("`sel_depvar'" != "") {
			markout `touse' `sel_depvar'
			capture assert inlist(`sel_depvar',0,1,.) if `touse'
			if _rc {
				di as error ///
			"{p 0 4 2}invalid specification of {bf:select()}; "
				di as error ///
				"selection variable must be 0/1{p_end}"
				exit 198
			}
			// There may be some select observations for which
			// the depvar is missing.
			qui count if `sel_depvar' == 1 & ///
				missing(`depvar') & `touse'
			if r(N) > 0 {
				local n = r(N)
				di as text  				///
					"{p 0 4 2}`n' observations "	///
					"incorrectly specified " 	///
					"as noncensored in "		///
					"{bf:select()}{p_end}"
			}
			// Drop those observations from the sample.
			qui replace `touse' = 0 if `sel_depvar' == 1 & ///
				missing(`depvar') & `touse'
			tempvar touse2sel
			mark `touse2sel' if `touse'
			markout `touse2sel' `indepvars' ///
				`extr_depvar' `repanvar'
			if "`clvar'" != "" {
				markout `touse2sel' `clvar', strok
			}
			qui replace `touse'=0 if `sel_depvar'==1 & ~`touse2sel'
		}
		else {
			di as error ///
			"{p 0 4 2}invalid specification of {bf:select()}; "
			di as error "selection variable not specified{p_end}"
			exit 198
		}
		qui count if ~`sel_depvar' & `touse'
		if r(N) == 0 {
			di as error "{p 0 4 2}no non-selected observations; "
			di as error "{bf:select()} is not necessary{p_end}"
			exit 498
		}
		local sel_eqn (`sel_depvar':`sel_depvar'=`sel_indepvars' ///
			, `sconstant' `soffset')
		sreturn clear
	}
	else if "`tobitselect'" != "" {
		local ndv = `ndv'+1
		_erm_tselect_parse, equation(`tobitselect')
		local tsel_depvar `s(depvar)'
		local tsel_indepvars `s(indepvars)'
		local sconstant `s(constant)'
		local smain `s(main)'
		local sre `s(re)'
		local sll `s(ll)'
		local sul `s(ul)'
		SubTreatment, trdepvar(`extr_depvar'`tr_depvar') ///
			invarlist(`tsel_indepvars')		 /// 
			constant(`extrconst'`trconst')		 ///
			equation("select")
		local tsel_indepvars `r(invarlist)'
		local tsel_constant `sconstant'
		local tsel_re
		if "`re'" != "" & "`sre'" != "nore" {
			local tsel_re re
		}
		if "`sconstant'" == "noconstant" {
			local userecinit 1
		}
		local atsell `sll'
		local atselu `sul'
		local tsel_main
		if "`smain'" == "main" {
			local tsel_main "main"
			local depvarrd `depvarrd' `tsel_depvar'
		}
		capture _chk_limit "`atsell'" "ll()"
		if _rc {
			di as error ///
			"invalid specification of {bf:tobitselect()};"
			_chk_limit "`atsell'" "ll()"			
		}
		capture _chk_limit "`atselu'" "ul()"
		if _rc {
			di as error ///
			"invalid specification of {bf:tobitselect()};"
			_chk_limit "`atselu'" "ul()"			
		}
		capture assert "`atsell'`atselu'" != "" 
		if _rc {
			di as error ///
			"{p 0 4 2}invalid specification of {bf:tobitselect()};"
			di as error " must specify at least one of "
			di as error "{bf:ll()} or {bf:ul()}{p_end}"
			exit 498
		}
		if "`atsell'" != "" {
			tempvar tsell
			qui gen double `tsell' = `atsell'
		}
		if "`atselu'" != "" {
			tempvar tselu
			qui gen double `tselu' = `atselu'
		}
		if "`tsell'" != "" & "`tselu'" != "" {
			qui count if `tsell' < `tselu' & ///
				~missing(`tsell') & ~missing(`tselu') & `touse'
			local nobs = r(N)
			if _rc {
				di as error ///
			"{p 0 4 2}invalid specification of {bf:tobitselect()}; "
				di as error ///
				"`atsell' > `atselu' in "
				di as error "`nobs' observations{p_end}" 
				exit 498
			}
		}
		tempname tsel_cutoff
		qui gen double `tsel_cutoff' = 0
		local rdinitargs `rdinitargs' sel_depvar(`tsel_depvar') ///
			sel_indepvars(`tsel_indepvars')			
		markout `touse' `tsel_depvar' `tsel_indepvars'
		// tobitselect index
		tempvar tsel_depvarind vtsel_depvarind
		qui gen byte `tsel_depvarind' = 1 if `touse'
		qui gen byte `vtsel_depvarind' = .
		if "`tsell'" != "" {
			qui replace `vtsel_depvarind' = 0 if	///
				`tsel_depvar' <= `tsell' & 	///
				~missing(`tsell') & `touse'
			qui replace `tsel_cutoff' = `tsell' if 	///
				`tsel_depvar' <= `tsell' & 	///
				~missing(`tsell') & `touse'
			qui replace `tsel_depvarind' = 0 if ///
				`tsel_depvar' <= `tsell' &  ///
				~missing(`tsell') & `touse'
		}
		if "`tselu'" != "" {
			qui replace `vtsel_depvarind' = 1 if	///
				`tsel_depvar' >= `tselu' &	///
				~missing(`tselu') & `touse'
			qui replace `tsel_cutoff' = `tselu' if 	///
				`tsel_depvar' >= `tselu' & 	///
				~missing(`tselu') & `touse'
			qui replace `tsel_depvarind' = 0 if ///
				`tsel_depvar' >= `tselu' &  ///
				~missing(`tselu') & `touse'
		}
		// There may be some select observations for which
		// the depvar is missing.
		qui count if `tsel_depvarind' & ///
			missing(`depvar') & `touse'
		if r(N) > 0 {
			local n = r(N)
			di as text  				///
				"{p 0 4 2}`n' observations "	///
				"incorrectly specified " 	///
				"as noncensored in "		///
				"{bf:tobitselect()}{p_end}"
		}
		// Drop those observations from the sample.
		qui replace `touse' = 0 if `tsel_depvarind' & ///
			missing(`depvar') & `touse'
		qui count if ~`tsel_depvarind' & `touse'
		if r(N) == 0 {
			di as error "{p 0 4 2}no non-selected observations; "
			di as error "{bf:tobitselect()} is not necessary{p_end}"
			exit 498
		}

		local tsel_eqn (`tsel_depvar':`tsel_depvar'=`tsel_indepvars' ///
			, `sconstant' `soffset')
		tempvar touse2sel
		mark `touse2sel' if `touse'
		markout `touse2sel' `indepvars' `extr_depvar' `repanvar'
		if "`clvar'" != "" {
			markout `touse2sel' `clvar', strok
		}
		qui replace `touse' = 0 if `tsel_depvarind'==1 & ~`touse2sel'
		if "`tsel_main'" != "" {			
			local indepvars `indepvars' `tsel_depvar'		
		}
		local initargs `initargs' tsel_depvar(`tsel_depvar') 	///
			tsel_indepvars(`tsel_indepvars')		///
			tsel_constant(`tsel_constant')			///
			tsel_offset(`tsel_offset') tsel_ll(`tsell')	///
			tsel_ul(`tselu') tsel_depvarind(`tsel_depvarind')
		sreturn clear
	}
	else {
		markout `touse' `depvar'
	}

	// Finish filling out indepvars
	if "`tr_depvar'" != "" {
		local bn
		if "`constant'" == "noconstant" {
			local bn bn
		}
		if "`tr_interact'" != "" {
			if "`tr_main'" != "" {
				local indepvars ///
				c.(`indepvars')#i.`tr_depvar' i`bn'.`tr_depvar'
			}
			else {
				local indepvars ///
				c.(`indepvars')#i.`tr_depvar' 
			}
		}
		else if "`tr_main'" != "" {			
			local indepvars `indepvars' i`bn'.`tr_depvar'		
		}
	}
	if "`extr_depvar'" != "" {
		local bn
		if "`constant'" == "noconstant" {
			local bn bn
		}		
		if "`extr_interact'" != "" {
			if "`extr_main'" != "" {
				local indepvars ///
				c.(`indepvars')#i.`extr_depvar' ///
				i`bn'.`extr_depvar'
			}
			else {
				local indepvars ///
				c.(`indepvars')#i.`extr_depvar' 
			}
		}
		else if "`extr_main'" != "" {			
			local indepvars `indepvars' i.`bn'`extr_depvar'		
		}
	}


	local initargs `initargs' indepvars(`indepvars')
	local rdinitargs `rdinitargs' indepvars(`indepvars')

	local Cutdvnames 
	local isbigCutnames
	local sbigCutnames
	local fbigCutnames 

	local maxn 2
	// set up treatment levels and oprobit levels
	// Save treatment/switching values.
	if `"`extr_depvar'"' ~= "" {
		tempname extr_vals
		tempvar dvar
		qui gen `dvar' = `extr_depvar'
		qui tab `dvar' if `touse', matrow(`extr_vals')
		matrix `extr_vals' = `extr_vals''
		local extr_n = colsof(`extr_vals')
		local extr_listnum
		local control_value = `extr_vals'[1,1]
		local extr_cuts 
		forvalues i = 1/`extr_n' {
			local x = `extr_vals'[1,`i']
			if !(round(`x',1) == `x' & `x' >= 0) {
				di as error ///
		"{p 0 4 2}invalid specification of {bf:extreat()}; "
				di as error ///
					"treatment variable must be " ///
					"nonnegative integer{p_end}"
					exit 198
			}
			local extr_listnum `extr_listnum' `x'
		}
	}
	if `"`tr_depvar'"' ~= "" {
		tempname tr_vals
		tempvar dtrdepvar
		qui gen `dtrdepvar' = `tr_depvar'
		qui tab `dtrdepvar' if `touse', matrow(`tr_vals')
		matrix `tr_vals' = `tr_vals''
		local tr_n = colsof(`tr_vals')
		local initargs `initargs' tr_vals(`tr_vals') tr_n(`tr_n')
		local maxn = `tr_n'
		local tr_listnum
		local control_value = `tr_vals'[1,1]
		if `tr_n' > 2 {	
			local tr_oprobit oprobit		
		}
		else if `control_value' != 0 {
			local tr_oprobit oprobit
		}
		local tr_cuts 
		local abname = ustrleft(	///
			"`tr_depvar'",32-6)
		if "`tr_oprobit'" != "" {
			local Cutdvnames `Cutdvnames' `abname'
		}
		forvalues i = 1/`tr_n' {
			local x = `tr_vals'[1,`i']
			if !(round(`x',1) == `x' & `x' >= 0) {
				di as error ///
			"{p 0 4 2}invalid specification of {bf:entreat()}; "
				di as error ///
					"treatment variable must be " ///
					"nonnegative integer{p_end}"
					exit 198
			}
			local tr_listnum `tr_listnum' `x'
			if `i' < `tr_n' {
				if "`tr_oprobit'" != "" {
					local isbigCutnames ///
						`isbigCutnames' /t_cut`i'
					local sbigCutnames ///
						`sbigCutnames' /:t_cut`i'
					local fbigCutnames ///
						`fbigCutnames' /`abname':cut`i'
				}
				local tr_cuts `tr_cuts' /cut`i'
			}
		}
		if "`tr_oprobit'" != "" {
			local tr_constant noconstant
		}
		local tr_eqn (`tr_depvar':`tr_depvar' =	///
			`tr_indepvars', `tr_constant' 		///
			`tr_offset')
		local initargs `initargs' tr_oprobit(`tr_oprobit')	
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			tempname oendog_vals`i'
			tempvar dvar
			qui gen `dvar' = `oendog_depvar`i''
			qui tab `dvar' if `touse', ///
				matrow(`oendog_vals`i'')
			matrix `oendog_vals`i'' = `oendog_vals`i'''
			local oendog_n`i' = colsof(`oendog_vals`i'')	
			local initargs `initargs'			///
				oendog_vals`i'(`oendog_vals`i'')	///
				oendog_n`i'(`oendog_n`i'')
			if `oendog_n`i'' > `maxn' {
				local maxn = `oendog_n`i''
			}
		}
		tempname oendog_vals
		matrix `oendog_vals' = J(`noendog',`maxn',.)
		forvalues i = 1/`noendog' {
			local abname = ustrleft(	///
				"`oendog_depvar`i''",32-6)
			local Cutdvnames `Cutdvnames' `abname'
			forvalues j = 1/`oendog_n`i'' {
				matrix `oendog_vals'[`i',`j'] =	///
					`oendog_vals`i''[1,`j']
				if `j' < `oendog_n`i'' {
					local isbigCutnames ///
						`isbigCutnames' /o`i'_cut`j'
					local sbigCutnames ///
						`sbigCutnames' /:o`i'_cut`j'
					local fbigCutnames ///
						`fbigCutnames' ///
						/`abname':cut`j'
				}
			}
		}	
	}
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			tempname bendog_vals`i'
			matrix `bendog_vals`i'' = (0,1)
		}
		tempname bendog_vals
		local bendog`i'_n = 2
		if `bendog_n`i'' > `maxn' {
			local maxn = `bendog`i'_n'
		}
		matrix `bendog_vals' = J(`nbendog',2,.)
		forvalues i = 1/`nbendog' {
			matrix `bendog_vals'[`i',1] = 0
			matrix `bendog_vals'[`i',2] = 1
			local initargs `initargs'			///
			bendog_n`i'(`bnendog_n`i'')
		}	
	}

	local pocovariance_vars
	local has_pocovariance `extr_pocovariance'`tr_pocovariance'
	if "`has_pocovariance'" != "" {
		local pocovariance_vars `extr_depvar'`tr_depvar'
	}
	forvalues i = 1/`nbendog' {
		local has_pocovariance ///
			`has_pocovariance'`bendog_pocovariance`i''
		if "`bendog_pocovariance`i''" != "" {
			local pocovariance_vars `pocovariance_vars' ///
					`bendog_depvar`i'' 
		}
	}
	forvalues i = 1/`noendog' {
		local has_pocovariance ///
			`has_pocovariance'`oendog_pocovariance`i''
		if "`oendog_pocovariance`i''" != "" {
			local pocovariance_vars `pocovariance_vars' ///
					`oendog_depvar`i'' 
		}
	}
	local notepocorrelation 0
	if "`has_pocovariance'" != "" & `ndv' == 1 {
		local has_pocovariance 
		local extr_pocovariance 
		local notepocorrelation 1
	}
	local ns0combos = 0
	local ns1combos = 0
	local ncombos = 0
	// stores all categorical values together
	tempname fcatvals fnvals fbinary
	if "`sel_depvar'" != "" {
		tempname s1binary s1vals s1nvals
		local ncatvars = 2 + (`"`tr_depvar'"'!="")  ///
				+ `nbendog' + `noendog'
		matrix `s1binary' = J(1,2,1)
		matrix `s1vals' = J(1,`ncatvars',0) \ ///
				J(1,`ncatvars',1) 
		if `maxn' > 2 {
			matrix `s1vals' = `s1vals' \ ///
				J(`maxn'-2,`ncatvars',.) 
		}
		matrix `s1nvals' = J(1,`ncatvars',2)
		if (`"`tr_depvar'"'!="") & `"`tr_oprobit'"' != "" {
			matrix `s1binary' = `s1binary',0
			matrix `s1nvals'[1,3] = `tr_n'
			forvalues i = 1/`tr_n' {
				matrix `s1vals'[`i',3] = `tr_vals'[1,`i']
			}
		}
		else if (`"`tr_depvar'"' != "") {
			matrix `s1binary' = `s1binary',1
		}
		if `nbendog' {
			matrix `s1binary' = `s1binary',J(1,`nbendog',1)
		}
		if `noendog' {
			matrix `s1binary' = `s1binary',J(1,`noendog',0)
			forvalues i = 1/`noendog' {
				local k = colsof(`oendog_vals`i'')
				matrix `s1nvals'[1,`ncatvars'-`noendog' ///
					+`i']= `k'
				forvalues j = 1/`k' {				
					matrix `s1vals'[`j',`ncatvars'- ///
						`noendog'+`i'] =	///
						`oendog_vals`i''[1,`j']
				}			
			}
		}
		tempname s0binary s0vals s0nvals			
		mata:st_matrix("`s0binary'",st_matrix(	///
			"`s1binary'")[1,2..`ncatvars'])
		mata:st_matrix("`s0vals'",st_matrix(	///
			"`s1vals'")[1..`maxn',2..`ncatvars'])
		mata:st_matrix("`s0nvals'",st_matrix(	///
			"`s1nvals'")[1,2..`ncatvars'])
		tempvar s0touse s1touse s0catcombo s1catcombo ///
			s0catcombomatind s1catcombomatind
		qui gen `s0touse' = `sel_depvar' == 0 if `touse' 
		GetCatCombos `s0touse' `tr_depvar'		/// 
			`bendog_depvars' `oendog_depvars',	/// 	
			touse(`s0touse')			///
			catcombo(`s0catcombo') 			///
			catcombomatind(`s0catcombomatind')
		qui count if `s0catcombomatind'
		local ns0combos = r(N)
		local s0depvars `sel_depvar' `tr_depvar' `bendog_depvars' ///
			`oendog_depvars'  
		qui gen `s1touse' = `sel_depvar' == 1 if `touse' 
		GetCatCombos `s1touse' `ddepvar' `sel_depvar' `tr_depvar' /// 
			`bendog_depvars' `oendog_depvars',		 /// 	
			touse(`s1touse')				 ///
			catcombo(`s1catcombo') 				 ///
			catcombomatind(`s1catcombomatind')
		qui count if `s1catcombomatind'
		local ns1combos = r(N)
		local s1depvars `ddepvar' `sel_depvar' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'  
		local os1depvars `depvar' `sel_depvar' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'  
		matrix `fcatvals' = `s1vals'
		matrix colnames `fcatvals' = `os1depvars'
		matrix `fnvals' = `s1nvals'
		matrix colnames `fnvals' = `os1depvars'
		matrix `fbinary' = `s1binary'
		matrix colnames `fbinary' = `os1depvars'
		if "`has_pocovariance'" != "" {
			tempvar s1catcombopo s1catcombomatindpo
			GetCatCombos `s1touse' `pocovariance_vars',	/// 	
				touse(`s1touse')			///
				catcombo(`s1catcombopo') 		///
				catcombomatind(`s1catcombomatindpo')		
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`s1catcombopo'",		///
					"`s1catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`touse'",			///
					"`pocovariance_catcombomat'")	
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}
	else if "`tsel_depvar'" != "" {
		tempvar tseldummy
		qui gen byte `tseldummy' = `tsel_depvarind' > 0 if `touse'
		tempname s1binary s1vals s1nvals
		local ncatvars = 2 + (`"`tr_depvar'"'!="")  ///
				+ `nbendog' + `noendog'
		matrix `s1binary' = J(1,2,1)
		matrix `s1vals' = J(1,`ncatvars',0) \ ///
				J(1,`ncatvars',1) 
		if `maxn' > 2 {
			matrix `s1vals' = `s1vals' \ ///
				J(`maxn'-2,`ncatvars',.) 
		}
		matrix `s1nvals' = J(1,`ncatvars',2)
		if (`"`tr_depvar'"'!="") & `"`tr_oprobit'"' != "" {
			matrix `s1binary' = `s1binary',0
			matrix `s1nvals'[1,3] = `tr_n'
			forvalues i = 1/`tr_n' {
				matrix `s1vals'[`i',3] = `tr_vals'[1,`i']
			}
		}
		else if (`"`tr_depvar'"' != "") {
			matrix `s1binary' = `s1binary',1
		}
		if `nbendog' {
			matrix `s1binary' = `s1binary',J(1,`nbendog',1)
		}
		if `noendog' {
			matrix `s1binary' = `s1binary',J(1,`noendog',0)
			forvalues i = 1/`noendog' {
				local k = colsof(`oendog_vals`i'')
				matrix `s1nvals'[1,`ncatvars'-`noendog' ///
					+`i']= `k'
				forvalues j = 1/`k' {				
					matrix `s1vals'[`j',`ncatvars'- ///
						`noendog'+`i'] =	///
						`oendog_vals`i''[1,`j']
				}			
			}
		}
		tempname s0binary s0vals s0nvals			
		mata:st_matrix("`s0binary'",st_matrix(	///
			"`s1binary'")[1,2..`ncatvars'])
		mata:st_matrix("`s0vals'",st_matrix(	///
			"`s1vals'")[1..`maxn',2..`ncatvars'])
		mata:st_matrix("`s0nvals'",st_matrix(	///
			"`s1nvals'")[1,2..`ncatvars'])
		tempvar s0touse s1touse s0catcombo s1catcombo ///
			s0catcombomatind s1catcombomatind
		qui gen `s0touse' = `tseldummy' == 0 if `touse' 
		GetCatCombos `s0touse' `vtsel_depvarind' `tr_depvar'	/// 
			`bendog_depvars' `oendog_depvars',		/// 	
			touse(`s0touse')				///
			catcombo(`s0catcombo') 				///
			catcombomatind(`s0catcombomatind')
		qui count if `s0catcombomatind'
		local ns0combos = r(N)
		local s0depvars `vtsel_depvarind' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'
		qui gen `s1touse' = `tseldummy' == 1 if `touse' 
		GetCatCombos `s1touse' `ddepvar' `tseldummy' `tr_depvar' /// 
			`bendog_depvars' `oendog_depvars',		/// 	
			touse(`s1touse')				///
			catcombo(`s1catcombo') 				///
			catcombomatind(`s1catcombomatind')
		qui count if `s1catcombomatind'
		local ns1combos = r(N)
		local s1depvars `ddepvar' `tseldummy' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'  
		local os1depvars `depvar' `tseldummy' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'  
		matrix colnames `s1vals' = `os1depvars'
		local fcatvalsnames: colfullnames `s1vals'
		local f `fcatvalsnames'
		gettoken f1 f: f, bind
		local final `f1'
		local w = colsof(`s1vals')
		gettoken f1 f: f, bind
		forvalues i = 3/`w' {
			gettoken f1 f: f, bind
			local final `final' `f1'		
		}
		matrix `fcatvals' = `s1vals'[1..(rowsof(`s1vals')),1]
		matrix `fnvals' = `s1nvals'[1,1]
		matrix `fbinary' = `s1binary'[1,1]
		if `w' >= 3 {
			matrix `fcatvals' = `fcatvals',`s1vals'[	///
				1..(rowsof(`s1vals')),3..`w']
			matrix `fnvals' = `fnvals',`s1nvals'[1,3..`w']
			matrix `fbinary' = `fbinary',`s1binary'[1,3..`w']
		}
		matrix colnames `fcatvals' = `final'
		matrix colnames `fnvals' = `final'
		matrix colnames `fbinary' = `final'
		if "`has_pocovariance'" != "" {
			tempvar s1catcombopo s1catcombomatindpo
			GetCatCombos `s1touse' `pocovariance_vars',	/// 	
				touse(`s1touse')			///
				catcombo(`s1catcombopo') 		///
				catcombomatind(`s1catcombomatindpo')
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`s1catcombopo'",		///
					"`s1catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`touse'",			///
					"`pocovariance_catcombomat'")
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}
	else {
		local catdepvars `ddepvar' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'
		local ocatdepvars `depvar' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'
		tempname catbinary catvals catnvals
		matrix `catbinary' = J(1,1,1)
		matrix `catvals' = J(1,1 + (`"`tr_depvar'"'!="")  ///
				+ `nbendog' + `noendog',0) \ ///
				J(1,1 + (`"`tr_depvar'"'!="")  ///
				+ `nbendog' + `noendog',1) 
		if `maxn' > 2 {
			matrix `catvals' = `catvals' \ ///
				J(`maxn'-2,1 + (`"`tr_depvar'"'!="")  ///
				+ `nbendog' + `noendog',.) 
		}
		matrix `catnvals' = J(1,1 + (`"`tr_depvar'"'!="")  ///
				+ `nbendog' + `noendog',2)
		if (`"`tr_depvar'"'!="") & `"`tr_oprobit'"' != "" {
			matrix `catbinary' = `catbinary',0
			matrix `catnvals'[1,2] = `tr_n'
			forvalues i = 1/`tr_n' {
				matrix `catvals'[`i',2] = `tr_vals'[1,`i']
			}
		}
		else if (`"`tr_depvar'"' != "") {
			matrix `catbinary' = `catbinary',1
		}
		if `nbendog' {
			matrix `catbinary' = `catbinary',J(1,`nbendog',1)
		}
		if `noendog' {
			matrix `catbinary' = `catbinary',J(1,`noendog',0)
			forvalues i = 1/`noendog' {
				local k = colsof(`oendog_vals`i'')
				matrix `catnvals'[1,1+		///
					("`tr_depvar'"!="")+	///
					`nbendog'+`i']	= `k'
				forvalues j = 1/`k' {				
					matrix `catvals'[`j',1+	///
					("`tr_depvar'"!="")+	///
					`nbendog'+`i'] =	///
					`oendog_vals`i''[1,`j']
				}			
			}
		}
		tempvar catcombo catcombomatind
		GetCatCombos `touse' `ddepvar' `tr_depvar'	/// 
			`bendog_depvars' `oendog_depvars',	/// 	
			touse(`touse')				///
			catcombo(`catcombo') 			///
			catcombomatind(`catcombomatind')
		qui count if `catcombomatind'
		local ncombos = r(N)
		matrix `fcatvals' = `catvals'
		matrix colnames `fcatvals' = `ocatdepvars'
		matrix `fnvals' = `catnvals'
		matrix colnames `fnvals' = `ocatdepvars'
		matrix `fbinary' = `catbinary'
		matrix colnames `fbinary' = `ocatdepvars'
		if "`has_pocovariance'" != "" {
			tempvar catcombopo catcombomatindpo
			GetCatCombos `touse' `pocovariance_vars',	/// 	
				touse(`touse')				///
				catcombo(`catcombopo') 			///
				catcombomatind(`catcombomatindpo')	
			tempvar pocovariance_depvar
			tempname pocovariance_catcombomat
			qui gen byte `pocovariance_depvar' = .
			mata: filltreat("`pocovariance_depvar'",	///
					"`catcombopo'",			///
					"`catcombomatindpo'",		///
					"`pocovariance_vars'",		///
					"`touse'",			///
					"`pocovariance_catcombomat'")
			local pocovariance_n = ///
				rowsof(`pocovariance_catcombomat')
			tempname pocovariance_vals
			mata: st_matrix("`pocovariance_vals'",	///
				(1..`pocovariance_n'))
		}
	}
	local wexp `weight'`exp'
	if ("`wexp'" != "") {
                local wexp [`wexp']
	}
 	local initargs `initargs' noendog(`noendog') ///
		nbendog(`nbendog') nendog(`nendog') touse(`touse') wexp(`wexp')
 	local rdinitargs `rdinitargs' depvar(`depvarrd')		/// 
		noendog(`noendog')					///
		nbendog(`nbendog') nendog(`nendog') touse(`touse')	///
		bendog_depvars(`bendog_depvars') 			///
		oendog_depvars(`oendog_depvars') 			///
		endog_depvars(`endog_depvars')	 
	_erm_ranking_dvlist, `rdinitargs'
	local userecinit = `userecinit' | `r(userecinit)'
	local fdepvar_dvlistmacs 
	local depvar_dvlist `r(depvar_dvlist)'
	local adepvar_dvlist `r(adepvar_dvlist)'
	local podepvar_dvlist `r(podepvar_dvlist)'
	local treatrecursive `r(treatrecursive)'
	if "`select'" != "" {
		local sel_dvlist `r(sel_dvlist)'
	}
	else if "`tobitselect'" != "" {
		local tsel_dvlist `r(sel_dvlist)'
	}
	local tr_dvlist `r(tr_dvlist)'
	local tselinlist 0
	if "`tr_dvlist'" != "" & "`tsel_depvar'" != "" {
		local tselinlist: list tsel_depvar in tr_dvlist
	}
	if `tselinlist' {
		di as error "{p 0 4 2}invalid specification of "
		di as error "{bf:entreat()}; tobit selection "
		di as error "indicator only allowed in main "
		di as error "equation{p_end}"
		exit 498
	}	
	forvalues i = 1/`nbendog' {
		local bendog_dvlist`i' `r(bendog_dvlist`i')'
		local tselinlist 0
		if "`bendog_dvlist`i''" != "" & "`tsel_depvar'" != "" {
			local tselinlist: list tsel_depvar in bendog_dvlist`i'
		}
		if `tselinlist' {
			di as error "{p 0 4 2}invalid specification of "
			di as error "{bf:endogenous()}; tobit selection "
			di as error "indicator only allowed in main "
			di as error "equation{p_end}"
			exit 498
		}
	}
	forvalues i = 1/`noendog' {
		local oendog_dvlist`i' `r(oendog_dvlist`i')'
		local tselinlist 0
		if "`oendog_dvlist`i''" != "" & "`tsel_depvar'" != "" {
			local tselinlist: list tsel_depvar in oendog_dvlist`i'
		}
		if `tselinlist' {
			di as error "{p 0 4 2}invalid specification of "
			di as error "{bf:endogenous()}; tobit selection "
			di as error "indicator only allowed in main "
			di as error "equation{p_end}"
			exit 498
		}
	}
	forvalues i = 1/`nendog' {
		local endog_dvlist`i' `r(endog_dvlist`i')'
		local tselinlist 0
		if "`endog_dvlist`i''" != "" & "`tsel_depvar'" != "" {
			local tselinlist: list tsel_depvar in endog_dvlist`i'
		}
		if `tselinlist' {
			di as error "{p 0 4 2}invalid specification of "
			di as error "{bf:endogenous()}; tobit selection "
			di as error "indicator only allowed in main "
			di as error "equation{p_end}"
			exit 498
		}
	}
	local fdepvar_dvlistmacs
	foreach w of local adepvar_dvlist {
		if "`w'" == "`tsel_depvar'" {
			local fdepvar_dvlistmacs ///
				`fdepvar_dvlistmacs' tsel_dvlist
		}
		if "`w'" == "`tr_depvar'" {
			local fdepvar_dvlistmacs `fdepvar_dvlistmacs' tr_dvlist
		}
		if "`w'" == "`sel_depvar'" {
			local fdepvar_dvlistmacs ///
				`fdepvar_dvlistmacs' sel_dvlist
		}
		forvalues i = 1/`nbendog' {
			if "`w'" == "`bendog_depvar`i''" {
				local fdepvar_dvlistmacs ///
					`fdepvar_dvlistmacs' bendog_dvlist`i'
			}
		}
		forvalues  i = 1/`noendog' {
			if "`w'" == "`oendog_depvar`i''" {
				local fdepvar_dvlistmacs ///
					`fdepvar_dvlistmacs' oendog_dvlist`i'
			}
		}
		forvalues i = 1/`nendog' {
			if "`w'" == "`endog_depvar`i''" {
				local fdepvar_dvlistmacs ///	
					`fdepvar_dvlistmacs' endog_dvlist`i'
			}
		}
	}
	local risbigVnames
	local rsbigVnames
	local rfbigVnames
	local isbigVnames
	local sbigVnames
	local fbigVnames
	local dvlist `depvar'`depvarl' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' `bendog_depvars' `oendog_depvars' 	///
			`endog_depvars'
	local intdvlist `depvar' `tsel_depvar' `sel_depvar' `tr_depvar' ///
			`bendog_depvars' `oendog_depvars'
	local nintdims = wordcount("`intdvlist'")
	local msg0 "; no integration dimensions"
	local msg1 "; only `nintdims' integration dimension"
	local msgn "; only `nintdims' integration dimensions"
	if `intpoints3spec' & `nintdims' == 0 {
		di as text ///
		"note: {bf:triintpoints()} ignored`msg0'"
	}
	else if `intpoints3spec' & `nintdims' == 1 {
		di as text ///
		"note: {bf:triintpoints()} ignored`msg1'"
	}
	else if `intpoints3spec' & `nintdims' < 3 {
		di as text ///
		"note: {bf:triintpoints()} ignored`msgn'"
	}
	if `intpointsspec' & `nintdims' == 0 {
		di as text ///
		"note: {bf:intpoints()} ignored`msg0'"
	}
	else if `intpointsspec' & `nintdims' ==1 {
		di as text ///
		"note: {bf:intpoints()} ignored`msg1'"
	}
	else if `intpointsspec' & `nintdims' < 4 {
		di as text ///
		"note: {bf:intpoints()} ignored`msgn'"
	}
	local varcnt = wordcount("`dvlist'")
	if "`re'" != "" {
		local risbigVnames `risbigVnames' /rv_o
		local rsbigVnames `rsbigVnames' /:rv_o
		local rfbigVnames `rfbigVnames' /:var(`depvar'[`repanvar'])
		if "`sel_depvar'" != "" {
			if "`sel_re'" != "" {
				local risbigVnames `risbigVnames' /rv_sel
				local rsbigVnames `rsbigVnames' /:rv_sel
				local rfbigVnames `rfbigVnames' ///
					/:var(`sel_depvar'[`repanvar'])
				local relist `relist' 1
			}
			else {
				local relist `relist' 0
			}
		}
	}
	if "`tsel_depvar'" != "" {
		local isbigVnames `isbigVnames' /v_tsel
		local sbigVnames `sbigVnames' /:v_tsel
		local fbigVnames `fbigVnames' /:var(e.`tsel_depvar')		
		if "`re'" != "" {
			if "`tsel_re'" != "" {
				local risbigVnames `risbigVnames' /rv_tsel
				local rsbigVnames `rsbigVnames' /:rv_tsel
				local rfbigVnames `rfbigVnames' ///
					/:var(`tsel_depvar'[`repanvar'])
				local relist `relist' 1
			}
			else {
				local relist `relist' 0
			}
		}
	}
	if "`tr_depvar'" != "" & "`tr_re'" != "" {
		local risbigVnames `risbigVnames' /rv_tr
		local rsbigVnames `rsbigVnames' /:rv_tr
		local rfbigVnames `rfbigVnames' ///
			/:var(`tr_depvar'[`repanvar'])
		local relist `relist' 1
	}
	else if "`tr_depvar'" != "" & "`re'"!= "" {
		local relist `relist' 0
	}
	if `nbendog' > 0 & "`re'" != "" {
		local vardvlist `bendog_depvars'
		local i = 1
		foreach w of local vardvlist {
			if "`bendog_re`i''" != "" {
				local risbigVnames `risbigVnames' /rv_b`i'
				local rsbigVnames `rsbigVnames' /:rv_b`i'
				local rfbigVnames `rfbigVnames' ///
					/:var(`bendog_depvar`i''[`repanvar'])
				local relist `relist' 1
			}
			else {
				local relist `relist' 0
			}
			local i = `i'+1
		}
	}
	if `noendog' > 0 & "`re'" != "" {
		local vardvlist `oendog_depvars'
		local i = 1
		foreach w of local vardvlist {
			if "`oendog_re`i''" != "" {
				local risbigVnames `risbigVnames' /rv_o`i'
				local rsbigVnames `rsbigVnames' /:rv_o`i'
				local rfbigVnames `rfbigVnames' ///
					/:var(`oendog_depvar`i''[`repanvar'])
				local relist `relist' 1
			}
			else {
				local relist `relist' 0
			}
			local i = `i'+1
		}
	}
	local vardvlist `endog_depvars'
	local i = 1
	foreach w of local vardvlist {
		local isbigVnames `isbigVnames' /v_`i'
		local sbigVnames `sbigVnames' /:v_`i'
		local fbigVnames `fbigVnames' /:var(e.`endog_depvar`i'')
		if "`re'" != "" {
			if "`endog_re`i''" != "" {
				local risbigVnames `risbigVnames' /rv_`i'
				local rsbigVnames `rsbigVnames' /:rv_`i'
				local rfbigVnames `rfbigVnames' ///
					/:var(`endog_depvar`i''[`repanvar'])
				local relist `relist' 1
			}
			else {
				local relist `relist' 0
			}
		}
		local i = `i' + 1
	}
	if "`has_pocovariance'" == "" {
		forvalues i = 1/`varcnt' {
			local ip1 = `i' + 1
			forvalues j =`ip1'/`varcnt' {
				local dvi: word `i' of `dvlist'
				local dvj: word `j' of `dvlist'
				local sbigVnames `sbigVnames'	///
					/:c_`j'_`i'
				local isbigVnames `isbigVnames'	///
					/c_`j'_`i'
				local fbigVnames `fbigVnames'	///
					/:corr(e.`dvj',e.`dvi')
			}
		}
	}
	else {
		local factlist
		if "`extr_pocovariance'`tr_pocovariance'" != "" {
			local factlist i`bn'.`extr_depvar'`tr_depvar'#
		}
		forvalues i = 1/`nbendog' {
			if `"`bendog_pocovariance`i''"' != "" {
				local factlist `factlist'i.`bendog_depvar`i''#
			}
		}
		forvalues i = 1/`noendog' {
			if `"`oendog_pocovariance`i''"' != "" {
				local factlist `factlist'i.`oendog_depvar`i''#
			}
		}
		local factlist = substr("`factlist'",1,length("`factlist'")-1)
		fvexpand `factlist' if `touse'
		local factlist `r(varlist)'
		local i = 1
		local ip1 = `i' + 1
		local f = 1
		local ofactlist `factlist'
		forvalues j=`ip1'/`varcnt' {
			local factlist `ofactlist'
			forvalues l = 1/`pocovariance_n' {
			local dvi: word `i' of `dvlist'
			local dvj: word `j' of `dvlist'
			local sbigVnames `sbigVnames' ///
				/:c_`j'_`i'_`l'
			local isbigVnames `isbigVnames' ///
				/c_`j'_`i'_`l'
			local val = `l'
			gettoken fact factlist: factlist
			local fbigVnames `fbigVnames' ///
				/corr(e.`dvj',e.`dvi'):`fact'
			}
		}		
		forvalues i = 2/`varcnt' {
			local ip1 = `i' + 1
			forvalues j =`ip1'/`varcnt' {
				local dvi: word `i' of `dvlist'
				local dvj: word `j' of `dvlist'
				local sbigVnames `sbigVnames'	///
					/:c_`j'_`i'
				local isbigVnames `isbigVnames'	///
					/c_`j'_`i'
				local fbigVnames `fbigVnames'	///
					/:corr(e.`dvj',e.`dvi')
			}
		}
	}
	if "`re'" != "" {
		ReListMat, listmat(`relist')
		tempname relistmat
		matrix `relistmat' = r(relistmat)
		local nredv = subinstr("`relist'"," ","+",.)
		local nredv = `nredv'
		forvalues i = 1/`varcnt' {
			local ip1 = `i'+1
			forvalues j = `ip1'/`varcnt' {
				local dvi: word `i' of `dvlist'
				local dvj: word `j' of `dvlist'
				if `relistmat'[1,`j'] & `relistmat'[1,`i'] {
					local rsbigVnames `rsbigVnames' ///
						/:rc_`j'_`i'
					local risbigVnames ///
						`risbigVnames' /rc_`j'_`i'
					local dvj `dvj'[`repanvar']
					local dvi `dvi'[`repanvar']
					local rfbigVnames	///
						`rfbigVnames'	///
						 /:corr(`dvj',`dvi')
				}
			}
		}		
	}
	if "`clvar'" != "" & "`re'" != "" {
		 _xtreg_chk_cl2 `clvar' `repanvar' `touse'	
	}
	if ("`tr_depvar'" != "" | "`sel_depvar'" != "" 	///
		| "`tsel_depvar'" != "" |		///
		(`noendog' + `nbendog' + `nendog' > 0)) & "`from'" == "" {
		if `userecinit' | "`tobitselect'" != "" ///
			| ("`trconst'`extrconst'" == "0") | "`re'" != "" {
			if "`re'" != "" {
				//capture qui 
				_erm_get_initvals_rec_re ///
				`initargs' ermcmd(eprobit)		
			}
			else {
				capture qui _erm_get_initvals_rec ///
					`initargs' ermcmd(eprobit)
			}
		}
		else {
	 		capture qui _eprobit_get_initvals `initargs'
		}
		local rc = _rc
		if `rc' {
			if `rc' != 1 {
				di as error "{p 0 4 2}could not calculate "
				di as error "initial values; try specifying "
				di as error "{bf:from()}{p_end}"
			}
			else {
				error `rc'
			}
			exit `rc'
		}
		tempname ibigB
		matrix `ibigB' = r(bigB)
		if "`re'" != "" {
			tempname inibigB
			matrix `inibigB' = J(1,colsof(`ibigB'),1)
			local nparms = colsof(`ibigB')
			local kindex = colsof(`ibigB')-	///
				(`varcnt'*(`varcnt'+1)/2) 
			local k2 = 1
			forvalues i = 1/`varcnt' {
				if ~`relistmat'[1,`i'] {
					matrix `inibigB'[1,`kindex'+`i'] = 0
					local nparms = `nparms'-1	
				}
				local ip1 = `i'+1
				local k = `kindex'+`varcnt'+`k2'
				forvalues j = `ip1'/`varcnt' {
					if (~`relistmat'[1,`i']) | ///
						(~`relistmat'[1,`j']) {
						matrix `inibigB'[1,`k'] = 0
						local nparms = `nparms'-1
					}
					local k = `k' + 1
					local k2 = `k2' + 1
				}
			}
			tempname tmpibigB
			matrix `tmpibigB' = J(1,`nparms',.)
			local f: colfullnames `ibigB'
			local fnew
			local k = 1
			local kall = colsof(`ibigB')
			forvalues i=1/`kall' { 	
				if `inibigB'[1,`i'] {
					matrix `tmpibigB'[1,`k'] = ///
						`ibigB'[1,`i']
					local wi: word `i' of `f'
					local fnew `fnew' `wi'
					local k = `k' + 1
				}
			}
			matrix `ibigB' = `tmpibigB'
			matrix colnames `ibigB' = `fnew'
		}
		if "`has_pocovariance'" != "" {
			if "`re'" == "" {
				local krest = (`varcnt'-1)*`varcnt'/2 - ///
					(`varcnt'-1)
				local ktr = `pocovariance_n'*(`varcnt'-1)
				local kf = colsof(`ibigB')-(`varcnt'-1)-`krest'
				tempname newB
				matrix `newB' = `ibigB'[1,1..`kf']
				forvalues i = 1/`pocovariance_n' {
					if `varcnt' > 1 {
						local kf1 = `kf'+1
						local kf2 = `kf' + `varcnt'-1
						matrix `newB' ///
							= `newB', ///
							`ibigB'[1,`kf1'..`kf2']
					}
				}
				local kf1 = `kf'+(`varcnt'-1) +1
				local kf2 = colsof(`ibigB')
				if (`kf1'<=`kf2') {
					matrix `newB' = `newB',	///
						`ibigB'[1,`kf1'..`kf2']
				}
				// permute it
				tempname invperm 
				PoResort `newB' `ndv' ///
					`pocovariance_n' `invperm'
				matrix `ibigB' = `newB'	
			}
			else {
				local krest = (`varcnt'-1)*`varcnt'/2 - ///
					(`varcnt'-1)
				local kf = colsof(`ibigB')-(`varcnt'-1)- ///	
					`krest'-`nredv'*(`nredv'+1)/2
				tempname newB
				matrix `newB' = `ibigB'[1,1..`kf']
				forvalues i = 1/`pocovariance_n' {
					if `varcnt' > 1 {
						local kf1 = `kf'+1
						local kf2 = `kf' + `varcnt'-1
						matrix `newB' ///
							= `newB', ///
							`ibigB'[1,`kf1'..`kf2']
					}
				}
				local kf1 = `kf'+(`varcnt'-1) +1
				local kf2 = colsof(`ibigB')- ///
					`nredv'*(`nredv'+1)/2
				if (`kf1'<=`kf2') {
					matrix `newB' = `newB',	///
						`ibigB'[1,`kf1'..`kf2']
				}
				// permute it
				tempname invperm 
				PoResort `newB' `ndv' ///
					`pocovariance_n' `invperm'
				local kf1 = colsof(`ibigB')-	///
					`nredv'*(`nredv'+1)/2 + 1
				local kf2 = colsof(`ibigB')
				matrix `newB' = `newB',`ibigB'[1,`kf1'..`kf2']
				matrix `ibigB' = `newB'
			}
		}
		local f: colfullnames `ibigB'
		local w = wordcount("`isbigVnames' `risbigVnames'")
		local wf = wordcount("`f'")
		local fnew 
		local ws = `wf' - `w'
		forvalues i = 1/`ws' {
			gettoken fnewi f: f
			local fnew `fnew' `fnewi'
		}
		local fnew `fnew' `sbigVnames' `rsbigVnames'
		matrix colnames `ibigB' = `fnew'
	}
	else if "`from'" == "" {
		if "`re'" == "" {
			capture qui probit `depvar' `indepvars' ///
				if `touse' `wexp', 		///
				`constant' `offset' notable 	///
				noheader `constraints' `vce' 	///	
				`log' `technique' iter(0)
		}
		else {
			capture qui xtprobit `depvar' `indepvars'	///
				if `touse' `wexp', `constant' 		///
				`offset' `constraints' 			///
				`vce' `log' iter(0)
		}
		local rc = _rc
		if `rc' {
			if `rc' != 1 {
				di as error ///
				"{p 0 4 2}could not calculate initial "
				di as error ///
				"values; try specifying {bf:from()}{p_end}"
			}
			else {
				error `rc'
			}
			exit `rc'
		}
		tempname ibigB
		matrix `ibigB' = e(b)

		if "`re'" != "" {
			local colsibigB = colsof(`ibigB')
			matrix `ibigB'[1,`colsibigB'] = (e(sigma_u))^2
			local f: colnames `ibigB'
			local colsibigB = `colsibigB'-1
			local fnames
			forvalues i = 1/`colsibigB' {
				gettoken fname f: f
				local fnames `fnames' `depvar':`fname'
			}
			local fnames `fnames' /:rv_o
			matrix colnames `ibigB' = `fnames'
			local f: colnames `ibigB'
			local w = wordcount("`risbigVnames'")
			local wf = wordcount("`f'")
			local fnew
			local ws = `wf'-`w'
			forvalues i = 1/`ws' {
				gettoken fnewi f: f
				local fnew `fnew' `fnewi'
			}
			local fnew `fnew' `rsbigVnames'
			matrix colnames `ibigB' = `fnew'
		}
	}
	local fromused = 1
	if "`from'" == "" {
		if "`re'" != "" {
			local from init(`ibigB', copy)  search(off) 
		}
		else {
			local from init(`ibigB')  search(off) 
		}
		local fromused =0
	}
	else {
		ParseFrom `from'
		if "`s(copy)'" != "" {
			local from `s(from)', `s(copy)' `s(skip)'
			if "`constraints'" != "" {
				di as error "{p 0 4 2}{bf:constraints()} "
				di as error "not allowed with "
				di as error "{bf:from(,copy)}{p_end}"
				exit 198
			}
		}
		else {
			local from `s(from)'
			local skip `s(skip)'
			local k = colsof(`from')
			local ffbigVnames = ///
				subinstr("`fbigVnames' `rfbigVnames'",":","",.)
			SubCut, cuts(`fbigCutnames') ///
				dvnames(`Cutdvnames')
			local ffbigCutnames `r(subbed)'
			local oldnamesfrom: colfullnames `from'
			local ooldnamesfrom `oldnamesfrom'
			local kcut = wordcount("`ffbigCutnames'")
			local kvar = wordcount("`ffbigVnames'")
			local newnamesfrom
			forvalues i = 1/`k' {
				gettoken oldname oldnamesfrom: oldnamesfrom
				local act
				forvalues j = 1/`kcut' {
					local comp: word `j' of `fbigCutnames'
					if "`oldname'" == "`comp'" {
						local act: word `j' ///
							of `sbigCutnames'
						continue, break
					}	
				}
				forvalues j = 1/`kvar' {
					local comp: word `j' of ///
					`fbigVnames' `rfbigVnames'
					if subinstr("`oldname'","/","/:",.) ///
						== "`comp'" {
						local act: word `j' ///
							of `sbigVnames' ///
							`rsbigVnames'
						continue, break
					}					
				}
				if "`act'" == "" {
					local act `oldname'
				}
				local newnamesfrom `newnamesfrom' `act'
			}
			tempname frommat
			matrix `frommat' = `from'
			matrix colnames `frommat' = `newnamesfrom'
			local from `frommat',`skip'
			if "`constraints'" != "" & "`skip'" != "" {
				di as error "{p 0 4 2}{bf:constraints()} "
				di as error ///
				"not allowed with {bf:from(,skip)}{p_end}"
				exit 198
			}
		}		
		local from init(`from') search(on)
	}
	nobreak {
		if "`has_pocovariance'" == "" {
			mata: _eprobit_init(  "inits",			///
                                "`depvar'","`sel_depvar'",		///
				"`tr_depvar'",				///
				`nendog',`nbendog',`noendog',		///
				"`s1depvars'",				///
				"`s1vals'",				///
				"`s1nvals'",				///
				"`s1binary'",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`s0depvars'",				///
	 			"`s0vals'",				///
				"`s0nvals'",				///
				"`s0binary'",				///
				"`s0catcombo'",				///
				"`s0catcombomatind'",			///
				"`catdepvars'",				///
	 			"`catvals'",				///
				"`catnvals'",				///
				"`catbinary'",				///
				"`catcombo'",				///
				"`catcombomatind'",			///
				"`touse'",				///
				`intpoints',`intpoints3',		///
				"`tsel_depvarind'","`tsel_cutoff'",	///
				"`repanvar'",`reintpoints',`ndv',	///
				"`adaptlog'","`relistmat'")
			if "`re'" == "" {
				local evaluator _eprobit_lf()
			}
			else {
				if "`reintmethod'" == "mvaghermite" {
					local evaluator _eprobit_lf_re_agh()
				}
				else {
					local evaluator _eprobit_lf_re_re1()
				}
			}
		}
		else {
			mata: _eprobit_treat_init(`pocovariance_n',	///
				  "inits",				///
                                "`depvar'","`sel_depvar'",		///
				"`pocovariance_depvar'",		///
				`nendog',`nbendog',`noendog',		///
				"`s1depvars'",				///
				"`s1vals'",				///
				"`s1nvals'",				///
				"`s1binary'",				///
				"`s1catcombo'",				///
				"`s1catcombomatind'",			///
				"`s0depvars'",				///
	 			"`s0vals'",				///
				"`s0nvals'",				///
				"`s0binary'",				///
				"`s0catcombo'",				///
				"`s0catcombomatind'",			///
				"`catdepvars'",				///
	 			"`catvals'",				///
				"`catnvals'",				///
				"`catbinary'",				///
				"`catcombo'",				///
				"`catcombomatind'",			///
				"`touse'",				///
				`intpoints',`intpoints3',		///
				"`tsel_depvarind'","`tsel_cutoff'",	///
				"`pocovariance_vals'",			///
				"`repanvar'",`reintpoints',`ndv',	///
				"`adaptlog'","`relistmat'")
			if "`re'" == "" {
				local evaluator _eprobit_tr_lf()
			}
			else {
				if "`reintmethod'" == "mvaghermite" {
					local evaluator _eprobit_tr_lf_re_agh()
				}
				else {
					local evaluator _eprobit_tr_lf_re_re1()
				}
			}
		}
		if "`re'" != ""	{
			tempname N_g g_min g_avg g_max
			GetPanN, touse(`touse') repanvar(`repanvar')
			scalar `N_g' = r(N_g)
			scalar `g_min' = r(g_min)
			scalar `g_avg' = r(g_avg)
			scalar `g_max' = r(g_max)
		}
        capture noisily break  {
		if "`estimate'" != "noestimate" {
			if "`constraints'" != "" {
				local cnpre: colfullnames `ibigB'`frommat'
				local totp = colsof(`ibigB'`frommat')
				local totvp: word count ///
					`fbigVnames' `rfbigVnames'
				local totcut: word count `fbigCutnames'
				local cnfull
				local tothere = `totp' - `totvp' - `totcut'
				forvalues i = 1/`tothere' {
					gettoken name cnpre: cnpre
					local cnfull `cnfull' `name'
				}
				local cnfull `cnfull' `fbigCutnames' ///
					`fbigVnames' `rfbigVnames'
				tempname ibigB2
				matrix `ibigB2' = `ibigB'`frommat'
				matrix colnames `ibigB2' = `cnfull'
				tempvar touse2
				qui gen byte `touse2' = `touse'
				DummyPost, init(`ibigB2') touse(`touse2') ///
					`constraints'
				tempname eCns
				matrix `eCns' = e(Cns)	
				local f: colfullnames `ibigB'`frommat'
				matrix colnames `eCns' = `f' _Cns:_r
				local constraintopt constraints(`eCns')
			}
            ml model `evaltype' `evaluator'	        ///
                        (`depvar': `depvar' = `indepvars',	///
                                `constant' `offset')		///
			`tsel_eqn' `sel_eqn' `tr_eqn' 		///
			`bendog_eqns'				///
			`oendog_eqns' `endog_eqns' 		///
			`isbigCutnames'	`isbigVnames'		///
			`risbigVnames'				///
                        if `touse' `wexp',     			///
                        maximize `options' `vce'  		///
                        `from' `log' `technique' nopreserve     ///
                        userinfo(`inits') missing 		///
			`constraintopt' 			///
			group(`repanvar')
		}
		else {
			DummyPost, init(`ibigB') touse(`touse')
		}
		tempname b borig Vorig
		matrix `b' = e(b)
		matrix `borig' = `b'
		matrix `Vorig' = e(V)
		local cnpre: colfullnames `b'           
		local totp = colsof(`b')
		local totvp: word count `fbigVnames' `rfbigVnames'
		local totcut: word count `fbigCutnames'
		local cnfull
		local tothere = `totp' - `totvp' - `totcut'
		forvalues i = 1/`tothere' {
			gettoken name cnpre: cnpre
			local cnfull `cnfull' `name'
		}
		local cnfull `cnfull' `fbigCutnames' `fbigVnames' `rfbigVnames'
		matrix colnames `b' = `cnfull'
		local k = colsof(`b')
		local ordlist
		if "`tr_oprobit'" != "" {
			local ordlist `tr_depvar' 
		}
		local ordlist `ordlist' `oendog_depvars'
		tempname btmp
		tempname btmporig 
		matrix `btmporig' = e(b)
		tempname b_midx
		local varcoraux = ustrwordcount("`isbigVnames' `risbigVnames'")
		local nobs = e(N)
		matrix `b_midx' = J(1,`k',1)
		matrix `btmp' = `b'
		local fvignorefirst = 0
		local ndepvar = e(k_dv)
		ereturn repost b = `b', rename buildfvinfo noHmat
		mata:_erm_fvinfo("`btmp'","`b_midx'",	///
			`fvignorefirst',`varcoraux', 		///
			"`ordlist'",`nobs',`ndepvar')
		local kauxcut: word count `isbigCutnames'
		local kaux: word count	`isbigCutnames'	///
			`isbigVnames' `risbigVnames'
		tempname pclass
		matrix `pclass' = J(1,`k',0)
		local kaux0 = `k' - `kaux' +1
		local kaux1 = `k'-(`kaux'-`kauxcut')
		forvalues i = `kaux0'/`kaux1' {
			matrix `pclass'[1,`i'] = 2
		}
		local kaux1 = `k'-(`kaux'-`kauxcut')+1
		local kaux2 = `kaux1'+("`tsel_depvar'"!= "")+`nendog'-1
		forvalues i = `kaux1'/`kaux2' {
			matrix `pclass'[1,`i'] = 4
		}
		local kaux2 = `kaux2' + 1
		forvalues i = `kaux2'/`k' {
			matrix `pclass'[1,`i'] = 6
		}
		if "`re'" != "" {
			local rvwords: word count `risbigVnames'
			local kaux1 = `k'-`rvwords'+1
			local kaux2 = `kaux1' + `nredv'-1
			forvalues i = `kaux1'/`kaux2' {
				matrix `pclass'[1,`i'] = 4
			}
			local kaux1 = `kaux2'+1
			forvalues i = `kaux1'/`k' {
				matrix `pclass'[1,`i'] = 6
			}
		}
		matrix colnames `pclass' = `cnfull'
		ereturn matrix b_pclass = `pclass'
		ereturn scalar k_aux = `kaux'		
		local keq = e(k_eq)
		local kd = `keq' - `kaux' + `kauxcut'
		if `nendog' > 0 {
			forvalues i = 1/`nendog' {
				local j = `kd' + `i'
				capture ereturn hidden local ///
					diparm_opt`j' noprob
			}
		}
		if "`sel_depvar'`tsel_depvar'" != "" {
			qui count if e(sample) & ///
				~(`sel_depvar'`tsel_depvarind')
			tempname tn 
			scalar `tn' = r(N)
			ereturn scalar N_nonselected = `tn'
			qui count if e(sample)
			ereturn scalar N_selected = r(N) - `tn'
		}
		if "`re'" == "" {
			ereturn local cmd eprobit
		}
		else {
			ereturn local cmd xteprobit
			ereturn local ivar `repanvar'
			ereturn hidden local group `e(group)'
		}
		ereturn local cmdline `cmdline'
		ereturn hidden matrix b_midx = `b_midx', copy
		if "`ordlist'" != "" {
			local marginsprop `allcons' addcons nochainrule	
		}
		else {
			local marginsprop `allcons' nochainrule
		}
		local ctprops selected
		if "`re'" != "" {
			local ctprops `ctprops' pushtitle groups balance
		}
		ereturn hidden local _coef_table_props `ctprops'
		ereturn hidden local ordinalvars `ordlist'
		ereturn hidden local quadchk = 0
		local alllist `dvlist'
		local w = wordcount("`alllist'") 
		tempname ordinalvarmat
		mata: st_matrix("`ordinalvarmat'",J(1,`w',0))
		forvalues i = 1/`w' {
			local comp: word `i' of `alllist'
			foreach word of local ordlist {
				if "`comp'" == "`word'" {
					matrix `ordinalvarmat'[1,`i'] = 1
				}
			}		
		}
		ereturn hidden matrix isordinalvar = `ordinalvarmat',copy
		ereturn hidden scalar intpoints = `intpoints'
		ereturn hidden scalar intpoints3 = `intpoints3'
		ereturn hidden local tr_oprobit `tr_oprobit'
		ereturn hidden scalar nbendog = `nbendog'
		ereturn hidden scalar noendog = `noendog'
		ereturn hidden scalar nendog = `nendog'
		ereturn hidden scalar sel = "`sel_depvar'" != ""
		ereturn hidden scalar tr = "`tr_depvar'" != ""
		ereturn hidden scalar extr = "`extr_depvar'" != ""
		ereturn hidden local trdepvar `tr_depvar'
		ereturn hidden local extrdepvar `extr_depvar'
		ereturn hidden local odepvar `depvar'
		if "`s1depvars'" != "" {
			ereturn hidden local s1depvars `os1depvars'
			ereturn hidden matrix s1vals = `s1vals', copy
			ereturn hidden matrix s1nvals = `s1nvals', copy
			ereturn hidden matrix s1binary = `s1binary', copy
			ereturn hidden scalar ns1combos = `ns1combos'
			ereturn hidden local s0depvars `s0depvars'
			ereturn hidden matrix s0vals = `s0vals',copy
			ereturn hidden matrix s0nvals = `s0nvals', copy
			ereturn hidden matrix s0binary = `s0binary', copy
			ereturn hidden scalar ns0combos =`ns0combos'
		}
		if "`catdepvars'" != "" {
			ereturn hidden local catdepvars `ocatdepvars'
			ereturn hidden matrix catvals = `catvals', copy
			ereturn hidden matrix catnvals = `catnvals', copy
			ereturn hidden matrix catbinary = `catbinary', copy
			ereturn hidden scalar ncombos = `ncombos'
		}
		ereturn hidden local depvar_dvlist `depvar_dvlist'
		ereturn hidden local adepvar_dvlist `adepvar_dvlist'
		ereturn hidden local podepvar_dvlist `podepvar_dvlist'
		ereturn hidden local treatrecursive `treatrecursive'
		ereturn hidden local sel_dvlist `sel_dvlist'
		ereturn hidden local tsel_dvlist `tsel_dvlist'
		ereturn hidden local tr_dvlist `tr_dvlist'
		forvalues i = 1/`nbendog' {
			ereturn hidden local bendog_dvlist`i'	///
				`bendog_dvlist`i''
			ereturn hidden local bendog_depvar`i'	///
				`bendog_depvar`i''
		}
		forvalues i = 1/`noendog' {
			ereturn hidden local oendog_dvlist`i'	///	
				`oendog_dvlist`i''
			ereturn hidden local oendog_depvar`i'	///
				`oendog_depvar`i''
		}
		forvalues i = 1/`nendog' {
			ereturn hidden local endog_dvlist`i'	///
				 `endog_dvlist`i''
			ereturn hidden local endog_depvar`i'	///
				`endog_depvar`i''
		}
		ereturn hidden local fdepvar_dvlistmacs `fdepvar_dvlistmacs'
		ereturn hidden local seldepvar `sel_depvar'
		ereturn hidden local tseldepvar `tsel_depvar'
		ereturn hidden local trvalues `tr_listnum'
		ereturn hidden local extrvalues `extr_listnum'
		ereturn hidden local poutcomes `tr_poutcomes'
		ereturn local estat_cmd erm_estat
		tempname bpclass
		matrix `bpclass' = e(b_pclass)
		ereturn hidden matrix b_pclass = `bpclass'
		capture ereturn hidden matrix borig = `borig',copy
		ereturn local predict eprobit_p
		ereturn hidden local margins_check_est ///
				erm_marg_check_est	
		ereturn local marginsok default Pr Mean ///
			POMean xb te tet STRuctural total	///
			e(passthru) Pre(passthru) YStar(passthru) ///
			fix(passthru) base(passthru) TARGet(passthru) ///
			OUTLevel(passthru) EQuation(passthru)
		ereturn local marginsnotok SCores
		ereturn hidden local marginsprop "`marginsprop'"
		local endogdepvars
		forvalues i = 1/`nendog' {
			ereturn hidden local endogdepvar`i' `endog_depvar`i''
			local endogdepvars `endogdepvars' `endog_depvar`i''
		}
		ereturn hidden local endogdepvars `endogdepvars'
		ereturn hidden local bendogdepvars `bendog_depvars'
		ereturn hidden local oendogdepvars `oendog_depvars'
		local foendog_depvars `oendog_depvars'
		ereturn hidden local extr_pocovariance `extr_pocovariance'
		ereturn hidden local tr_pocovariance `tr_pocovariance'
		ereturn hidden local repanvar `repanvar'
		ereturn hidden scalar ndv = `ndv'
		if "`re'" != "" {
			ereturn local reintmethod `reintmethod'
			ereturn hidden scalar reintpoints = `reintpoints'
			ereturn scalar n_requad = `reintpoints'
			ereturn hidden matrix relistmat = `relistmat', copy
			if ("`e(vce)'" == "robust") {
				ereturn local clustvar `repanvar'
				ereturn scalar N_clust = `N_g'
			}
			ereturn scalar N_g =  `N_g'
			ereturn scalar g_min = `g_min'
			ereturn scalar g_avg = `g_avg'
			ereturn scalar g_max = `g_max'
		}
		else {
			ereturn hidden scalar reintpoints = `reintpoints'
		}
		if "`has_pocovariance'" == "" & "`re'" == "" {
			//get conditional variance
			local totcorr = `totvp'-`nendog'-("`tsel_depvar'"!="")
			local startind = `totp' -  `totcorr' + 1
			tempname Corr
			local nvars = 1 + 				///
				("`tsel_depvar'`sel_depvar'" != "") +	///
					("`tr_depvar'" != "") +  	///
					`nbendog' + `noendog' + `nendog'
			matrix `Corr' = I(`nvars')
			local k = 0
			forvalues i = 1/`nvars' {
				local ip1 = `i' + 1
				forvalues j = `ip1'/`nvars' {
					matrix `Corr'[`i',`j'] = ///
						`borig'[1,`startind'+`k']
					matrix `Corr'[`j',`i'] = ///
						`Corr'[`i',`j']
					local k = `k' + 1
				}
			}
			local startind = `totp'-`totvp'+1
			local k = 0
			tempname Sigma
			matrix `Sigma' = `Corr'
			if "`tsel_depvar'" != "" {
				forvalues j = 1/`nvars' {
					matrix	`Sigma'[2,`j'] = 	///
						`Sigma'[2,`j']*		///
						sqrt(`borig'[1,`startind'])
					matrix	`Sigma'[`j',2] =	///
						`Sigma'[`j',2]*		///
						sqrt(`borig'[1,`startind'])
				}
				local k = `k' + 1
			}
	  		forvalues i = 1/`nendog' {
				forvalues j = 1/`nvars' {
					matrix				/// 
					`Sigma'[`nvars'-`nendog'+`i',	///
					`j'] = 				///
					`Sigma'[`nvars'-`nendog'+`i',	///
					`j']*				///
					sqrt(`borig'[1,`startind'+`k'])
					matrix `Sigma'[`j',	///	
					`nvars'-`nendog'+`i'] = ///
					`Sigma'[`j',		///
					`nvars'-`nendog'+`i']*	///
					sqrt(`borig'[1,`startind'+`k'])
				}
				local k = `k' + 1
			}
			matrix colnames `Sigma' = `e(depvar)'
			matrix rownames `Sigma' = `e(depvar)'
			ereturn hidden matrix varfull = `Sigma', copy
		}
		else if "`has_pocovariance'" == "" & "`re'" != "" {
			//get conditional variance
			local totcorr = `totvp'-`nendog'-	///
				("`tsel_depvar'"!="")
			local startind = `totp' -  `totcorr' + 1
			tempname Corr
			matrix `Corr' = I(`ndv')
			local k = 0
			forvalues i = 1/`ndv' {
				local ip1 = `i' + 1
				forvalues j = `ip1'/`ndv' {
					matrix `Corr'[`i',`j'] = ///
						`borig'[1,`startind'+`k']
					matrix `Corr'[`j',`i'] = ///
						`Corr'[`i',`j']
					local k = `k' + 1
				}
			}
			local startind = `totp'-`totvp'+1
			local k = 0
			tempname Sigma
			matrix `Sigma' = `Corr'
			if "`tsel_depvar'" != "" {
				forvalues j = 1/`ndv' {
					matrix	`Sigma'[2,`j'] = 	///
						`Sigma'[2,`j']*		///
						sqrt(`borig'[1,`startind'])
					matrix	`Sigma'[`j',2] =	///
						`Sigma'[`j',2]*		///
						sqrt(`borig'[1,`startind'])
				}
				local k = `k' + 1
			}
	  		forvalues i = 1/`nendog' {
				forvalues j = 1/`ndv' {
					matrix				/// 
					`Sigma'[`ndv'-`nendog'+`i',	///
					`j'] = 				///
					`Sigma'[`ndv'-`nendog'+`i',	///
					`j']*				///
					sqrt(`borig'[1,`startind'+`k'])
					matrix `Sigma'[`j',	///	
					`ndv'-`nendog'+`i'] = ///
					`Sigma'[`j',		///
					`ndv'-`nendog'+`i']*	///
					sqrt(`borig'[1,`startind'+`k'])
				}
				local k = `k' + 1
			}
			tempname CorrRE
			matrix `CorrRE' = I(`ndv')
			local k = 0
			local startind = `totp'-(`nredv'*(`nredv'+1)/2) ///
				+`nredv'+1
			forvalues i = 1/`ndv' {
				local ip1 = `i' + 1
				forvalues j = `ip1'/`ndv' {
					if `relistmat'[1,`i'] & ///
						`relistmat'[1,`j'] {
						matrix `CorrRE'[`i',`j'] = ///
						`borig'[1,`startind'+`k']
						matrix `CorrRE'[`j',`i'] = ///
							`CorrRE'[`i',`j']
						local k = `k' + 1
					}
				}
			}
			tempname SigmaRE
			local startind = `totp'-(`nredv'*(`nredv'+1)/2)
			tempname Sigmatmp
			matrix `Sigmatmp' = J(`ndv',`ndv',0)
			local k = 1
			forvalues i=1/`ndv' {
				if `relistmat'[1,`i'] {
					matrix `Sigmatmp'[`i',`i']= ////
						sqrt(`borig'[1,`startind'+`k'])
					local k = `k' + 1
				}
			}
			matrix `SigmaRE' = `Sigmatmp'*`CorrRE'*`Sigmatmp'
			matrix `Sigma' = `Sigma' + `SigmaRE'
			matrix colnames `Sigma' = `e(depvar)'
			matrix rownames `Sigma' = `e(depvar)'
			ereturn hidden matrix varfull = `Sigma', copy
			ereturn hidden matrix SigmaRE = `SigmaRE', copy		
		}
		else if "`has_pocovariance'" != "" & "`re'" == "" {
			if `ndv' > 1 {
				tempname Corr0
				matrix `Corr0' = I(`ndv'-1)
				local kst = e(k) - ((`ndv'-1)*`ndv'/2 ///
					-(`ndv'-1)) +1
				local ndvm1 = `ndv'-1
				local k  = 0
				forvalues i=1/`ndvm1' {
					local ip1 = `i' + 1
					forvalues j=`ip1'/`ndvm1'{
						matrix `Corr0'[`i',`j'] = ///
							`borig'[1,`kst'+`k']
						matrix `Corr0'[`j',`i'] = ///
							`Corr0'[`i',`j']
						local k = `k' + 1
					}
				}
				// put variances in
				tempname Sigma0
				matrix `Sigma0' = `Corr0'
				local kvarend=`kst'-1-	///
					`pocovariance_n'*(`ndv'-1)
				local kvarbeg = `kvarend'-	///
					("`tsel_depvar'"!="") 	///
					-`nendog'+1
				local j = `ndv'-1-`nendog'+1-	///
					("`tsel_depvar'" != "")
				if "`tsel_depvar'" != "" {
					matrix `Sigma0'[1,1] == ///
						`borig'[1,`kvarbeg']
					local kvarbeg = `kvarbeg'+1
					local j = `j'+1
				}
				forvalues i=`kvarbeg'/`kvarend' {
					matrix `Sigma0'[`j',`j'] = ///
						`borig'[1,`i']
					local j = `j' + 1	
				}
				local ndvm1 = `ndv'-1
				forvalues i = 1/`ndvm1' {
					local ip1 = `i' + 1
					forvalues j = `ip1'/`ndvm1' {
						matrix `Sigma0'[`i',`j']= ///
						sqrt(`Sigma0'[`i',`i'])*  ///
						sqrt(`Sigma0'[`j',`j'])*  ///
						`Sigma0'[`i',`j']
						matrix `Sigma0'[`j',`i'] = ///
							`Sigma0'[`i',`j']
					}
				}
			}
			local kst = e(k) -(`ndv'-1)*`pocovariance_n'- ///
				((`ndv'-1)*`ndv'/2 ///
				-(`ndv'-1)) +1
			tempname dropit
			tempname invperm2 
			matrix `dropit' = `borig'
			PoResort `dropit' `ndv' `pocovariance_n' `invperm2'
			tempname borigi
			matrix `borigi' = J(1,colsof(`borig'),.)
			local colsofborig = colsof(`borig')
			forvalues i = 1/`colsofborig' {
				matrix `borigi'[1,`invperm2'[1,`i']] = ///
					`borig'[1,`i']
			}
			forvalues t = 1/`pocovariance_n' {
				tempname Sigma
				matrix `Sigma'=1,J(1,colsof(`Corr0'),0) \ ///
						J(colsof(`Corr0'),1,0),`Sigma0'
				forvalues j=2/`ndv' {
					matrix `Sigma'[1,`j'] = 	///
						`borigi'[1,`kst']* 	///
						sqrt(`Sigma'[`j',`j'])
					matrix `Sigma'[`j',1] = 	///
						`Sigma'[1,`j']
					local kst = `kst'+1
				}
				local val = `t'
				matrix colnames `Sigma' = `e(depvar)'
				matrix rownames `Sigma' = `e(depvar)'
				ereturn hidden matrix varfull`val' =`Sigma'
			}
			ereturn hidden scalar pocovariance_n = `pocovariance_n'
			matrix colnames `pocovariance_catcombomat' ///
				= `pocovariance_vars'			
			ereturn hidden local pocovariance_vars ///
				`pocovariance_vars' 
			ereturn hidden matrix pocovariance_catcombomat = ///
				`pocovariance_catcombomat'
			local tmppocovariancevals
			forvalues i = 1/`pocovariance_n' {
				local  tmppocovariancevals	///
					`tmppocovariancevals' `i'
			}	
			ereturn hidden local pocovariance_vals ///
				`tmppocovariancevals'
			ereturn hidden local pocovariance pocovariance
		}
		else if "`has_pocovariance'" != "" & "`re'" != "" {
			if `ndv' > 1 {
				tempname Corr0
				matrix `Corr0' = I(`ndv'-1)
				local kst = e(k) - ((`ndv'-1)*`ndv'/2 ///
					-(`ndv'-1)) +1 - (`nredv'*(`nredv'+1)/2)
				local ndvm1 = `ndv'-1
				local k  = 0
				forvalues i=1/`ndvm1' {
					local ip1 = `i' + 1
					forvalues j=`ip1'/`ndvm1'{
						matrix `Corr0'[`i',`j'] = ///
							`borig'[1,`kst'+`k']
						matrix `Corr0'[`j',`i'] = ///
							`Corr0'[`i',`j']
						local k = `k' + 1
					}
				}
				// put variances in
				tempname Sigma0
				matrix `Sigma0' = `Corr0'
				local kvarend=`kst'-1-`pocovariance_n'*(`ndv'-1)
				local kvarbeg = `kvarend'-	///
					("`tsel_depvar'"!="") 	///
					-`nendog'+1
				local j = `ndv'-1-`nendog'+1-	///
					("`tsel_depvar'" != "")
				if "`tsel_depvar'" != "" {
					matrix `Sigma0'[1,1] == ///
						`borig'[1,`kvarbeg']
					local kvarbeg = `kvarbeg'+1
					local j = `j'+1
				}
				if (~missing(`kvarbeg') & 	///
					~missing(`kvarend')) {	
					forvalues i=`kvarbeg'/`kvarend' {
						matrix `Sigma0'[`j',`j'] = ///
							`borig'[1,`i']
						local j = `j' + 1	
					}
				}
				local ndvm1 = `ndv'-1
				forvalues i = 1/`ndvm1' {
					local ip1 = `i' + 1
					forvalues j = `ip1'/`ndvm1' {
						matrix `Sigma0'[`i',`j']= ///
						sqrt(`Sigma0'[`i',`i'])*  ///
						sqrt(`Sigma0'[`j',`j'])*  ///
						`Sigma0'[`i',`j']
						matrix `Sigma0'[`j',`i'] = ///
							`Sigma0'[`i',`j']
					}
				}
			}
			tempname CorrRE
			matrix `CorrRE' = I(`ndv')
			local k = 0
			local startind = `totp'-	///
				(`nredv'*(`nredv'+1)/2)+`nredv'+1
			forvalues i = 1/`ndv' {
				local ip1 = `i' + 1
				forvalues j = `ip1'/`ndv' {
					if `relistmat'[1,`i'] & ///
						`relistmat'[1,`j'] {
						matrix `CorrRE'[`i',`j'] = ///
						`borig'[1,`startind'+`k']
						matrix `CorrRE'[`j',`i'] = ///
							`CorrRE'[`i',`j']
						local k = `k' + 1
					}
				}
			}
			local startind = `totp'-(`nredv'*(`nredv'+1)/2)
			tempname Sigmatmp
			matrix `Sigmatmp' = J(`ndv',`ndv',0)
			local k = 1
			forvalues i=1/`ndv' {
				if `relistmat'[1,`i'] {
					matrix `Sigmatmp'[`i',`i']= ///
					sqrt(`borig'[1,`startind'+`k'])
					local k = `k' + 1
				}
			}
			tempname SigmaRE
			matrix `SigmaRE' = `Sigmatmp'*`CorrRE'*`Sigmatmp'
			local kst = e(k) -(`ndv'-1)*`pocovariance_n'- ///
				((`ndv'-1)*`ndv'/2 ///
				-(`ndv'-1)) +1 - (`nredv'*(`nredv'+1)/2)
			tempname dropit
			tempname invperm2 
			matrix `dropit' = `borig'
			local kf1 = colsof(`borig')-`nredv'*(`nredv'+1)/2
			matrix `dropit' = `dropit'[1,1..`kf1']
			PoResort `dropit' `ndv' `pocovariance_n' `invperm2'
			tempname borigi
			matrix `borigi' = J(1,	///
				colsof(`borig')-(`nredv'*(`nredv'+1)/2),.)
			local colsofborig = colsof(`borig') ///
				-(`nredv'*(`nredv'+1)/2)
			forvalues i = 1/`colsofborig' {
				matrix `borigi'[1,`invperm2'[1,`i']] = ///
					`borig'[1,`i']
			}
			forvalues t = 1/`pocovariance_n' {
				tempname Sigma
				matrix `Sigma'=1,J(1,colsof(`Corr0'),0) \ ///
						J(colsof(`Corr0'),1,0),`Sigma0'
				forvalues j=2/`ndv' {
					matrix `Sigma'[1,`j'] = 	///
						`borigi'[1,`kst']* 	///
						sqrt(`Sigma'[`j',`j'])
					matrix `Sigma'[`j',1] = 	///
						`Sigma'[1,`j']
					local kst = `kst'+1
				}
				local val = `t'
				matrix `Sigma' = `Sigma' + `SigmaRE'
				matrix colnames `Sigma' = `e(depvar)'
				matrix rownames `Sigma' = `e(depvar)'
				ereturn hidden matrix varfull`val' =`Sigma'
			}
			ereturn hidden matrix SigmaRE = `SigmaRE', copy	
			ereturn hidden scalar pocovariance_n = `pocovariance_n'
			matrix colnames `pocovariance_catcombomat' ///
				= `pocovariance_vars'			
			ereturn hidden local pocovariance_vars ///
				`pocovariance_vars' 
			ereturn hidden matrix pocovariance_catcombomat = ///
				`pocovariance_catcombomat'
			local tmppocovariancevals
			forvalues i = 1/`pocovariance_n' {
				local  tmppocovariancevals	///
					`tmppocovariancevals' `i'
			}	
			ereturn hidden local pocovariance_vals ///
				`tmppocovariancevals'
			ereturn hidden local pocovariance ///
				pocovariance
		}
		ereturn local title	/// 	
		"Extended probit regression"
		if `fromused' == 0 {
			ereturn hidden matrix binit = `ibigB', copy
		}
		ereturn hidden local tsell `atsell'
		ereturn hidden local tselu `atselu'
		if "`tsel_depvar'" != "" {
			ereturn local tsel_ll `atsell'
			ereturn local tsel_ul `atselu'
		}
		ereturn hidden local recinit = `userecinit'
		ereturn hidden matrix catvals = `fcatvals', copy
		ereturn hidden matrix nvals = `fnvals', copy
		ereturn hidden matrix binary = `fbinary', copy
		ereturn scalar n_quad = `intpoints'
		ereturn scalar n_quad3 = `intpoints3'
		local w = colsof(`fnvals')
		forvalues i = 1/`w' {
			local j = `fnvals'[1,`i'] 
			if `fbinary'[1,`i'] {
				ereturn hidden scalar k_cat`i' = `j'
			}
			else {
				ereturn scalar k_cat`i' = `j'
			}
			tempname mat
			mata: st_matrix("`mat'",	///
				st_matrix("`fcatvals'")[1..`j',`i'])
			if `fbinary'[1,`i'] {
				ereturn hidden matrix cat`i' = `mat', copy
			}
			else {
				ereturn matrix cat`i' = `mat', copy
			}
		}
		Display, `diopts' `table'
		if `notepovariance' {
			di in smcl as text ///
				"{p 0 4 2}Warning: suboption {bf:povariance} "
			di in smcl as text ///
				"ignored; variance of e.`depvar' is 1{p_end}"	
		}
		if `notepocorrelation' {
			di in smcl as text ///
			"{p 0 4 2}Warning: suboption {bf:pocorrelation} "
			di in smcl as text ///
				"ignored; there is only one equation{p_end}"	
		}
	}
        }
        local erc = _rc
        capture mata: rmexternal("`inits'")
        if (`erc') {
                exit `erc'
        }
end

program Display
	syntax, [*]
	_prefix_display, `options'
end

program ParseEndog, sclass
	syntax [, ENDOGenous(string) *]
	sreturn local endog `endogenous'
	sreturn local rest `options'
end

program SubCut, rclass
syntax, [cuts(string) dvnames(string) cutsinteract trn(string) dvn(string)] 
	local subbed
	if "`cutsinteract'" != "" {
		forvalues j = 1/`dvn' {
			forvalues i = 1/`trn' {
				gettoken sub cuts: cuts
				local subbed `subbed' `sub'
			}
		}
	}
	foreach w of local dvnames {
		local cuts = subinstr("`cuts'","`w'_","`w':",.)
	}
	return local subbed `subbed' `cuts'
end

program DummyPost, eclass
	syntax, init(string) touse(string) [constraints(string)]
	if "`constraints'" != "" {
		ParseConstraints, constraints(`constraints')
	}
	gettoken init1 : init
	tempname tmat
	matrix `tmat' = `init1'
	ereturn post `tmat', esample(`touse') buildfvinfo
	if "`constraints'" != "" {
		makecns `constraints'
	}
end

program ParseConstraints, rclass
	capture qui syntax, constraints(numlist)
	if _rc {
		di as error "{bf:constraints()} incorrectly specified"
		exit 198
	}
	foreach v of local constraints {
		capture qui constraint get `v'
		if _rc {
			di as error "{bf:constraints()} incorrectly specified"
			constraint get `v'
		}
	}	
	return local constraints `constraints'	
end

program GetCatCombos, sortpreserve
	syntax varlist(ts fv), catcombo(string) ///
		catcombomatind(string) touse(string)
	tempvar ttouse
	qui gen `ttouse' = `touse'
	qui replace `ttouse' = 0 if missing(`touse')
	tempvar order
	qui gen `order' = _n
	fvrevar `varlist'
	local tmplist `r(varlist)'
	sort `tmplist' `order', stable
	qui gen `catcombo' = .
	qui by  `tmplist': replace	///
		`catcombo' = _n == 1 if `ttouse'
	qui gen `catcombomatind' = !missing(`catcombo')
	qui replace `catcombomatind' = 0 if `catcombo'==0
	qui count if `catcombomatind' > 0
	if ~(r(N)) {
		error 2000
	} 
	qui replace `catcombo' = sum(`catcombo') if `ttouse'
	qui replace `catcombo' = -1 if missing(`catcombo')
end

program define ParseFrom, sclass
	cap noi syntax anything(name=from id="init_specs" equalok) ///
		[, copy skip]
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:from()}"
		exit `rc'
	}
	capture confirm matrix `from'
	local rc = _rc
	if `rc' {
		local 0, nlist(`from')
		capture syntax, nlist(numlist)
		if _rc {
			di as err "{p 0 4 2}only a list of numbers or a"
			di as err" matrix are allowed in {bf:from()}{p_end}"
			exit 198
		}
		capture assert "`copy'" != "" 
		if _rc {
			di as err "{p 0 4 2}option {bf:from()} requires "
			di as err ///
			"{bf:copy} if a list of values is specified{p_end}"
			exit 198
		}
	}	
	sreturn local from `"`from'"'
	sreturn local copy `copy'
	sreturn local skip `skip'
end

program _chk_limit, sclass
        args limit name
        if missing("`limit'") | "`limit'"=="." {
                sreturn local lmt
                exit
        }
        capture confirm numeric variable `limit'
        local rc1 = _rc
        if `rc1' {
                capture confirm number `limit'
                local rc2 = _rc
                capture local x = `limit'
                capture confirm number `x'
                local rc3 = _rc
                if `rc2' & `rc3' {
                        di "{err}invalid option {bf:`name'}"
                        exit 198
                }
                else {
                        if `rc2' local lmt `x'
                        else     local lmt `limit'
                        local rc1 0
                }
                if `rc1' {
                        di `"{err}variable {bf:`limit'} not found"'
                        exit 198
                }
        }
        else local lmt `limit'
        sreturn local lmt "`lmt'"
end

program SubTreatment, rclass
	syntax, [trdepvar(varlist ts) invarlist(string) ///
		constant(string) equation(string)]
	if inlist("`constant'","1","") | "`trdepvar'" == "" {
		return local invarlist `invarlist'	
		exit 
	}
	tsunab trdepvar: `trdepvar'
	// get abbreviated list
	local ablist
	local l = length("`trdepvar'")
	forvalues i =1/`l' {
		local prosp = abbrev("`trdepvar'",`i')
		capture tsunab prospunab: `prosp' 
		if ~_rc {
			if "`prospunab'" == "`trdepvar'" {
				local ablist `ablist' `prosp'
			}
		}
	}
	foreach word of local ablist {
		local invarlist = subinstr("`invarlist' ", ///
			"i.`word' ","ibn.`trdepvar' ",.)
		local invarlist = subinstr("`invarlist' ", ///
			"i.`word'#","ibn.`trdepvar'#",.)		
	}
	// now check that there are no base cases for treatment
	fvexpand `invarlist'
	local there = subinstr("`r(varlist)'","b.`trdepvar'","",.)
	local oinvarlist `r(varlist)'
	if length("`there'") != length("`oinvarlist'") {
		di as error "{p 0 4 2}invalid specification of "
		di as error "{bf:`equation'()}; base for "
		di as error ///
		"treatment {bf:`trdepvar'} should not be specified{p_end}" 
		exit 498
	}
	return local invarlist `invarlist'
end

program PoResort
	args mat ndv nt mat2
	tempname newmat
	local f: colfullnames `mat'
	local fnew
	local k = colsof(`mat') - ((`ndv'-1)*((`ndv'-1)+1)/2 - (`ndv'-1)) ///
				- `nt'*(`ndv'-1)
	local fi = `k' + 1
	local ind
	local indlist	
	local oind = `fi'
	local ndvm1 = `ndv'-1
	forvalues i = 1/`ndvm1' {
		local indi = `oind' + `i'-1
		local indlist `indlist' `indi'
		local ntm1 = `nt'-1
		forvalues j = 1/`ntm1' {
			local indit = `indi' + `ndvm1'*`j'
			local indlist `indlist' `indit'
		}
	}
	local indlist = subinstr("`indlist'"," ",",",.)
	local k1 = colsof(`mat') - ((`ndv'-1)*((`ndv'-1)+1)/2 - (`ndv'-1)) +1
	local k2 = colsof(`mat')	
	if (`k2' >= `k1') {
		mata: st_matrix("`mat'",st_matrix("`mat'")[1,	///
			((1..`k'),(`indlist'),(`k1'..`k2'))])		
		mata: st_matrix("`mat2'", ((1..`k'),(`indlist'),(`k1'..`k2')))	
	}
	else {
		mata: st_matrix("`mat'",st_matrix("`mat'")[1,	///
			((1..`k'),(`indlist'))])		
		mata: st_matrix("`mat2'", ((1..`k'),(`indlist')))	
	}
	forvalues i=1/`k2' {
		local iword = `mat2'[1,`i']
		local w: word `iword' of `f'
		local fnew `fnew' `w'
	}
	matrix colnames `mat' = `fnew'
end

program CheckPoCovPanel, sortpreserve
	syntax, touse(string) repanvar(string) pocovariance_vars(string)
	sort `touse' `repanvar', stable
	foreach word of local `pocovariance_vars' {
		capture by `touse' `repanvar': assert 	///
			`word' == 			///
			`word'[1] if `touse'
		if _rc {
			noi di as error "{p 0 4 2}random-effect correlation "
			noi di as error "parameters vary by `word', but "
			noi di as error "`word' varies within `repanvar' "
			noi di as error "panels{p_end}"
			exit 498
		}
	}
end

program GetPanN, sortpreserve rclass
	syntax, touse(string) repanvar(string)
	tempvar isort T
	qui gen `c(obs_t)' `isort' = _n	
	sort `touse' `repanvar' `isort'
	qui by `touse' `repanvar': gen `c(obs_t)' `T' = _N if `touse'
                
	qui summarize `T' if `touse' & `repanvar'!=`repanvar'[_n-1], meanonly
        tempname ng gmin gavg gmax        
	scalar `ng' = r(N)
	scalar `gmin' = r(min)
	scalar `gavg' = r(mean)
	scalar `gmax' = r(max)	
	return scalar N_g = `ng'
	return scalar g_min = `gmin'
	return scalar g_avg = `gavg'
	return scalar g_max = `gmax' 
end
program ReListMat, rclass
	syntax , listmat(string)
	local w: word count `listmat'
	tempname relistmat
	matrix `relistmat' = J(1,`w',0)
	forvalues i = 1/`w' {
		local wi: word `i' of `listmat'
		if `wi' {
			matrix `relistmat'[1,`i'] = 1
		}
	}
	return matrix relistmat = `relistmat', copy
end

exit
