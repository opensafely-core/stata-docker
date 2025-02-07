*! version 2.2.2  16feb2015
program define _gmode

        if _caller() < 10.1 {
                _gmode10 `0'
                exit
        }

	version 7, missing
	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	syntax varlist(max=1) [if] [in] [, MISSing BY(varlist) /*
		*/ MINmode MAXmode Nummode(numlist max=1 int >= 1) ]

	if ("`minmode'"!="") + ("`maxmode'"!="") + ("`nummode'"!="") > 1 {
		di as err "{p}only one of minmode, maxmode, or nummode() allowed"
		di "{p_end}"
		exit 198
	}
	if "`by'" != "" & "`nummode'" != "" {
		di as err "{p}option nummode() may not be combined with by{p_end}"
		exit 190
	}

	tempvar touse freq fmode uniq count maxfreq miss flag
	mark `touse' `if' `in'
	sort `touse' `by' `varlist'
	qui by `touse' `by' `varlist' : gen `c(obs_t)' `freq' = _N
	if "`missing'" == "" {
		qui replace `freq' = 0 if missing(`varlist')
		qui gen `miss' = !missing(`varlist') if `touse'
	}

	gen byte `uniq' = 1
	local type : type `varlist' /* ignore `type' passed from -egen- */
	if "`minmode'" != "" {
		if bsubstr("`type'",1,3) == "str" {
			gsort `touse' `by' `freq' -`varlist'
		}
		else {
			gsort `touse' `by' `freq' -`varlist', mfirst
		}
	}
	else if "`maxmode'" != "" {
		sort `touse' `by' `freq' `varlist'
	}
	else if  "`nummode'" != "" {
		sort `touse' `by' `freq' `varlist'
		qui by `touse' `by' : gen `fmode' = `freq'[_N]
		qui by `touse' `by' `freq' `varlist' : gen long `count' = 1 /*
				*/ if `fmode'==`freq' & _n==1 & `touse'
		qui replace `count' = sum(`count')
		qui replace `count' = . if !`touse' | `fmode'!=`freq'
		sort `touse' `by' `freq' `count'
		qui sum `count', meanonly
		local max = r(max)
		if `nummode' > `max' {
			di as err "{p}nummode(`nummode') too large -- there"
			if `max' == 1 {
				di "is only 1 mode{p_end}"
			}
			else {
				di "are only `max' modes{p_end}"
			}
			exit 198
		}
		qui replace `count'=0 if `count'!=`nummode'
		sort `touse' `by' `count' `varlist'
	}
	else {
		qui gsort `touse' `by' `freq' -`varlist'
		qui by `touse' `by' `freq' : gen `c(obs_t)' `fmode' = _N
		qui by `touse' `by' : replace `uniq' = `freq'[_N] == `fmode'[_N]
	}
	qui by `touse' `by' : gen `flag' = `uniq'[_N] == 0
	qui count if `flag' & `touse'
	local flag_mult_modes = `r(N)'	
	if bsubstr("`type'",1,3) == "str" {
		qui gen `type' `g' = ""
	}
	else {
		qui gen `type' `g' = .
	}

	qui by `touse' `by': replace `g' = `varlist'[_N] if `touse' & `uniq'
		/* catch multiple modes or all missing */	
	if "`missing'" == "" {
		if "`by'" == "" {
			capture assert !missing(`g') if `touse'
			if _rc == 9 {
				qui sum `miss' if `touse'
				if `r(sum)' == 0 {
				  di "{p}{txt}Warning: `varlist' contains all"
				  di "missing values.  Generating missing"
				  di "values for the mode.  Use the"
				  di "{cmd:missing} option to treat missing"
				  di "values as a category.{p_end}"
				}
				else {
				  di "{p}{txt}Warning: multiple modes"
				  di "encountered.  Generating missing values"
				  di "for the mode.  Use the {cmd:maxmode},"
 				  di "{cmd:minmode}, or {cmd:nummode()} options"
				  di "to control this behavior.{p_end}"
				}
			}
		}
		else {
			capture assert !missing(`g') if `touse'
			if _rc == 9 {
			  di "{p}{txt}Warning: at least one group contains all"
			  di "missing values or contains multiple modes."
			  di "Generating missing values for the mode of these"
			  di "groups.  Use the {cmd: missing}, {cmd:maxmode},"
			  di "{cmd:minmode}, or {cmd:nummode()}"
			  di "options to control this behavior.{p_end}"
			}
		}
	}
	else if "`missing'" != "" & "`maxmode'" == "" & /*
			*/ "`minmode'" == "" & "`nummode'" == ""  {
		capture assert !missing(`g') if `touse'
		if _rc == 9 & `flag_mult_modes' {
		  if "`by'" == "" {
			// check for all missing categories 
			di "{p}{txt}Warning: multiple modes encountered."
			di "Generating missing values for the mode.  Use the"
			di "{cmd:maxmode}, {cmd:minmode}, or {cmd:nummode()}"
			di "options to control this behavior.{p_end}"
	  	}
		else {
			di "{p}{txt}Warning: at least one group contains"
			di "multiple modes. Generating missing values for"
			di "the mode of these groups. Use the {cmd:maxmode},"
			di "{cmd:minmode}, or {cmd:nummode()}"
			di "options to control this behavior.{p_end}"
		}
	  }
	}
		
end
