{* *! version 1.0.1  02mar2015}{...}
    {cmd:logistictail(}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative logistic distribution with mean 0 and standard deviation
                     pi/sqrt(3){p_end}

{p2col:}{cmd:logistictail(}{it:x}{cmd:)} = {cmd:logistictail(1,}{it:x}{cmd:)} = 
{cmd:logistictail(0,1,}{it:x}{cmd:)}, where {it:x} is the value of a logistic
random variable.{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}

    {cmd:logistictail(}{it:s}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative logistic distribution with mean 0, scale {it:s}, and standard deviation
                     {it:s} pi/sqrt(3){p_end}

{p2col:}{cmd:logistictail(}{it:s}{cmd:,}{it:x}{cmd:)} = {cmd:logistictail(0,}{it:s}{cmd:,}{it:x}{cmd:)},
where {it:s} is the scale and {it:x} is the value of a logistic random variable.{p_end}
{p2col: Domain {it:s}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}

    {cmd:logistictail(}{it:m}{cmd:,}{it:s}{cmd:,}{it:x}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the reverse cumulative logistic distribution with mean {it:m}, scale {it:s}, and standard deviation
                     {it:s} pi/sqrt(3){p_end}
{p2col: Domain {it:m}:}-8e+307 to 8e+307{p_end}
{p2col: Domain {it:s}:}1e-323 to 8e+307{p_end}
{p2col: Domain {it:x}:}-8e+307 to 8e+307{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
