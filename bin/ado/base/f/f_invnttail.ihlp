{* *! version 1.1.1  02mar2015}{...}
    {cmd:invnttail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the inverse reverse cumulative (upper tail or survivor)
	noncentral Student's t distribution: if
	{cmd:nttail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:t}{cmd:)} = {it:p}, then
	{cmd:invnttail(}{it:df}{cmd:,}{it:np}{cmd:,}{it:p}{cmd:)} = {it:t}
	{p_end}
{p2col: Domain {it:df}:}1 to 1e+6 (may be nonintegral){p_end}
{p2col: Domain {it:np}:}-1,000 to 1,000{p_end}
{p2col: Domain {it:p}:}0 to 1{p_end}
{p2col: Range:}-8e+10 to 8e+10{p_end}
{p2colreset}{...}
