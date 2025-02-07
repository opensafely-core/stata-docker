{smcl}
{* *! version 1.3.10  28apr2019}{...}
{viewerdialog ologit "dialog ologit"}{...}
{viewerdialog "svy: ologit" "dialog ologit, message(-svy-) name(svy_ologit)"}{...}
{vieweralsosee "[R] ologit" "mansection R ologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ologit postestimation" "help ologit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: ologit" "help bayes ologit"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[CM] cmrologit" "help cmrologit"}{...}
{vieweralsosee "[CM] cmroprobit" "help cmroprobit"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[FMM] fmm: ologit" "help fmm ologit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[ME] meologit" "help meologit"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "[R] slogit" "help slogit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[XT] xtologit" "help xtologit"}{...}
{viewerjumpto "Syntax" "ologit##syntax"}{...}
{viewerjumpto "Menu" "ologit##menu"}{...}
{viewerjumpto "Description" "ologit##description"}{...}
{viewerjumpto "Links to PDF documentation" "ologit##linkspdf"}{...}
{viewerjumpto "Options" "ologit##options"}{...}
{viewerjumpto "Examples" "ologit##examples"}{...}
{viewerjumpto "Stored results" "ologit##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] ologit} {hline 2}}Ordered logistic regression{p_end}
{p2col:}({mansection R ologit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:ologit}
{depvar}
[{indepvars}]
{ifin}
[{it:{help ologit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
        {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
	{opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help ologit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help ologit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fmm}, {opt fp}, {opt jackknife},
{opt mfp}, {opt mi estimate}, {opt nestreg}, {opt rolling}, {opt statsby},
{opt stepwise}, and {opt svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_ologit BAYES:bayes: ologit} and
{manhelp fmm_ologit FMM:fmm: ologit}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp ologit_postestimation R:ologit postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Ordered logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{opt ologit} fits ordered logit models of ordinal variable {depvar} on the
independent variables {indepvars}.  The actual values taken on by the dependent
variable are irrelevant, except that larger values are assumed to correspond
to "higher" outcomes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ologitQuickstart:Quick start}

        {mansection R ologitRemarksandexamples:Remarks and examples}

        {mansection R ologitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth offset(varname)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt or} reports the estimated coefficients transformed to odds
ratios, that is, exp(b) rather than b.  Standard errors and confidence intervals
are similarly transformed.  This option affects how results are displayed,
not how they are estimated.  {opt or} may be specified at
estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following options are available with {opt ologit} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fullauto}{p_end}

{pstd}Ordered logistic regression{p_end}
{phang2}{cmd:. ologit rep77 foreign length mpg}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2f}{p_end}
{phang2}{cmd:. svyset psuid [pw=finalwgt], strata(stratid)}

{pstd}Ordered logistic regression with survey data{p_end}
{phang2}{cmd:. svy: ologit health female black age c.age#c.age}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ologit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cd)}}number of completely determined observations{p_end}
{synopt:{cmd:e(k_cat)}}number of categories{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ologit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                     maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(cat)}}category values{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
