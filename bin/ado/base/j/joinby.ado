*! version 2.0.8  09feb2015
program define joinby, sortpreserve
	version 6.0
	syntax [varlist(default=none)] using/ [, /*
		*/ UNMatched(str) noLabel REPLACE UPDATE _merge(str) ]

	UnMatch `"`unmatch'"'
	local unmatch `r(unmatch)'

	if "`varlist'" == "" {
		Common `"`using'"'
		local match `r(common)'
		if "`match'" == "" {
			di in re /*
			*/ "no variables in common to master and using data"
			di in re "thus a join is not possible"
			exit 198
		}
		di in gr "join on common variables: " in ye "`match'"
	}
	else	local match `varlist'

	if "`_merge'" == "" {
		if "`unmatch'" != "none" {
			local _merge _merge
			confirm new var `_merge'
		}
		else	tempvar _merge
	}

	quiet {
		tempfile ufile Ufile
		tempname MUNIQUE

		preserve

		* make key (match,_UUNIQUE) in using data, saving in ufile
		use `"`using'"', replace
		tempvar UUNIQUE
		confirm new var `_merge'
		sort `match'
		by `match' : gen `c(obs_t)' `UUNIQUE' = _n
		sort `match' `UUNIQUE'
		save `"`ufile'"'

		* save number of dups in using in Ufile
		keep `match' `UUNIQUE'
		by `match' : drop if _n<_N
		sort `match'
		save `"`Ufile'"'

		* continue with master data
		restore

		capt confirm new var `UUNIQUE'
		if _rc {
			di in re /*
			*/ "tempvar `UUNIQUE' using already existed in master"
			exit 9261
		}

		if "`unmatch'" == "none" | "`unmatch'" == "master" {
			local keepopt "nokeep"
		}
		sort `match'
		merge `match' using `"`Ufile'"', `keepopt' _merge(`_merge')
		des
		if "`unmatch'" == "none" {
			keep if `_merge' == 3
		}
		else if "`unmatch'" == "using" {
			drop if `_merge' == 1
		}
		if _N == 0 {
			local empty 1
			noi di in gr "(joinby on `match' is empty)"
			* ensure importing vars from using data
			* by temporarily setting the dataset to one obs
			set obs 1
		}

		sort `match'
		by `match' : gen `c(obs_t)' `MUNIQUE' = _n
		expand = `UUNIQUE'
		sort `match' `MUNIQUE'
		by `match' `MUNIQUE' : replace `UUNIQUE' = _n
		sort `match' `UUNIQUE'

		tempvar tmerge
		merge `match' `UUNIQUE' using `"`ufile'"', /*
			*/ `label' `update' `replace' nokeep _merge(`tmerge')
		mac drop S_FN S_FNDATE

		if "`empty'" ~= "" {
			drop in 1
			exit 0
		}
		DefLabel "`_merge'" "`update'"
	}
end


/* Common fname
   returns in r(common) the list of common variables of the data in memory
   with the data in fname
*/
program define Common, rclass
	args fname

	unab allm : _all
	preserve
	use using `"`fname'"' in 1, clear
	tokenize "`allm'"
	local i 1
	while "``i''" != "" {
		capt confirm var ``i''
		if !_rc {
			local common `common' ``i''
		}
		local i = `i'+1
	}
	return local common `common'
end


/* UnMatch str
   returns in r(unmatch) the verified value of the -unmatch- option,
   or none if unmatch was not specified
*/
program define UnMatch, rclass
	args unmatch

	if `"`unmatch'"' == "" {
		return local unmatch none
	}
	else {
		local unmatch = lower(`"`unmatch'"')
		local len  = length(`"`unmatch'"')

		if `"`unmatch'"' == bsubstr("both",1,`len') {
			return local unmatch both
		}
		else if `"`unmatch'"' == bsubstr("master",1,`len') {
			return local unmatch master
		}
		else if `"`unmatch'"' == bsubstr("using",1,`len') {
			return local unmatch using
		}
		else if `"`unmatch'"' == bsubstr("none",1,`len') {
			return local unmatch none
		}
		else {
			di in re `"`unmatch' is invalid value for unmatch()"'
			exit 198
		}
	}
end


/* DefLabel _merge update
   defines value labels for _merge, depending whether update-merging was specified.
   DefLabel takes care to ensure that the value label __MERGE does not exist, or
   was actually generated by joinby/mmerge, and hence may be overwritten (I used a
   signature method).
*/
program define DefLabel
	args _merge update

	capt label list __MERGE
	if !_rc {
		local l : label __MERGE 9999
		if "`l'" == "signature" {
			label drop __MERGE
		}
		else {
			di in bl /*
			*/ "value label __MERGE for `_merge' already exists"
			exit
		}
	}

	if "`update'" == "" {
		#del ;
		label def __MERGE
				   1 "only in master data"
				   2 "only in using data"
				   3 "both in master and using data"
				9999 "signature" ;
		#del cr
	}
	else {
		#del ;
		label def __MERGE
				   1 "only in master data"
	           	   2 "only in using data"
				   3 "in both, master agrees with using data"
				   4 "in both, missing in master data updated"
				   5 "in both, master disagrees with using data"
				9999 "signature" ;
		#del cr
	}
	label val `_merge' __MERGE
end

exit