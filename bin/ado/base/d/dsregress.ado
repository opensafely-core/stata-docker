*! version 1.0.5  13may2019
program dsregress
	version 16.0

	syntax [anything(everything)] [, reestimate *]

	if (replay() & `"`reestimate'"' == "") {
		Playback `0'	
	}
	else  {
		Estimate `0'
	}
end

					//----------------------------//
					// play back result
					//----------------------------//
program Playback 
	syntax [, *]

	if ("`e(cmd)'"! = "dsregress") {
		di as err "results for {bf:dsregress} not found"
		exit 301
	}
	else {
		_dslasso_display `0'
	}
end

					//----------------------------//
					// estimate
					//----------------------------//
program Estimate
	syntax [anything(name=eq)]	///
		[if] [in]		///
		[, CONTrols(passthru)	///	
		vce(passthru)		///
		noconstant		///	common_opts
		SELection(passthru)	///
		grid(passthru)		///
		SQRTlasso		///
		debug			///	NotDoc
		*]			//	advanced options
	
	/*----------------- parsing -------------------------------*/
	local cmd cmd(dsregress)
	local model model(linear)
	local zero zero(`0')

	_dsregress_parse `eq' 	///
		`if' `in' 	///
		, `controls' 	///
		`vce' 		///
		`constant' 	///
		`selection'	///
		`grid'		///
		`sqrtlasso'	///
		`debug'		///
		`cmd'		///
		`model'		///
		`zero'		///
		`options'
	local opts `s(opts)'

	/*----------------- estimation ------------------------------*/
	_dslasso `eq' `if' `in', `opts'
end