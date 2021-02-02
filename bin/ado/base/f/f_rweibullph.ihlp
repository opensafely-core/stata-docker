{* *! version 1.0.2  17may2017}{...}
    {cmd:rweibullph(}{it:a}{cmd:,}{it:b}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}Weibull (proportional hazards) variates with shape {it:a} and scale {it:b}{p_end}

{p2col:}The variates {it:x} are generated by {it:x} = 
         {cmd:invweibullphtail(}{it:a}{cmd:,}{it:b}{cmd:,0,}{it:u}{cmd:)}, where {it:u} is a random
	 uniform(0,1) variate.{p_end}
{p2col: Domain {it:a}:}0.01 to 1e+6{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Range:}1e-323 to 8e+307{p_end}
{p2colreset}{...}

    {cmd:rweibullph(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}Weibull (proportional hazards) variates with shape {it:a}, scale {it:b}, and
        location {it:g}{p_end}

{p2col:}The variates {it:x} are generated by {it:x} = 
         {cmd:invweibullphtail(}{it:a}{cmd:,}{it:b}{cmd:,}{it:g}{cmd:,}{it:u}{cmd:)}, where {it:u} is a random
	 uniform(0,1) variate.{p_end}
{p2col: Domain {it:a}:}0.01 to 1e+6{p_end}
{p2col: Domain {it:b}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:g}:}-8e-307 to 8e+307{p_end}
{p2col: Range:}{it:g}+{cmd:c(epsdouble)} to 8e+307{p_end}
{p2colreset}{...}

