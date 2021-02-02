*! version 1.0.0  06feb2019
program cmmprobit_estat
	version 16

	if ("`e(cmd)'" != "cmmprobit") { 
				
di as err "{helpb cmmprobit##|_new:cmmprobit} estimation results not found"
		
		exit 301
	}

	gettoken sub : 0, parse(" ,")

	local lsub = strlen("`sub'")
	
	if (   "`sub'" == substr("covariance",  1, max(3, `lsub'))     ///
	     | "`sub'" == substr("correlation", 1, max(3, `lsub'))     ///
	     | "`sub'" == substr("facweights",  1, max(4, `lsub')) ) {
		
		asprobit_estat `0'
	}
	else {
		estat_default `0'
	}
end

