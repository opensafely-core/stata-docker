{smcl}
{* *! version 1.0.17  14dec2018}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects ipw" "mansection TE teffectsipw"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects postestimation" "help teffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{viewerjumpto "Syntax" "teffects ipw##syntax"}{...}
{viewerjumpto "Menu" "teffects ipw##menu"}{...}
{viewerjumpto "Description" "teffects ipw##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_ipw##linkspdf"}{...}
{viewerjumpto "Options" "teffects ipw##options"}{...}
{viewerjumpto "Examples" "teffects ipw##examples"}{...}
{viewerjumpto "Video example" "teffects ipw##video"}{...}
{viewerjumpto "Stored results" "teffects ipw##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[TE] teffects ipw} {hline 2}}Inverse-probability weighting{p_end}
{p2col:}({mansection TE teffectsipw:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:teffects} {cmd:ipw}
   {cmd:(}{it:{help varname:ovar}}{cmd:)}
   {cmd:(}{it:{help varname:tvar}} {it:{help varlist:tmvarlist}}
      [{cmd:,} {it:{help teffects ipw##tmodel:tmodel}}
	{opt nocons:tant}]{cmd:)}
	{ifin} 
        [{it:{help teffects ipw##weight:weight}}]
     [{cmd:,}
          {it:{help teffects ipw##stat:stat}}
          {it:{help teffects ipw##options_table:options}}]

{phang}
{it:ovar} is a binary, count, continuous, fractional, or nonnegative outcome
of interest.

{phang}
{it:tvar} must contain integer values representing the treatment levels.

{phang}
{it:tmvarlist} specifies the variables that predict treatment assignment in
the treatment model.

{synoptset 22 tabbed}{...}
{marker tmodel}{...}
{synopthdr:tmodel}
{synoptline}
{syntab:Model}
{synopt :{opt logit}}logistic treatment model; the default{p_end}
{synopt :{opt probit}}probit treatment model{p_end}
{synopt :{opth hetprobit(varlist)}}heteroskedastic probit treatment model{p_end}
{synoptline}
{p 4 6 2}
{it:tmodel} specifies the model for the treatment variable.{p_end}
{p 4 6 2}
For multivalued treatments, only {cmd:logit} is available and multinomial
logit is used.{p_end}

{marker stat}{...}
{synopthdr:stat}
{synoptline}
{syntab:Stat}
{synopt :{opt ate}}estimate average treatment effect in population; the
default{p_end}
{synopt :{opt atet}}estimate average treatment effect on the treated{p_end}
{synopt :{opt pom:eans}}estimate potential-outcome means{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust}, 
	{opt cl:uster} {it:clustvar},
	{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt aeq:uations}}display auxiliary-equation results{p_end}
{synopt :{it:{help teffects ipw##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help teffects ipw##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}

{syntab:Advanced}
{synopt :{opt pstol:erance(#)}}set tolerance for overlap assumption{p_end}
{synopt :{opth os:ample(newvar)}}{it:newvar} identifies observations that
violate the overlap assumption{p_end}
{synopt :{opt con:trol(# | label)}}specify the level of {it:tvar} that is the
control{p_end}
{synopt :{opt tle:vel(# | label)}}specify the level of {it:tvar} that is the
treatment{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{it:tmvarlist} may contain factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, and {opt statsby} are allowed;
see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp teffects_postestimation TE:teffects postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Continuous outcomes >}
             {bf:Inverse-probability weighting (IPW)}

{phang}
{bf:Statistics > Treatment effects > Binary outcomes >}
             {bf:Inverse-probability weighting (IPW)}

{phang}
{bf:Statistics > Treatment effects > Count outcomes >}
             {bf:Inverse-probability weighting (IPW)}

{phang}
{bf:Statistics > Treatment effects > Fractional outcomes >}
             {bf:Inverse-probability weighting (IPW)}

{phang}
{bf:Statistics > Treatment effects > Nonnegative outcomes >}
             {bf:Inverse-probability weighting (IPW)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:teffects} {cmd:ipw} estimates the average treatment effect, the
average treatment effect on the treated, and the potential-outcome
means from observational data by inverse-probability weighting (IPW).  IPW
estimators use estimated probability weights to correct for the missing data
on the potential outcomes.  {cmd:teffects} {cmd:ipw} accepts a continuous,
binary, count, fractional, or nonnegative outcome and allows a multivalued
treatment.

{pstd}
See
{bf:{mansection TE teffectsintro:[TE] teffects intro}} or
{bf:{mansection TE teffectsintroadvanced:[TE] teffects intro advanced}}
for more information about estimating treatment effects from observational
data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectsipwQuickstart:Quick start}

        {mansection TE teffectsipwRemarksandexamples:Remarks and examples}

        {mansection TE teffectsipwMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
    {helpb estimation options:[R] Estimation options}.

{dlgtab:Stat}

{phang}
{it:stat} is one of three statistics: {cmd:ate}, {cmd:atet}, or {cmd:pomeans}.
{cmd:ate} is the default.

{pmore}
{cmd:ate} specifies that the average treatment effect be estimated.

{pmore}
{cmd:atet} specifies that the average treatment effect on the treated be
estimated.

{pmore}
{cmd:pomeans} specifies that the potential-outcome means for each treatment
level be estimated.

{dlgtab:SE/Robust}

INCLUDE help vce_rcbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
    {helpb estimation options:[R] Estimation options}.

{phang}
{cmd:aequations} specifies that the results for the outcome-model or the
treatment-model parameters be displayed.  By default, the results for these
auxiliary parameters are not displayed.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt  iter:ate(#)},
[{cmd:no}]{opt log},
and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
{it:init_specs} is one of

{pmore2}
{it:matname} [{cmd:,} {cmd:skip} {cmd:copy}]

{pmore2}
{it:#} [{cmd:,} {it:#} ...]{cmd:,} {cmd:copy}

{dlgtab:Advanced}

{phang}
{opt pstolerance(#)} specifies the tolerance used to check the overlap
assumption. The default value is {cmd:pstolerance(1e-5)}.  {cmd:teffects} will
exit with an error if an observation has an estimated propensity score smaller
than that specified by {cmd:pstolerance()}.

{marker osample}{...}
{phang}
{opth osample(newvar)} specifies that indicator variable {it:newvar} be
created to identify observations that violate the overlap assumption.

{phang}
{opt control(# | label)} specifies the level of {it:tvar}
that is the control. The default is the first treatment level.  You may
specify the numeric level {it:#} (a nonnegative integer) or the label
associated with the numeric level.  {cmd:control()} may not be specified with
statistic {cmd:pomeans}.  {cmd:control()} and {cmd:tlevel()} may not specify
the same treatment level.

{phang}
{opt tlevel(# | label)} specifies the
level of {it:tvar} that is the treatment for the statistic {cmd:atet}.
The default is the second treatment level.  You may specify the numeric
level {it:#} (a nonnegative integer) or the label associated with
the numeric level.  {cmd:tlevel()} may only be specified with statistic
{cmd:atet}.  {cmd:tlevel()} and {cmd:control()} may not specify the same
treatment level.

{phang}
The following option is available with {cmd:teffects} {cmd:ipw} but is not
shown in the dialog box:

{phang}
{cmd:coeflegend};
{helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the average treatment effect of smoking on birthweight, using a
probit model to predict treatment status{p_end}
{phang2}{cmd:. teffects ipw (bweight) (mbsmoke mmarried c.mage##c.mage}
            {cmd:fbaby medu, probit)}

{pstd}Estimate the average treatment effect on the treated{p_end}
{phang2}{cmd:. teffects ipw (bweight) (mbsmoke mmarried c.mage##c.mage}
            {cmd:fbaby medu, probit), atet}

{pstd}Estimate the average treatment effect as a percentage{p_end}
{phang2}{cmd:. teffects ipw (bweight) (mbsmoke mmarried c.mage##c.mage}
            {cmd:fbaby medu, probit), coeflegend}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=fmnkEmlJPOU&feature=c4-overview&list=UUVk4G4nEtBS4tLOyHqustDA":Treatment effects: Inverse-probability weighting}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:teffects} {cmd:ipw} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(n}{it:j}{cmd:)}}number of observations for treatment level {it:j}{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
{synopt :{cmd:e(treated)}}level of treatment variable defined as
treated{p_end}
{synopt :{cmd:e(control)}}level of treatment variable defined as
control{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:teffects}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of outcome variable{p_end}
{synopt :{cmd:e(tvar)}}name of treatment variable{p_end}
{synopt :{cmd:e(subcmd)}}{cmd:ipw}{p_end}
{synopt :{cmd:e(tmodel)}}{cmd:logit}, {cmd:probit}, or {cmd:hetprobit}{p_end}
{synopt :{cmd:e(stat)}}statistic estimated, {cmd:ate}, {cmd:atet}, or
{cmd:pomeans}{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(tlevels)}}levels of treatment variable{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
