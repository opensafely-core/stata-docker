{smcl}
{* *! version 1.0.9  12dec2018}{...}
{viewerdialog "bayes: zip" "dialog bayes_zip"}{...}
{vieweralsosee "[BAYES] bayes: zip" "mansection BAYES bayeszip"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes" "help bayes"}{...}
{vieweralsosee "[R] zip" "help zip"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes_zip##syntax"}{...}
{viewerjumpto "Menu" "bayes_zip##menu"}{...}
{viewerjumpto "Description" "bayes_zip##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes_zip##linkspdf"}{...}
{viewerjumpto "Examples" "bayes_zip##examples"}{...}
{viewerjumpto "Stored results" "bayes_zip##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[BAYES] bayes: zip} {hline 2}}Bayesian zero-inflated Poisson regression{p_end}
{p2col:}({mansection BAYES bayeszip:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {it:bayesopts}] {cmd::} {opt zip}
{depvar} [{indepvars}]
{ifin}
[{it:{help bayes_zip##weight:weight}}]{cmd:,}
{opt inf:late}{cmd:(}{varlist}[{cmd:,} {opth off:set(varname)}]|{cmd:_cons)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opt inf:late()}}equation that determines whether the count is
zero{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include {opt ln(varname_e)} in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{synopt :{opt probit}}use probit model to characterize excess zeros;
default is logit{p_end}

{syntab:Reporting}
{synopt :{opt irr}}report incidence-rate ratios{p_end}
{synopt :{it:{help zip##display_options:display_options}}}control
INCLUDE help shortdes-displayoptbayes

{synopt :{opt l:evel(#)}}set credible level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}
* {opt inf:late}{cmd:(}{it:varlist}[{cmd:,} {opt off:set(varname)}]|{cmd:_cons)}
is required.{p_end}
INCLUDE help fvvarlist2
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:bayes:} {cmd:zip,} {cmd:level()} is equivalent to
{cmd:bayes,} {cmd:clevel():} {cmd:zip}.{p_end}
{p 4 6 2}For a detailed description of {it:options}, see
{help zip##options:{it:Options}} in {manhelp zip R}.{p_end}

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients; default is {cmd:normalprior(100)}{p_end}
{* INCLUDE help bayesecmd_opts*}
INCLUDE help bayesmh_prioropts

{marker options_simulation}{...}
  {syntab:{help bayes##simulation_options:Simulation}}
INCLUDE help bayesmh_simopts

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
INCLUDE help bayes_clevel_hpd_short
{p2coldent:* {opt ir:r}}report incidence-rate ratios{p_end}
INCLUDE help bayesecmd_reportopts_special

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
{cmd:{c -(}}{it:depvar}{cmd::}{it:indepvars}{cmd:{c )-}}
for the main regression and
{cmd:{c -(}inflate:}{it:varlist}{cmd:{c )-}}
for the inflation equation.
Use the {cmd:dryrun} option to see the definitions
of model parameters prior to estimation.{p_end}
{p 4 6 2}For a detailed description of {it:bayesopts}, see
{help bayes##options:{it:Options}} in {manhelp bayes BAYES}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Count outcomes > Bayesian regression > Zero-inflated Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayes: zip} fits a Bayesian zero-inflated Poisson regression
to a nonnegative count outcome with a high fraction of zeros;
see {manhelp bayes BAYES} and {manhelp zip R:zip} for details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayeszipQuickstart:Quick start}

        {mansection BAYES bayeszipRemarksandexamples:Remarks and examples}

        {mansection BAYES bayeszipMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse fish}

{pstd}
Fit Bayesian zero-inflated Poisson regression using default priors, 
specifying a dot be displayed every 100 iterations{p_end}
{phang2}{cmd:. bayes, dots(100): zip count persons livebait, inflate(child)}

{pstd}
Replay results and report incidence-rate ratios{p_end}
{phang2}{cmd:. bayes, irr}

{pstd}
Draw diagnostic plot to examine {cmd:{inflate:_cons}}{p_end}
{phang2}{cmd:. bayesgraph diagnostic {inflate:_cons}}

{pstd}
Use standard deviation of 10 of the default normal prior for regression
coefficients, increase the burn-in period to 5,000 from the default of 2,500,
and specify random-number seed for reproducibility{p_end}
{phang2}{cmd:. bayes, dots(100) normalprior(10) burnin(5000) rseed(12345): zip count persons livebait, inflate(child)}

{pstd}
Use uniform priors for regression coefficients in the inflation equation{p_end}
{phang2}{cmd:. bayes, dots(100) prior({inflate:child _cons}, uniform(-5,5)): zip count persons livebait, inflate(child)}

{pstd}
Same as above, but use a shortcut notation to refer to all regression 
coefficients from the inflation equation{p_end}
{phang2}{cmd:. bayes, dots(100) prior({inflate:}, uniform(-5,5)): zip count persons livebait, inflate(child)}

{pstd}
Display a 90% credible interval on replay{p_end}
{phang2}{cmd:. bayes, clevel(90)}

{pstd}
Save MCMC results on replay{p_end}
{phang2}{cmd:. bayes, saving(mymcmc)}


{marker results}{...}
{title:Stored results}

{pstd}
See {help bayes##results:{it:Stored results}} in {manhelp bayes BAYES}.
{p_end}