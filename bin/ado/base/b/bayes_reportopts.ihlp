{* *! version 1.0.0  10jan2017}{...}
{synopt :{opt clev:el(#)}}set credible interval level; default is {cmd:clevel(95)}{p_end}
{synopt :{opt hpd}}display HPD credible intervals instead of the default equal-tailed credible intervals{p_end}
INCLUDE help bayes_eform
{synopt :{opt batch(#)}}specify length of block for batch-means calculations;
default is {cmd:batch(0)}{p_end}
{synopt :{cmdab:sav:ing(}{help filename:{it:filename}}[{cmd:, replace}]{cmd:)}}save
simulation results to {it:filename}{cmd:.dta}{p_end}
{synopt :{opt nomodelsumm:ary}}suppress model summary{p_end}
{synopt :{opt dots}}display dots every 100 iterations and iteration numbers
every 1,000 iterations {p_end}
{synopt :{cmd:dots(}{it:#}[{cmd:,} {opt every(#)}]{cmd:)}}display dots as
simulation is performed {p_end}
{synopt :[{cmd:no}]{opth show:(bayesmh##paramref:paramref)}}specify model
parameters to be excluded from or included in the output{p_end}
{synopt :{opt notab:le}}suppress estimation table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt title(string)}}display {it:string} as title above the table of
parameter estimates{p_end}
{synopt :{help bayesmh##display_options:{it:display_options}}}control spacing,
line width, and base and empty cells{p_end}
