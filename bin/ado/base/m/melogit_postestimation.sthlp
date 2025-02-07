{smcl}
{* *! version 1.3.3  19oct2017}{...}
{viewerdialog predict "dialog melogit_p"}{...}
{viewerdialog estat "dialog melogit_estat"}{...}
{vieweralsosee "[ME] melogit postestimation" "mansection ME melogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meglm postestimation" "help meglm postestimation"}{...}
{viewerjumpto "Postestimation commands" "melogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "melogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "melogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "melogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "melogit postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[ME] melogit postestimation} {hline 2}}Postestimation tools for
melogit{p_end}
{p2col:}({mansection ME melogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:melogit}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb estat icc}}estimate
intraclass correlations{p_end}
{synopt :{helpb me estat sd:estat sd}}display variance components as standard deviations and correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb melogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb melogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME melogitpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME melogitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_me_predict

INCLUDE help syntax_me_predict_stats

{marker options_table}{...}
{synoptset 25 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help melogit_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}

{syntab :Integration}
{synopt :{it:{help melogit_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
{cmd:pearson},
{cmd:deviance},
{cmd:anscombe}
may not be combined with {cmd:marginal}.
{p_end}

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
mean responses; linear predictions; density and distribution functions;
standard errors; and Pearson, deviance, and Anscombe residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:mu}, the default, calculates the predicted mean, that is, the
probability of a positive outcome.

INCLUDE help syntax_me_predict_desc


INCLUDE help syntax_margins

INCLUDE help syntax_me_margins_stats

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
mean responses and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}
{phang2}{cmd:. melogit dtlm difficulty i.group || family: || subject:}
{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_urban re_cons, reffects}{p_end}

{pstd}Predicted probabilities, incorporating random effects{p_end}
{phang2}{cmd:. predict p}{p_end}

{pstd}Predicted probabilities, ignoring subject and family effects{p_end}
{phang2}{cmd:. predict p_fixed, conditional(fixedonly)}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}
