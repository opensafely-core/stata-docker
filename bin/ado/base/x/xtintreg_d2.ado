*! Version 1.2.1  09feb2015
program define xtintreg_d2
	version 8.0
	args todo  b lnf g negH
	if "`g'"=="" {
		tempname g
	}
	if "`negH'" == "" {
		tempname negH
	}
	tempname lnfv
	capture generate double `lnfv' = 0
	tempvar theta1 sigmav
	mleval `theta1' = `b', eq(1)
	local 0 [$ML_wtyp $ML_wexp]
	syntax [fw aw pw iw/]
	local w `exp'
	local blast = colsof(`b') 
	xt_iis /* get i variable from xt settings */
	local ivar `s(ivar)'
	tempvar p
	gen `c(obs_t)' `p' = _n 
	qui summ `p' if $ML_samp
	local jbeg = r(min)
	local jend = r(max)
	/* $ML_xc1 is noconstant if noconstant has been specified */
	/* offset is taken care of in theta1 */

        if "$XTI_madapt"!="" {
                local madapt madapt
        }
 	if "$XTI_noadap"=="" {
		_XTLLCalc  $ML_y $ML_x1 in `jbeg'/`jend',		///
		xbeta(`theta1') w(`w') lnf(`lnfv') b(`b') g(`g')        ///
		negH(`negH') quad($XTI_quad) ivar(`ivar')               ///
		cvar($XTI_cvar) $ML_xc1 shat($XTI_shat) hh($XTI_hh)	///
		todo(`todo') intreg avar($XTI_qavar) wvar($XTI_qwvar)	///
		`madapt' logF($XTI_logF)
	}
	else {
		_XTLLCalc  $ML_y $ML_x1 in `jbeg'/`jend',		///
		xbeta(`theta1') w(`w') lnf(`lnfv') b(`b') g(`g')        ///
		negH(`negH') quad($XTI_quad) ivar(`ivar')               ///
		cvar($XTI_cvar) $ML_xc1 $XTI_noadap			///
		todo(`todo') intreg avar($XTI_qavar) wvar($XTI_qwvar)	///
		logF($XTI_logF)
	}
	scalar `lnf' = `lnfv'[`jend']
	local gck = matmissing(`g')
	local negHck = matmissing(`negH')
	if ((`gck'==1) | (`negHck' == 1)){
		scalar `lnf' = .
	}
/*	todo=2 at the end of an iteration
	Here we are stopping the quadrature adaptation if the log likelihood
	value for this iteration versus the previous is less than a reldif
	of 1e-6.
	Continual adapting causes convergence problems with d2 method
	(d0 is okay).
*/
	if "$XTI_madapt"!="" {
		if `todo'==2 {
			if ($ML_ic>0 & reldif(`lnf', scalar($XTI_lnf)) < 1e-6) {
				global XTI_madapt
			}
		scalar $XTI_lnf = `lnf'
		}
	}
end

