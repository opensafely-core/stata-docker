{smcl}
{* *! version 1.0.7  25apr2019}{...}
{viewerdialog "bayes: metobit" "dialog bayes_metobit"}{...}
{vieweralsosee "[BAYES] bayes: metobit" "mansection BAYES bayesmetobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[ME] metobit" "help metobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_metobit##syntax"}{...}
{viewerjumpto "Menu" "bayes_metobit##menu"}{...}
{viewerjumpto "Description" "bayes_metobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_metobit##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_metobit##examples"}{...}
{viewerjumpto "Stored results" "bayes_metobit##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[BAYES] bayes: metobit} {hline 2}}Bayesian multilevel tobit
regression{p_end}
{p2col:}({mansection BAYES bayesmetobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt metobit}
{depvar} {it:fe_equation} [{cmd:||} {it:re_equation}] 
	[{cmd:||} {it:re_equation} ...] 
	[{cmd:,} {it:{help bayes_metobit##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin}
        [{it:{help bayes_metobit##weight:weight}}]
	[{cmd:,} {it:{help bayes_metobit##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:levelvar}{cmd::} [{varlist}]
		[{cmd:,} {it:{help bayes_metobit##re_options:re_options}}]

{p 8 18 2}
	for a random effect among the values of a factor variable

{p 12 24 2}
	{it:levelvar}{cmd::} {cmd:R.}{varname}

{p 4 4 2}
    {it:levelvar} either is a variable identifying the group structure for the
    random effects at that level or is {cmd:_all}, representing one group
    comprising all observations.{p_end}

{synoptset 23 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the {help bayes_glossary##fixed_effects_parameters:fixed-effects} equation{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synoptline}

{synoptset 23 tabbed}{...}
{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(metobit##vartype:vartype)}}variance-covariance 
structure of the {help bayes_glossary##random_effects_parameters:random effects}; only structures {cmd:independent}, {cmd:identity}, and {cmd:unstructured}
supported{p_end}
{synopt :{opt nocons:tant}}suppress constant term from the random-effects 
equation{p_end}
{synoptline}

{synoptset 23 tabbed}{...}
{marker options_table}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{synopt :{cmd:ll(}{varname}|{it:#}{cmd:)}}left-censoring variable or limit{p_end}
{synopt :{cmd:ul(}{varname}|{it:#}{cmd:)}}right-censoring variable or limit{p_end}

{syntab :Reporting}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
INCLUDE help bayesme_display

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar}, {it:indepvars}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:metobit,} {cmd:level()} is equivalent to 
{cmd:bayes,} {cmd:clevel():} {cmd:metobit}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help metobit##options:{it:Options}} in {manhelp metobit ME}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
{p2coldent:* {opt igammapr:ior(# #)}}specify shape and scale of default inverse-gamma prior for variance components; default is {cmd:igammaprior(0.01 0.01)}{p_end}
{p2coldent:* {cmdab:iwishartpr:ior(}{help bayes##iwishartpriorspec:{it:#} [...]}{cmd:)}}specify degrees of freedom and, optionally, scale matrix of default inverse-Wishart prior for unstructured random-effects covariance{p_end}
{* INCLUDE help bayesecmd_opts*}
INCLUDE help bayesmh_prioropts

{marker options_simulation}{...}
{syntab:{help bayes##simulation_options:Simulation}}
INCLUDE help bayesmh_simopts
{synopt :{opt restubs(restub1 restub2 ...)}}specify stubs for random-effects parameters for all levels{p_end}

{marker options_blocking}{...}
{syntab:{help bayes##blocking_options:Blocking}}
{p2coldent:* {opt blocksize(#)}}maximum block size; default is {cmd:blocksize(50)}{p_end}
INCLUDE help bayesmh_blockopts
  {p2coldent:* {opt noblock:ing}}do not block parameters by default{p_end}

{marker options_initialization}{...}
{syntab:{help bayes##initialization_options:Initialization}}
INCLUDE help bayesmh_initopts
{p2coldent:* {opt noi:sily}}display output from the estimation command during initialization{p_end}

{marker options_adaptation}{...}
{syntab:{help bayes##adaptation_options:Adaptation}}
INCLUDE help bayesmh_adaptopts

{marker options_reporting}{...}
{syntab:{help bayes##reporting_options:Reporting}}
INCLUDE help bayesme_reportopts
{synopt :{opt melabel}}display estimation table using the same row labels as
{cmd:metobit}{p_end}
INCLUDE help bayesme_reportopts2

{marker options_advanced}{...}
{syntab:{help bayes##advanced_options:Advanced}}
INCLUDE help bayesmh_advancedopts
{synoptline}
{p 4 6 2}* Starred options are specific to the {cmd:bayes} prefix; other
options are common between {cmd:bayes} and {helpb bayesmh}.{p_end}
{p 4 6 2}Options {cmd:prior()} and {cmd:block()} may be repeated.{p_end}
{p 4 6 2}{helpb bayesmh##priorspec:{it:priorspec}} and
{helpb bayesmh##paramref:{it:paramref}} are defined in {manhelp bayesmh BAYES}.
{p_end}
{p 4 6 2}{it:paramref} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}See {manhelp bayesian_postestimation BAYES:Bayesian postestimation} for
features available after estimation.{p_end}
{p2colreset}{...}
{p 4 6 2}Model parameters are regression coefficients
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}},
error variance {cmd:{c -(}e.}{it:depvar}{cmd::sigma2{c )-}}, random effects
{cmd:{c -(}}{it:rename}{cmd:{c )-}}, and either variance components
{cmd:{c -(}}{it:rename}{cmd::sigma2{c )-}} or, if option
{cmd:covariance(unstructured)} is specified, matrix parameter
{cmd:{c -(}}{it:restub}{cmd::Sigma,matrix{c )-}}; see
{mansection BAYES bayesRemarksandexamplesLikelihoodmodel:{it:Likelihood model}}
in {bf:[BAYES] bayes} for how {it:rename}s and {it:restub} are defined.
Use the {cmd:dryrun} option to see the definitions of model parameters
prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models > Bayesian regression > Tobit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: metobit} fits a Bayesian multilevel tobit regression to a
censored continuous outcome;
see {manhelp bayes BAYES} and {manhelp metobit ME} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesmetobitQuickstart:Quick start}

        {mansection BAYES bayesmetobitRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesmetobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse mathscores}

{pstd}
Fit Bayesian two-level tobit regression with random intercepts by {cmd:school} 
imposing an artificial upper limit at 30 and using default priors{p_end}
{phang2}{cmd:. bayes: metobit math5 math3 || school:, ul(30)}

{pstd}
In addition to the main model parameters, display results for the first 
5 random effects{p_end}
{phang2}{cmd:. bayes, showreffects({U0[1/5]})}

{pstd}
Check MCMC convergence for the main model parameters{p_end}
{phang2}{cmd:. bayesgraph diagnostics _all}

{pstd}
Check MCMC convergence for random effects of schools 10 and 40{p_end}
{phang2}{cmd:. bayesgraph diagnostics {U0[(10 40).id]}}

{pstd}
Plot histograms of posterior distributions of the first 12 random effects 
on one graph{p_end}
{phang2}{cmd:. bayesgraph histogram {U0[1/12]}, byparm}

{pstd}
Display estimation results using {cmd:metobit}'s parameter labels and 
compute log marginal-likelihood on replay{p_end}
{phang2}{cmd:. bayes, melabel remargl}

{pstd}
Specify the same uniform priors for all regression coefficients and decrease 
the MCMC sample size to 1,000 from the default of 10,000{p_end}
{phang2}{cmd:. bayes, prior({math5:math3 _cons}, uniform(-100,100)) mcmcsize(1000): metobit math5 math3 || school:, ul(30)}

{pstd}
As above, but use a shortcut notation to refer to all regression
coefficients and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, prior({math5:}, uniform(-100,100)) mcmcsize(1000) rseed(12345): metobit math5 math3 || school:, ul(30)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}
