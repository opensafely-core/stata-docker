*! version 1.0.1  10dec2019
program _erm_get_initvals_rec_re, rclass
	syntax, [ ermcmd(string) 	///
		depvar(string)		///
		depvarl(string)		///
		depvaru(string)		///
		indepvars(string)	///
		noCONstant		///
		offset(passthru)	///
		tsel_depvar(string)	///
		tsel_indepvars(string)	///
		tsel_constant(string)	///
		tsel_offset(string)	///
		tsel_ll(string)		///
		tsel_ul(string)		///
		tsel_depvarind(string)	///
		sel_depvar(string)	///
		sel_indepvars(string)	///
		sel_constant(string)	///
		sel_offset(string)	///
		tr_depvar(string)	///
		tr_indepvars(string)	///
		tr_vals(string)		///
		tr_oprobit(string)	///
		tr_constant(string)	///
		tr_offset(string)	///
		oendog_depvars(string)	///
		bendog_depvars(string)	///
		endog_depvars(string)	///
		nbendog(string)		///
		noendog(string)		///
		nendog(string)		///
		wexp(string)		///
		touse(string) repanvar(string) *]

	local depvarll `depvarl'

	local cutdvnames
	local s 
	forvalues i=1/`noendog' {
		local s `s' oendog_n`i'(string) oendog_depvar`i'(string) ///
			oendog_indepvars`i'(string)			 ///
			oendog_constant`i'(string)		
	}
	forvalues i = 1/`nbendog' {
		local s `s' bendog_n`i'(string)		///
			bendog_depvar`i'(string)	///
			bendog_indepvars`i'(string)	///
 			bendog_constant`i'(string)	 	
	}
	forvalues i = 1/`nendog' {
		local s `s' endog_depvar`i'(string)		///
				endog_indepvars`i'(string)	///
				endog_constant`i'(string)
	}
	local 0, `options'
	if `"`s'"' != "" {
		syntax , [`s' *]
	}	

	local alldepvars `tr_depvar' `tsel_depvar'`sel_depvar' `depvar'`depvarl' 
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			local alldepvars `bendog_depvar`i'' `alldepvars'
		}
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			local alldepvars `oendog_depvar`i'' `alldepvars'
		}
	}
	if `nendog' > 0 {
		forvalues i = 1/`nendog' {
			local alldepvars `endog_depvar`i'' `alldepvars'
		}
	}
	local dups: list dups alldepvars
	if "`dups'" != "" {
		di as error ///
			"same dependent variable used for multiple equations"
		exit 498
	}
	local j = 1
	foreach var of local alldepvars {
		local indepvars`j' 
		local depvar`j' `var'
		if "`var'" == "`depvar'`depvarl'" {
			fvexpand `indepvars' if `touse'
                        local indepvars `r(varlist)'
			local checkvarlist `r(varlist)'
		}
		else if "`var'" == "`sel_depvar'" {
                        fvexpand `sel_indepvars' if `touse'
                        local sel_indepvars `r(varlist)'
			local checkvarlist `r(varlist)'
		}
		else if "`var'" == "`tsel_depvar'" {
			fvexpand `tsel_indepvars' if `touse'
                        local tsel_indepvars `r(varlist)'
			local checkvarlist `r(varlist)'
		}
		else if "`var'" == "`tr_depvar'" {
			fvexpand `tr_indepvars' if `touse'
                        local tr_indepvars `r(varlist)'
			local checkvarlist `r(varlist)'
		}
		forvalues i = 1/`nbendog' {
			if "`var'" == "`bendog_depvar`i''" {
				fvexpand `bendog_indepvars`i'' if `touse'
                                local bendog_indepvars`i' `r(varlist)'
				local checkvarlist `r(varlist)'
			}
		}
		forvalues i = 1/`noendog' {
			if "`var'" == "`oendog_depvar`i''" {
				fvexpand `oendog_indepvars`i'' if `touse'
                                local oendog_indepvars`i' `r(varlist)'
				local checkvarlist `r(varlist)'
			}
		}
		forvalues i = 1/`nendog' {
			if "`var'" == "`endog_depvar`i''" {
				fvexpand `endog_indepvars`i'' if `touse'
                                local endog_indepvars`i' `r(varlist)' 
				local checkvarlist `r(varlist)'
			}
		}
		foreach word of local alldepvars {
			Check, check(`checkvarlist') for(`word')
			if `r(there)' == 1 {
				local indepvars`j' ///
					`indepvars`j'' `word'
			}
		} 
		local j = `j' + 1
	}
	local varcnt = `j' - 1
	forvalues i=1/`varcnt' {
		local indepvars`i': list uniq indepvars`i'
		local indepvars`i': list sort indepvars`i'
	}
	local done = 0
	while ~`done' {
		forvalues i = 1/`varcnt' {
			local m1indepvars`i' `indepvars`i''
		}
		forvalues i = 1/`varcnt' {
			local findepvars`i' `indepvars`i''
			foreach var of local indepvars`i' {
				forvalues j = 1/`varcnt' {
					if "`depvar`j''" == "`var'" {
						local findepvars`i' 	///
							`findepvars`i'' ///
							`indepvars`j''
					}
				}
			} 
		}
		forvalues i = 1/`varcnt' {
			local indepvars`i' `findepvars`i''
			local indepvars`i': list uniq indepvars`i'
			local indepvars`i': list sort indepvars`i'
		}
		local done = 1
		forvalues i = 1/`varcnt' {
			local done = `done' & ("`m1indepvars`i''" == ///
				"`indepvars`i''")
		}		
	}
	forvalues i = 1/`varcnt' {
		local rank`i': word count `indepvars`i''		
	}
	local vcntm1 = `varcnt' - 1
	tempname cov22
	tempname icov22
	tempname covaa
	tempname icovaa
	local orderlist
	tempname ordermat
	tempname orderrev
	matrix `orderrev' = J(1,`varcnt',.)
	local k = `varcnt'
	forvalues i = 1/`varcnt' {
		matrix `orderrev'[1,`k'] = `i'
		local k = `k' - 1
	}
	matrix `ordermat' = J(1,`varcnt',0)
	forvalues i = 0/`vcntm1' {
		forvalues j = 1/`varcnt' {
			if `rank`j'' == `i' {
				local extraopts
				if "`residse'" != "" {
					local extraopts			///
						residualse(`residse')	/// 
						sigma22(`cov22')	/// 	
						isigma22(`icov22')	///
						residualsa(`residsa')	///
						sigmaa(`covaa')		///
						isigmaa(`icovaa')	
				}
				tempvar reside`j'
				tempvar resida`j'
				tempname initb_`j'
				tempname initcut_`j'
				matrix `initcut_`j'' = J(1,1,.)
				// DO j
				local jorder = `orderrev'[1,`j']
				matrix `ordermat'[1,`varcnt'-`k'] = `jorder'
				local k = `k'+1
				if "`depvar`j''" == "`depvar'`depvarl'" {

tempvar ttouse
qui gen `ttouse' = `touse'
if "`sel_depvar'" != "" {
	qui replace `ttouse' = 0 if ~`sel_depvar'
}
if "`tsel_depvarind'" != "" {
	qui replace `ttouse' = 0 if ~`tsel_depvarind'
}
if "`ermcmd'" == "eregress" {
_erm_re_regress_getsv `depvar' `indepvars' `wexp', `constant'	///
	touse(`ttouse') storeresiduale(`reside`j'') 		///
	storeresiduala(`resida`j'') panvar(`repanvar') `extraopts'
}
else if "`ermcmd'" == "eintreg" {
_erm_re_intreg_getsv `indepvars' `wexp', 			///
	ll(`depvarll') ul(`depvaru') `offset' `constant' 	///
	touse(`ttouse') storeresiduale(`reside`j'') `extraopts' ///
	depvarname(`depvarl') panvar(`repanvar') storeresiduala(`resida`j'')
}
else if "`ermcmd'" == "eprobit" {
_erm_re_probit_getsv `depvar' `indepvars' `wexp', `offset' `constant' 	///
	touse(`ttouse') storeresiduale(`reside`j'') `extraopts'		///
	storeresiduala(`resida`j'') panvar(`repanvar')
}
else if "`ermcmd'" == "eoprobit" {
_erm_re_oprobit_getsv `depvar' `indepvars' `wexp', `offset' `constant'	///
	touse(`ttouse') storeresiduale(`reside`j'') `extraopts'		///
	storeresiduala(`resida`j'') panvar(`repanvar')
	matrix `initcut_`j'' = r(bcut)
}
				}
				if "`depvar`j''" == "`sel_depvar'" {
_erm_re_probit_getsv `sel_depvar' `sel_indepvars' `wexp', 	///
	`sel_offset' `sel_constant' panvar(`repanvar')		///
	touse(`touse') storeresiduale(`reside`j'') `extraopts'	///
	storeresiduala(`resida`j'')
				}
				if "`depvar`j''" == "`tsel_depvar'" {
tempvar ttsel_ll ttsel_ul
qui gen double `ttsel_ll' = `tsel_depvar' if `tsel_depvarind' & `touse'
qui gen double `ttsel_ul' = `tsel_depvar' if `tsel_depvarind' & `touse'
if "`tsel_ll'" != "" {
	qui replace `ttsel_ul' = `tsel_ll' if ~`tsel_depvarind' & ///
		(`tsel_depvar' <= `tsel_ll') & `touse'
}
if "`tsel_ul'" != "" {
	qui replace `ttsel_ll' = `tsel_ul' if ~`tsel_depvarind' & ///
		(`tsel_depvar' >= `tsel_ul') & `touse'
}
_erm_re_intreg_getsv `tsel_indepvars' `wexp',			/// 
	ll(`ttsel_ll') ul(`ttsel_ul')	panvar(`repanvar')	///
	touse(`touse')	storeresiduale(`reside`j'') `extraopts' ///
	depvarname(`tsel_depvar') `tsel_constant'		///
	storeresiduala(`resida`j'')
				}
				if "`depvar`j''" == "`tr_depvar'" {
	if "`tr_oprobit'" != "" {
		local arg oprobit
	}
	else {
		local arg probit
	}
_erm_re_`arg'_getsv `tr_depvar' `tr_indepvars' `wexp', 	///
	`tr_offset' `tr_constant' panvar(`repanvar')	///
	touse(`touse') storeresiduale(`reside`j'')	///
	`extraopts' storeresiduala(`resida`j'')			
if "`tr_oprobit'" != "" {
	matrix `initcut_`j'' = r(bcut)
}
				}
				forvalues h = 1/`nbendog' {
					if "`depvar`j''"==	///
					"`bendog_depvar`h''" {
_erm_re_probit_getsv `bendog_depvar`h'' `bendog_indepvars`h'' `wexp', 	///
	`bendog_constant`h'' touse(`touse') panvar(`repanvar')		/// 
	storeresiduale(`reside`j'') `extraopts'				///
	storeresiduala(`resida`j'')
					}
				}
				forvalues h = 1/`noendog' {
					if "`depvar`j''"==	///
					"`oendog_depvar`h''" {
_erm_re_oprobit_getsv `oendog_depvar`h'' `oendog_indepvars`h'' `wexp', 	///
	`oendog_constant`h'' touse(`touse') 				///
	storeresiduale(`reside`j'') `extraopts'				///
	storeresiduala(`resida`j'') panvar(`repanvar')
	matrix `initcut_`j'' = r(bcut)
					}
				}
				forvalues h = 1/`nendog' {
					if "`depvar`j''"==	///
					"`endog_depvar`h''" {
_erm_re_regress_getsv `endog_depvar`h'' `endog_indepvars`h'' `wexp', 	///
	`endog_constant`h'' touse(`touse') 				///
	storeresiduale(`reside`j'') `extraopts'				///
	storeresiduala(`resida`j'') panvar(`repanvar')
					}
				}
				local residse `reside`j'' `residse'
				local residsa `resida`j'' `residsa'
				matrix `initb_`j'' = r(b)
				matrix `cov22' = r(cov22)
				matrix `icov22' = r(icov22)
				matrix `covaa' = r(covaa)
				matrix `icovaa' = r(icovaa)
			}				
		}
	}
	tempname ibigB 
	local isbigCutnames
	local sbigCutnames
	local fbigCutnames
	local isbigVnames
	local sbigVnames
	local fbigVnames
	local bigBnames
	forvalues i = 1/`varcnt' {
		if "`depvar`i''" == "`depvar'`depvarl'" {
			matrix `ibigB' = `initb_`i''
			if "`ermcmd'" == "eoprobit" {
				tempname ibigCut
				matrix `ibigCut' = `initcut_`i''
				local ncuts = colsof(`initcut_`i'')
				local abname = ustrleft("`depvar'",32-6)
				local cutdvnames `cutdvnames' `abname'
				forvalues j = 1/`ncuts' {
					local fbigCutnames	/// 
						`fbigCutnames'	///
						/`abname':cut`j'
					local isbigCutnames 	///
						`isbigCutnames' ///
						/dv_cut`j'
					local sbigCutnames	///
						`sbigCutnames'	///
						/:dv_cut`j'
				}
			}
			local bigBnames: colfullnames `initb_`i''
			continue, break
		}
	}
	if "`tsel_depvar'" != "" {
		forvalues i = 1/`varcnt' {
			if "`depvar`i''" == "`tsel_depvar'" {
				matrix `ibigB' = `ibigB',`initb_`i''
				local tbigBnames: colfullnames `initb_`i''
				local bigBnames `bigBnames' `tbigBnames'
				continue, break
			}
		}
	}
	if "`sel_depvar'" != "" {
		forvalues i = 1/`varcnt' {
			if "`depvar`i''" == "`sel_depvar'" {
				matrix `ibigB' = `ibigB',`initb_`i''
				local tbigBnames: colfullnames `initb_`i''
				local bigBnames `bigBnames' `tbigBnames'
				continue, break
			}
		}
	}
	if "`tr_depvar'" != "" {
		forvalues i = 1/`varcnt' {
			if "`depvar`i''" == "`tr_depvar'" {
				matrix `ibigB' = `ibigB',`initb_`i''
				local tbigBnames: colfullnames `initb_`i''
				local bigBnames `bigBnames' `tbigBnames'
				if "`tr_oprobit'" != "" {
					if "`ermcmd'" == "eoprobit" {
						matrix `ibigCut' = ///
							`ibigCut',`initcut_`i''
					}
					else {
						tempname ibigCut
						matrix `ibigCut' = `initcut_`i''
					}
					local ncuts = colsof(`initcut_`i'')
					local abname = ustrleft(	///
						"`tr_depvar'",32-6)
					local cutdvnames `cutdvnames' `abname'
					forvalues j = 1/`ncuts' {
						local fbigCutnames	/// 
							`fbigCutnames'	///
							/`abname':cut`j'
						local isbigCutnames 	///
							`isbigCutnames' ///
							/t_cut`j'
						local sbigCutnames	///
							`sbigCutnames'	///
							/:t_cut`j'
					}
				} 
				continue, break				
			}
		}
	}
	if `nbendog' > 0 {
		foreach var of local bendog_depvars {
			forvalues i = 1/`varcnt' {
				if "`depvar`i''" == "`var'" {
					matrix `ibigB' = `ibigB',`initb_`i''
					local tbigBnames: ///
						colfullnames `initb_`i''
					local bigBnames `bigBnames' ///
						`tbigBnames'
					continue, break
				}				
			}	
		}
	}
	if `noendog' > 0 {
		local k = 1
		foreach var of local oendog_depvars {
			forvalues i = 1/`varcnt' {
				if "`depvar`i''" == "`var'" {
					matrix `ibigB' = `ibigB',`initb_`i''
					local tbigBnames: colfullnames ///
						`initb_`i''
					local bigBnames `bigBnames'	///
						`tbigBnames'
					if "`ibigCut'" == "" {
						tempname ibigCut
						matrix `ibigCut' = ///
							`initcut_`i''
					}
					else {
						matrix `ibigCut' = ///
							`ibigCut',`initcut_`i''
					}
					local ncuts = colsof(`initcut_`i'')
					local abname = ustrleft(	///
						"`var'",32-6)
					local cutdvnames `cutdvnames' `abname'
					forvalues j = 1/`ncuts' {
						local fbigCutnames	/// 
							`fbigCutnames'	///
						/`abname':cut`j'
						local isbigCutnames 	///
							`isbigCutnames' ///
							/o`k'_cut`j'
						local sbigCutnames	///
							`sbigCutnames'	///
							/:o`k'_cut`j'	
					}
					continue, break				
				}
			}
			local k = `k' + 1
		}
	}
	if `nendog' > 0 {
		foreach var of local endog_depvars {
			forvalues i=1/`varcnt' {
				if "`depvar`i''"=="`var'" {
					matrix `ibigB' = `ibigB',`initb_`i''
					local tbigBnames: colfullnames ///
						`initb_`i''
					local bigBnames `bigBnames'	///
						`tbigBnames'
				}
			}
		}	
	}
	tempname tmpCorr22 tmpCorrA tmpCov22 tmpCovA
	mata: st_matrix("`tmpCov22'",st_matrix("`cov22'")[	///
		(invorder((st_matrix("`ordermat'")))),	///
		(invorder((st_matrix("`ordermat'"))))])
	mata: st_matrix("`tmpCorr22'",corr(st_matrix("`tmpCov22'")))
	mata: st_matrix("`tmpCovA'",st_matrix("`covaa'")[	///
		(invorder((st_matrix("`ordermat'")))),	///
		(invorder((st_matrix("`ordermat'"))))])
	mata: st_matrix("`tmpCorrA'",corr(st_matrix("`tmpCovA'")))

	matrix colnames `tmpCovA' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix rownames `tmpCovA' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix colnames `tmpCorrA' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix rownames `tmpCorrA' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix colnames `tmpCov22' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix rownames `tmpCov22' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix colnames `tmpCorr22' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	matrix rownames `tmpCorr22' = `depvar' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' ///
			`bendog_depvars' `oendog_depvars' `endog_depvars'
	if "`ibigCut'" != "" {
		matrix `ibigB' = `ibigB',`ibigCut'		
	}	
	if colsof(`cov22') > 1 {
		if "`ermcmd'" == "eregress" | "`ermcmd'" == "eintreg" {
			matrix `ibigB' = (`ibigB',`tmpCov22'[1,1])
			local sbigVnames `sbigVnames' /:v_o
			local isbigVnames `isbigVnames' /v_o
			local fbigVnames `fbigVnames' /:var(e.`depvar'`depvarl')
		}
		if "`tsel_depvar'" != "" {
			matrix `ibigB' = (`ibigB',`tmpCov22'[2,2])
			local sbigVnames `sbigVnames' /:v_tsel
			local isbigVnames `isbigVnames' /v_tsel
			local fbigVnames `fbigVnames' ///
				/:var(e.`tsel_depvar')			
		}
		if `nendog' > 0 {
			local index = colsof(`cov22') -`nendog'
			forvalues i = 1/`nendog' {
				matrix `ibigB' = (`ibigB',	///
					`tmpCov22'[`index'+`i',`index'+`i'])
				local sbigVnames `sbigVnames' /:v_`i'
				local isbigVnames `isbigVnames' /v_`i'
				local fbigVnames `fbigVnames' ///
					/:var(e.`endog_depvar`i'')
			}
		}
		local dvlist `depvar'`depvarl' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' 				///
			`bendog_depvars' `oendog_depvars' 	///
			`endog_depvars'
		forvalues i = 1/`varcnt' {
			local ip1 = `i' + 1
			forvalues j =`ip1'/`varcnt' {
				local dvi: word `i' of `dvlist'
				local dvj: word `j' of `dvlist'
				matrix `ibigB' = (`ibigB',	///
					`tmpCorr22'[`i',`j'])
				local sbigVnames `sbigVnames'	///
					/:c_`j'_`i'
				local isbigVnames `isbigVnames'	///
					/c_`j'_`i'
				local fbigVnames `fbigVnames'	///
					/:corr(e.`dvj',e.`dvi')
			}
		}		
	}

	if colsof(`covaa') > 1 {
		matrix `ibigB' = (`ibigB',`tmpCovA'[1,1])
		local rsbigVnames `rsbigVnames' /:rv_o
		local risbigVnames `risbigVnames' /rv_o
		local rfbigVnames `rfbigVnames' ///
			/:var(`depvar'`depvarl'[`repanvar'])
		if "`tsel_depvar'" != "" {
			matrix `ibigB' = (`ibigB',`tmpCovA'[2,2])
			local rsbigVnames `rsbigVnames' /:rv_tsel
			local risbigVnames `risbigVnames' /rv_tsel
			local rfbigVnames `rfbigVnames' ///
				/:var(`tsel_depvar'[`repanvar'])		
		}
		if "`sel_depvar'" != "" {
			matrix `ibigB' = (`ibigB',`tmpCovA'[2,2])
			local rsbigVnames `rsbigVnames' /:rv_sel
			local risbigVnames `risbigVnames' /rv_sel
			local rfbigVnames `rfbigVnames' ///
				/:var(`sel_depvar'[`repanvar'])		
		}
		if "`tr_depvar'" != "" {
			local index = colsof(`covaa')	///
				-`nbendog'-`noendog'-`nendog'-1
			matrix `ibigB' = (`ibigB',	///
				`tmpCovA'[`index'+1,`index'+1])
			local risbigVnames `risbigVnames' /rv_tr
			local rsbigVnames `rsbigVnames' /:rv_tr
			local rfbigVnames `rfbigVnames' ///
				/:var(`tr_depvar'[`repanvar'])
		}
		if `nbendog' > 0 {
			local index = colsof(`covaa')	///
				-`nbendog'-`noendog'-`nendog'
			forvalues i = 1/`nbendog' {
				matrix `ibigB' = (`ibigB',	///
					`tmpCovA'[`index'+`i',`index'+`i'])
				local rsbigVnames `rsbigVnames' /:rv_b`i'
				local risbigVnames `risbigVnames' /rv_b`i'
				local rfbigVnames `rfbigVnames' ///
					/:var(`bendog_depvar`i''[`repanvar'])
			}			
		}
		if `noendog' > 0 {
			local index = colsof(`covaa')	///
				-`noendog'-`nendog'
			forvalues i = 1/`noendog' {
				matrix `ibigB' = (`ibigB',	///
					`tmpCovA'[`index'+`i',`index'+`i'])
				local rsbigVnames `rsbigVnames' /:rv_o`i'
				local risbigVnames `risbigVnames' /rv_o`i'
				local rfbigVnames `rfbigVnames' ///
					/:var(`oendog_depvar`i''[`repanvar'])
			}			
		}
		if `nendog' > 0 {
			local index = colsof(`covaa') -`nendog'
			forvalues i = 1/`nendog' {
				matrix `ibigB' = (`ibigB',	///
					`tmpCovA'[`index'+`i',`index'+`i'])
				local rsbigVnames `rsbigVnames' /:rv_`i'
				local risbigVnames `risbigVnames' /rv_`i'
				local rfbigVnames `rfbigVnames' ///
					/:var(`endog_depvar`i''[`repanvar'])
			}
		}
		local dvlist `depvar'`depvarl' `tsel_depvar'`sel_depvar' ///
			`tr_depvar' 				///
			`bendog_depvars' `oendog_depvars' 	///
			`endog_depvars'
		forvalues i = 1/`varcnt' {
			local ip1 = `i' + 1
			forvalues j =`ip1'/`varcnt' {
				local dvi: word `i' of `dvlist'
				local dvj: word `j' of `dvlist'

                                // check for precision issue in -1 < corr < 1
                                if (abs(`tmpCorrA'[`i',`j']) >= 1) {
                                        if `tmpCorrA'[`i',`j'] < 0 {
                                                mat `tmpCorrA'[`i',`j'] = ///
                                                  ceil(`tmpCorrA'[`i',`j'])
                                        }
                                        else {
                                                mat `tmpCorrA'[`i',`j'] = ///
                                                  floor(`tmpCorrA'[`i',`j'])
                                        }
                                }

				matrix `ibigB' = (`ibigB',	///
					`tmpCorrA'[`i',`j'])
				local rsbigVnames `rsbigVnames'	///
					/:rc_`j'_`i'
				local risbigVnames `risbigVnames'	///
					/rc_`j'_`i'
				local dvi `dvi'[`repanvar']
				local dvj `dvj'[`repanvar']
				local rfbigVnames `rfbigVnames'	///
					/:corr(`dvj',`dvi')
			}
		}		
	}
	matrix colnames `ibigB' = `bigBnames' `sbigCutnames' ///
		`sbigVnames' `rsbigVnames'

	return matrix bigB = `ibigB', copy
	return local cutdvnames `cutdvnames'
	return local sbigCutnames `isbigCutnames'
	return local sbigVnames `isbigVnames'
	return local fbigVnames `fbigVnames'
	return local fbigCutnames `fbigCutnames'
	return local rsbigVnames `risbigVnames'
	return local rfbigVnames `rfbigVnames'
end

program Check, rclass
	syntax, [check(string) for(string)]
	local there = 0
	foreach word of local check {
		_ms_parse_parts `word'
		if "`r(type)'" == "variable" | "`r(type)'" == "factor" {
			if "`r(ts_op)'`r(name)'" == "`for'" {
				local there = 1
				continue, break
			}
		}
		else if "`r(type)'" == "interaction" | ///
			"`r(type)'" == "product" {
			local k = r(k_names)
			forvalues i = 1/`k' {
				if "`r(ts_op`i')'`r(name`i')'" == "`for'" {
					local there = 1
					continue, break
				}			
			}
			if `there' {
				continue, break
			}			
		}
	}
	return local there = `there'
end	
exit
