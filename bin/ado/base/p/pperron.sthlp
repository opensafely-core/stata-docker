{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog pperron "dialog pperron"}{...}
{vieweralsosee "[TS] pperron" "mansection TS pperron"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfgls" "help dfgls"}{...}
{vieweralsosee "[TS] dfuller" "help dfuller"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[XT] xtunitroot" "help xtunitroot"}{...}
{viewerjumpto "Syntax" "pperron##syntax"}{...}
{viewerjumpto "Menu" "pperron##menu"}{...}
{viewerjumpto "Description" "pperron##description"}{...}
{viewerjumpto "Links to PDF documentation" "pperron##linkspdf"}{...}
{viewerjumpto "Options" "pperron##options"}{...}
{viewerjumpto "Examples" "pperron##examples"}{...}
{viewerjumpto "Stored results" "pperron##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] pperron} {hline 2}}Phillips-Perron unit-root test{p_end}
{p2col:}({mansection TS pperron:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:pperron}
{varname}
{ifin}
[{cmd:,} {it:options}]

{synoptset 14 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt nocons:tant}}suppress constant term {p_end}
{synopt:{opt tr:end}}include trend term in regression {p_end}
{synopt:{opt reg:ress}}display regression table {p_end}
{synopt:{opt l:ags(#)}}use {it:#} Newey-West lags{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt pperron}; see
{helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Tests > Phillips-Perron unit-root test}


{marker description}{...}
{title:Description}

{pstd}
{opt pperron} performs the Phillips-Perron test that a variable has a unit
root.  The null hypothesis is that the variable contains a unit root, and the
alternative is that the variable was generated by a stationary process.
{opt pperron} uses Newey-West standard errors to account for serial
correlation, whereas the augmented Dickey-Fuller test implemented in
{helpb dfuller} uses additional lags of the first-differenced variable.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS pperronQuickstart:Quick start}

        {mansection TS pperronRemarksandexamples:Remarks and examples}

        {mansection TS pperronMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt noconstant} suppresses the constant term (intercept) in the model.

{phang}
{opt trend} specifies that a trend term be included in the associated
    regression.  This option may not be specified if {opt noconstant} is
    specified.

{phang}
{opt regress} specifies that the associated regression table appear
    in the output.  By default, the regression table is not produced.

{phang}
{opt lags(#)} specifies the number of Newey-West lags to
    use in calculating the standard error.  The default is to use
    int{4(T/100)^(2/9)} lags.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse air2}

{pstd}Test that air has a unit root{p_end}
{phang2}{cmd:. pperron air}

{pstd}Same as above, but use four Newey-West lags to calculate standard
error{p_end}
{phang2}{cmd:. pperron air, lags(4)}

{pstd}Same as above, but include a trend term in the associated
regression{p_end}
{phang2}{cmd:. pperron air, lags(4) trend}

{pstd}Same as above, but show associated regression table in output{p_end}
{phang2}{cmd:. pperron air, lags(4) trend regress}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pperron} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(lags)}}number of lagged differences used{p_end}
{synopt:{cmd:r(pval)}}MacKinnon approximate p-value (not included if
{cmd:noconstant} specified){p_end}
{synopt:{cmd:r(Zt)}}Phillips-Perron tau test statistic{p_end}
{synopt:{cmd:r(Zrho)}}Phillips-Perron rho test statistic{p_end}
{p2colreset}{...}