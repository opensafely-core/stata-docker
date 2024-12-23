{smcl}
{* *! version 2.1.6  15may2018}{...}
{viewerdialog predict "dialog mgarch_dvech_p"}{...}
{vieweralsosee "[TS] mgarch dvech postestimation" "mansection TS mgarchdvechpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] mgarch dvech" "help mgarch dvech"}{...}
{viewerjumpto "Postestimation commands" "mgarch dvech postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mgarch_dvech_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mgarch dvech postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mgarch dvech postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mgarch dvech postestimation##examples"}{...}
{p2colset 1 37 41 2}{...}
{p2col:{bf:[TS] mgarch dvech postestimation} {hline 2}}Postestimation tools
for mgarch dvech{p_end}
{p2col:}({mansection TS mgarchdvechpostestimation:View complete PDF manual entry}){p_end}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after
{cmd:mgarch dvech}:

{synoptset 23}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb mgarch_dvech_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mgarch dvech postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS mgarchdvechpostestimationRemarksandexamples:Remarks and examples}

        {mansection TS mgarchdvechpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt v:ariance}}conditional variances and covariances{p_end}
{synoptline}
INCLUDE help esample
{p2colreset}{...}

{synoptset 23 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Options}
{synopt :{opt e:quation(eqnames)}}names of equations for which
             predictions are made{p_end}
{synopt :{opt dyn:amic(time_constant)}}begin dynamic forecast at specified time
{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear prediction and conditional variances and covariances.  All predictions
are available as static one-step-ahead predictions or as dynamic multistep
predictions, and you can control when dynamic predictions begin.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear predictions of the dependent
variables.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt variance} predicts the conditional variances and conditional covariances.

{dlgtab:Options}

{phang}
{opt equation(eqnames)} specifies the equation for which the
predictions are calculated.  Use this option to predict a statistic for a
particular equation.  Equation names, such as {cmd:equation(income)}, are used
to identify equations.

{pmore}
One equation name may be specified when predicting the dependent variable, 
the residuals, or the conditional variance.  For example, specifying
{cmd:equation(income)} causes {cmd:predict} to predict {cmd:income}, and
specifying {cmd:variance equation(income)} causes predict to predict the
conditional variance of income.

{pmore}
Two equations may be specified when predicting a conditional variance or
covariance. For example, specifying
{cmd:equation(income, consumption)} {cmd:variance} causes {cmd:predict} to
predict the conditional covariance of {cmd:income} and {cmd:consumption}.

{phang}
{opt dynamic(time_constant)} specifies when {cmd:predict} starts
producing dynamic forecasts.  The specified {it:time_constant} must be in the
scale of the time variable specified in {cmd:tsset}, and the {it:time_constant}
must be inside a sample for which observations on the dependent variables are
available.  For example, {cmd:dynamic(tq(2008q4))} causes dynamic predictions
to begin in the fourth quarter of 2008, assuming that your time variable is
quarterly; see {manhelp Datetime D}.  If the model
contains exogenous variables, they must be present for the whole predicted
sample.  {cmd:dynamic()} may not be specified with {cmd:residuals}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}linear predictions for each equation{p_end}
{synopt :{opt xb}}linear prediction for a specified equation{p_end}
{synopt :{opt v:ariance}}conditional variances and covariances{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt xb} defaults to the first equation.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions and conditional variances and covariances.  All predictions
are available as static one-step-ahead predictions or as dynamic multistep
predictions, and you can control when dynamic predictions begin.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse acme}{p_end}
{phang2}{cmd:. constraint 1 [L.ARCH]1_1  = [L.ARCH]2_2}{p_end}
{phang2}{cmd:. constraint 2 [L.GARCH]1_1 = [L.GARCH]2_2}{p_end}
{phang2}{cmd:. mgarch dvech (acme = L.acme) (anvil = L.anvil), arch(1) garch(1) constraints(1 2)}{p_end}

{pstd}Forecast conditional variances 12 weeks into the future, using dynamic
predictions beginning in the twenty-sixth week of 1998, and then graph the
forecasts{p_end}
{phang2}{cmd:. tsappend, add(12)}{p_end}
{phang2}{cmd:. predict H*, variance dynamic(tw(1998w26))}{p_end}
{phang2}{cmd:. tsline H_acme_acme H_anvil_anvil if t>=tw(1995w25), legend(rows(2))}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse aacmer, clear}{p_end}
{phang2}{cmd:. mgarch dvech (acme anvil = , noconstant), arch(1/2) garch(1) }{p_end}

{pstd}Forecast conditional variance of {cmd:acme} equation and graph the
results{p_end}
{phang2}{cmd:. predict h_acme, variance eq(acme, acme)}{p_end}
{phang2}{cmd:. tsline h_acme}{p_end}

    {hline}
