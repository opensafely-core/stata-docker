{smcl}
{* *! version 1.0.10  04apr2019}{...}
{viewerdialog eintreg "dialog eintreg"}{...}
{viewerdialog xteintreg "dialog xteintreg"}{...}
{viewerdialog "svy: eintreg" "dialog eintreg, message(-svy-) name(svy_eintreg)"}{...}
{vieweralsosee "[ERM] eintreg" "mansection ERM eintreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eintreg postestimation" "help eintreg postestimation"}{...}
{vieweralsosee "[ERM] eintreg predict" "help eintreg predict"}{...}
{vieweralsosee "[ERM] predict advanced" "help erm predict advanced"}{...}
{vieweralsosee "[ERM] predict treatment" "help erm predict treatment"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] estat teffects" "help erm estat teffects"}{...}
{vieweralsosee "[ERM] Intro 9" "mansection ERM Intro9"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] intreg" "help intreg"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] tobit" "help tobit"}{...}
{vieweralsosee "[XT] xtintreg" "help xtintreg"}{...}
{vieweralsosee "[XT] xttobit" "help xttobit"}{...}
{viewerjumpto "Syntax" "eintreg##syntax"}{...}
{viewerjumpto "Menu" "eintreg##menu"}{...}
{viewerjumpto "Description" "eintreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "eintreg##linkspdf"}{...}
{viewerjumpto "Options" "eintreg##options"}{...}
{viewerjumpto "Examples" "eintreg##examples"}{...}
{viewerjumpto "Stored results" "eintreg##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ERM] eintreg} {hline 2}}Extended interval regression{p_end}
{p2col:}({mansection ERM eintreg:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic interval regression with endogenous covariates

{p 8 16 2}
{cmd:eintreg}
{depvar}_1 {depvar}_2
[{indepvars}]{cmd:,}
{cmdab:endog:enous(}{help eintreg##enspec:{it:depvars}_en} {cmd:=}
    {help eintreg##enspec:{it:varlist}_en}{cmd:)}
[{help eintreg##synoptions:{it:options}}]


{pstd}
Basic interval regression with endogenous treatment assignment

{p 8 16 2}
{cmd:eintreg}
{depvar}_1 {depvar}_2
[{indepvars}]{cmd:,}
{cmdab:entr:eat(}{help eintreg##entrspec:{it:depvar}_tr}
   [{cmd:=} {help eintreg##entrspec:{it:varlist}_tr}]{cmd:)}
[{help eintreg##synoptions:{it:options}}]


{pstd}
Basic interval regression with exogenous treatment assignment

{p 8 16 2}
{cmd:eintreg}
{depvar}_1 {depvar}_2
[{indepvars}]{cmd:,}
{cmdab:extr:eat(}{help eintreg##extrspec:{it:tvar}}{cmd:)}
[{help eintreg##synoptions:{it:options}}]


{pstd}
Basic interval regression with sample selection

{p 8 16 2}
{cmd:eintreg}
{depvar}_1 {depvar}_2
[{indepvars}]{cmd:,}
{cmdab:sel:ect(}{help eintreg##selspec:{it:depvar}_s} {cmd:=}
    {help eintreg##selspec:{it:varlist}_s}{cmd:)}
[{help eintreg##synoptions:{it:options}}]


{pstd}
Basic interval regression with tobit sample selection

{p 8 16 2}
{cmd:eintreg}
{depvar}_1 {depvar}_2
[{indepvars}]{cmd:,}
{cmdab:tobitsel:ect(}{help eintreg##tselspec:{it:depvar}_s} {cmd:=}
    {help eintreg##tselspec:{it:varlist}_s}{cmd:)}
[{help eintreg##synoptions:{it:options}}]


{pstd}
Basic interval regression with random effects

{p 8 16 2}
{cmd:xteintreg}
{depvar}_1 {depvar}_2
[{indepvars}]
[{cmd:,} {help eintreg##synoptions:{it:options}}]



{pstd}
Interval regression combining endogenous covariates, treatment, and selection

{p 8 16 2}
{cmd:eintreg}
{depvar}_1 {depvar}_2
[{indepvars}]
{ifin}
[{help eintreg##weight:{it:weight}}]
[{cmd:,} {help eintreg##extensions:{it:extensions}}
{help eintreg##synoptions:{it:options}}]


{pstd}
Interval regression combining random effects, endogenous covariates, treatment, and selection

{p 8 16 2}
{cmd:xteintreg}
{depvar}_1 {depvar}_2
[{indepvars}]
{ifin}
[{cmd:,} {help eintreg##extensions:{it:extensions}}
{help eintreg##synoptions:{it:options}}]


{marker typedepvar}{...}
{phang}
{it:depvar}_1 and {it:depvar}_2 should have the following form:

             Type of data {space 16} {it:depvar1}  {it:depvar2}
             {hline 46}
             point data{space 10}{it:a} = [{it:a},{it:a}]{space 4}{it:a}{space 8}{it:a} 
             interval data{space 11}[{it:a},{it:b}]{space 4}{it:a}{space 8}{it:b}
             left-censored data{space 3}(-inf,{it:b}]{space 4}{cmd:.}{space 8}{it:b}
             right-censored data{space 3}[{it:a},inf){space 4}{it:a}{space 8}{cmd:.} 

             missing{space 26}{cmd:.}{space 8}{cmd:.}
             {hline 46}

{marker extensions}{...}
{synoptset 25 tabbed}{...}
{synopthdr:extensions}
{synoptline}
{syntab:Model}
{synopt :{opth endog:enous(eintreg##enspec:enspec)}}model for endogenous covariates; may be repeated{p_end}
{synopt :{opth entr:eat(eintreg##entrspec:entrspec)}}model for endogenous treatment assignment{p_end}
{synopt :{opth extr:eat(eintreg##extrspec:extrspec)}}exogenous treatment{p_end}
{synopt :{opth sel:ect(eintreg##selspec:selspec)}}probit model for selection{p_end}
{synopt :{opth tobitsel:ect(eintreg##tselspec:tselspec)}}tobit model for selection{p_end}
{synoptline}

{marker synoptions}{...}
{synopthdr}
{synoptline}
{syntab:Model}
INCLUDE help erm_model_tab

{syntab:SE/Robust}
INCLUDE help erm_vce_tab

{syntab:Reporting}
INCLUDE help erm_report_tab
{synopt :{it:{help eintreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
INCLUDE help erm_integration_tab

{syntab:Maximization}
{synopt :{it:{help eintreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker enspec}{...}
{phang}
{it:enspec} is {depvars}_en {cmd:=} {varlist}_en
    [{cmd:,} {help eintreg##enopts:{it:enopts}}]

{pmore}
where {it:depvars}_en is a list of endogenous covariates.  Each variable in
{it:depvars}_en specifies an endogenous covariate model using the
common {it:varlist}_en and options.

{marker entrspec}{...}
{phang}
{it:entrspec} is {depvar}_tr [{cmd:=} {varlist}_tr]
    [{cmd:,} {help eintreg##entropts:{it:entropts}}]

{pmore}
where {it:depvar}_tr is a variable indicating treatment assignment.
{it:varlist}_tr is a list of covariates predicting treatment assignment.

{marker extrspec}{...}
{phang}
{it:extrspec} is {it:tvar}
    [{cmd:,} {help eintreg##extropts:{it:extropts}}]

{pmore}
where {it:tvar} is a variable indicating treatment assignment.

{marker selspec}{...}
{phang}
{it:selspec} is {depvar}_s {cmd:=} {varlist}_s
    [{cmd:,} {help eintreg##selopts:{it:selopts}}]

{pmore}
where {it:depvar}_s is a variable indicating selection status.
{it:depvar}_s must be coded as 0, indicating that the
observation was not selected, or 1, indicating that the observation was
selected.  {it:varlist}_s is a list of covariates predicting selection.

{marker tselspec}{...}
{phang}
{it:tselspec} is {depvar}_s {cmd:=} {varlist}_s
    [{cmd:,} {help eintreg##tselopts:{it:tselopts}}]

{pmore}
where {it:depvar}_s is a continuous variable.
{it:varlist}_s is a list of covariates predicting {it:depvar}_s.
The censoring status of {it:depvar}_s indicates selection, where a censored
{it:depvar}_s indicates that the observation was not selected and a
noncensored {it:depvar}_s indicates that the observation was selected.

{synoptset 26 tabbed}{...}
INCLUDE help erm_reg_enopts_table
{p 4 6 2}
{opt nore} is available only with {cmd:xteintreg}.

INCLUDE help erm_reg_entropts_table
{p 4 6 2}
{opt nore} is available only with {cmd:xteintreg}.

INCLUDE help erm_reg_extropts_table

INCLUDE help erm_selopts_table
{p 4 6 2}
{opt nore} is available only with {cmd:xteintreg}.

INCLUDE help erm_tselopts_table
{p 4 6 2}
{opt nore} is available only with {cmd:xteintreg}.
{p2colreset}{...}

{p 4 6 2}
{it:indepvars},
{it:varlist}_en,
{it:varlist}_tr,
and
{it:varlist_s}
may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}_1,
{it:depvar}_2,
{it:indepvars},
{it:depvars}_en,
{it:varlist}_en,
{it:depvar}_tr, 
{it:varlist}_tr,
{it:tvar},
{it:depvar_s},
and
{it:varlist_s}
may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, and {opt statsby}
are allowed with {cmd:eintreg} and {cmd:xteintreg}.
{cmd:rolling} and {cmd:svy} are allowed with {cmd:eintreg}.
See {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are
allowed with {cmd:eintreg}; see {help weight}.{p_end}
{p 4 6 2}
{cmd:reintpoints()} and {cmd:reintmethod()} are available only with
{cmd:xteintreg}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp eintreg_postestimation ERM:eintreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{pstd}
{bf:eintreg}

{phang2}
{bf:Statistics > Endogenous covariates > Models adding selection and treatment >}
{bf:Interval regression}

{pstd}
{bf:xteintreg}

{phang2}
{bf:Statistics > Longitudinal/panel data > Endogenous covariates > Models adding selection and treatment >}
{bf:Interval regression (RE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:eintreg} fits an interval regression model that accommodates any
combination of endogenous covariates, nonrandom treatment assignment, and
endogenous sample selection.  Continuous, binary, and ordinal endogenous
covariates are allowed.  Treatment assignment may be endogenous or exogenous.
A probit or tobit model may be used to account for endogenous sample
selection.

{pstd}
{cmd:xteintreg} fits a random-effects interval regression model that
accommodates endogenous covariates, treatment, and sample selection in the
same way as {cmd:eintreg} and also accounts for correlation of observations
within panels or within groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ERM eintregQuickstart:Quick start}

        {mansection ERM eintregRemarksandexamples:Remarks and examples}

        {mansection ERM eintregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

INCLUDE help erm_model_optdes

{dlgtab:SE/Robust}

INCLUDE help erm_vce_optdes

{dlgtab:Reporting}

INCLUDE help erm_reporting_optdes

{dlgtab:Integration}

INCLUDE help erm_int_optdes

{marker maximize_options}{...}
{dlgtab:Maximization}

INCLUDE help erm_max_optdes

{pmore}
The default technique for {cmd:eintreg} is {cmd:technique(nr)}.  The default
technique for {cmd:xteintreg} is {cmd:technique(bhhh 10 nr 2)}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt eintreg} and {opt xteintreg} but
are not shown in the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse class10}

{pstd}
Interval regression with endogenous covariate {cmd:hsgpa}{p_end}
{phang2}
{cmd:. eintreg gpal gpau income, endogenous(hsgpa = income i.hscomp)}

{pstd}
As above, and account for endogenous sample selection{p_end}
{phang2}
{cmd:. eintreg gpal gpau income, endogenous(hsgpa = income i.hscomp)}
         {cmd:select(graduate = hsgpa income i.roommate i.program)}

    {hline}
{pstd}
Setup{p_end}
{phang2}
{cmd:. webuse class10re}{p_end}
{phang2}
{cmd:. xtset collegeid}{p_end}
{phang2}
{cmd:. gen gpal = gpa if gpa>=2}{p_end}
{phang2}
{cmd:. gen gpau = gpa}{p_end}
{phang2}
{cmd:. replace gpau=2 if gpa<2}{p_end}

{pstd}
Random-effects interval regression{p_end}
{phang2}
{cmd:. xteintreg gpal gpau income}

{pstd}
Random-effects interval regression with endogenous covariate {cmd:hsgpa}{p_end}
{phang2}
{cmd:. xteintreg gpal gpau income, endogenous(hsgpa = income i.hscomp)}

{pstd}
Random-effects interval regression with endogenous sample selection{p_end}
{phang2}
{cmd:. xteintreg gpal gpau income, select(graduate=income i.program)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:eintreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt :{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt :{cmd:e(N_unc)}}number of uncensored observations{p_end}
{synopt :{cmd:e(N_lc)}}number of left-censored observations{p_end}
{synopt :{cmd:e(N_rc)}}number of right-censored observations{p_end}
{synopt :{cmd:e(N_int)}}number of interval-censored observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th
{it:depvar}, ordinal{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model
test{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(n_quad)}}number of integration points for multivariate
normal{p_end}
{synopt :{cmd:e(n_quad3)}}number of integration points for trivariate
normal{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:eintreg}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt :{cmd:e(tsel_ll)}}left-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(tsel_ul)}}right-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar},
where {it:#} is determined by equation order in output{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to
perform maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th {it:depvar},
ordinal{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}

{pstd}
{cmd:xteintreg} stores the following in {cmd:e()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_g)}}number of groups{p_end}
{synopt :{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt :{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt :{cmd:e(N_unc)}}number of uncensored observations{p_end}
{synopt :{cmd:e(N_lc)}}number of left-censored observations{p_end}
{synopt :{cmd:e(N_rc)}}number of right-censored observations{p_end}
{synopt :{cmd:e(N_int)}}number of interval-censored observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th
{it:depvar}, ordinal{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model
test{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(n_quad)}}number of integration points for multivariate
normal{p_end}
{synopt :{cmd:e(n_quad3)}}number of integration points for trivariate
normal{p_end}
{synopt :{cmd:e(n_requad)}}number of integration points for random
effects{p_end}
{synopt :{cmd:e(g_min)}}smallest group size{p_end}
{synopt :{cmd:e(g_avg)}}average group size{p_end}
{synopt :{cmd:e(g_max)}}largest group size{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:xteintreg}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt :{cmd:e(tsel_ll)}}left-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(tsel_ul)}}right-censoring limit for tobit selection{p_end}
{synopt :{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar},
where {it:#} is determined by equation order in output{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(reintmethod)}}integration method for random effects{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to
perform maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th {it:depvar},
ordinal{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
