{smcl}
{* *! version 2.0.6  15may2018}{...}
{vieweralsosee "ssc describe listsome" "net describe http://fmwww.bc.edu/repec/bocode/l/listsome"}{...}
{vieweralsosee "ssc describe randomtag" "net describe http://fmwww.bc.edu/repec/bocode/r/randomtag"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Data types" "help data types"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{vieweralsosee "[D] encode" "help encode"}{...}
{vieweralsosee "[D] input" "help input"}{...}
{vieweralsosee "[D] label" "help label"}{...}
{vieweralsosee "[D] list" "help list"}{...}
{viewerjumpto "Attribution" "dataex##attribution"}{...}
{viewerjumpto "Syntax" "dataex##syntax"}{...}
{viewerjumpto "Description" "dataex##description"}{...}
{viewerjumpto "Remarks" "dataex##remarks"}{...}
{viewerjumpto "Options" "dataex##options"}{...}
{viewerjumpto "Examples" "dataex##examples"}{...}
{viewerjumpto "Acknowledgments" "dataex##acknowledgments"}{...}
{viewerjumpto "Authors" "dataex##authors"}{...}
{viewerjumpto "Also see" "dataex##alsosee"}{...}
{title:Title}

{phang}
{cmd:dataex} {hline 2} Generate a properly formatted data example for Statalist


{marker attribution}{...}
{title:Attribution}

{pstd}
{cmd:dataex} is community-contributed software.  It is written and
maintained by its {help dataex##authors:authors}, Robert Picard and
Nicholas J. Cox.  It is installed with official Stata
for the convenience of users posting on online forums such as
{help statalist:Statalist}.  It is also available in identical form
from the Statistical Software Components (SSC) archive
(see {helpb ssc:help ssc}).


{marker syntax}{...}
{title:Syntax}

	{cmd:dataex} [{varlist}] {ifin} [, {opt v:arlabel} {opt e:lsewhere} {opt c:ount(#)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:dataex} is for producing a data example to include in a post on
Statalist.  Make sure that you have read the
{browse "http://www.statalist.org/forums/help":FAQ}
before posting.  Users who read your post will be able to copy the code
generated by {cmd:dataex} and re-create the dataset shown.

{pstd}
The {helpb input} command is used to enter the data into Stata
variables of the same type as the original variables in memory.
All numeric {help datetime} variables
will be correctly formatted, and all numeric variables with
associated value {help labels} will also be re-created.
If the {opt varlabel} option is specified, the results will include
commands to regenerate all variable labels.

{pstd}
Copy what is
produced by {cmd:dataex} in the Stata Results window
to your post on Statalist.  Make sure to include the {bf:[CODE]}
and {bf:[/CODE]} lines.  You can use the {bf:Preview} button,
just to the left of the {bf:Post Reply} button, to verify within
Statalist that the data example is correctly formatted.


{marker remarks}{...}
{title:Remarks}

{pstd}
The output produced by {cmd:dataex} may also be useful outside Statalist
in other forums, or even privately, say, in communicating with StataCorp
technical support.  In other forums or privately, the {bf:[CODE]} and
{bf:[/CODE]} lines will not be useful and may be omitted.  As a
convenience, the option {opt elsewhere} may be used to suppress display
of such lines.

{pstd}
General advice on posting example data includes the following:

{phang2}
1.  It should be evident that
readers can understand your dataset only to the extent that you explain
it clearly.  A detailed verbal explanation is likely to be too long to
read and too hard for readers to absorb.  So, use examples!

{phang2}
2.  Aim for a
{browse "http://stackoverflow.com/help/mcve":minimal, complete, and verifiable example}.

{phang2}
3.  The word "minimal" underlines that small examples (say, 5 to 10
observations) may be quite sufficient to explain your data structure,
variable types, and names.  It is also true that your example
should be "complete" enough to make your question clear.  By providing
data that you have used, you make your question "verifiable",
too.

{phang2}
4.  Even if you use a mutually accessible dataset (say, one read in with
{helpb sysuse} or {helpb webuse}), providing code that others can run
quickly will be very helpful.

{pstd}
{cmd:dataex} is not offered as a "one size fits all" solution to
providing example data.  Depending on your problem, explaining other
facts about your dataset may be crucial, say, on its size, what you have
{helpb tsset} or {helpb xtset}, and so forth.


{marker options}{...}
{title:Options}

{phang}{opt varlabel} specifies that commands to produce
variable labels are also to be shown.

{phang}{opt elsewhere} indicates that your example is for use
somewhere other than Statalist.  Display of {bf:CODE} delimiters
intended for Statalist will therefore be suppressed.

{phang}{opt count(#)} specifies a limit to the number of observations listed.
The default is {cmd:count(100)}.


{marker examples}{...}
{title:Examples}

{pstd}
Prepare a small example from the standard auto dataset.

        {cmd:.} {stata sysuse auto}
        {cmd:.} {stata dataex make price mpg rep78 in 1/5}

{pstd}
You present the variables in the order you want.  If some variables
have value labels, the results will include commands to re-create
them.

        {cmd:.} {stata dataex make rep78 price foreign if rep78 == 5}

{pstd}
You can use the {opt varlabel} option to include
commands to regenerate variable labels.

        {cmd:.} {stata dataex make rep78 price foreign if rep78 == 5, var}
        
{pstd}
Numeric {help datetime} variables will also be correctly formatted.
In the following example, the daily date variable {bf:date} is regenerated
using Stata's internal numeric values and then formatted using the
{bf:%td} format.  The next example shows a quarterly date variable.

        {cmd:.} {stata sysuse sp500}
        {cmd:.} {stata dataex in 1/5}
        
        {cmd:.} {stata sysuse gnp96}
        {cmd:.} {stata dataex in 1/5}
        
{pstd}
If the dataset is large, consider choosing a random sample.  The
following example uses {stata "ssc des randomtag":{bf:randomtag}} (from SSC) to select 10
random observations.

        {cmd:.} {stata ssc install randomtag}
        {cmd:.} {stata sysuse icd9_cod.dta, clear}
        {cmd:.} {stata randomtag if length(__code9) == 4, count(10) gen(pick)}
        {cmd:.} {stata dataex __code9 __desc9 if pick}


{marker acknowledgments}{...}
{title:Acknowledgments}

{pstd}
Many thanks to William Lisowski for his observation that
some users may inadvertently trigger a large data dump and
for his thoughtful suggestions on how to handle the issue.


{marker authors}{...}
{title:Authors}

{pstd}Robert Picard{p_end}
{pstd}picard@netbox.com{p_end}

{pstd}Nicholas J. Cox, Durham University, UK{p_end}
{pstd}n.j.cox@durham.ac.uk{p_end}


{marker alsosee}{...}
{title:Also see}

{psee}
SSC:  
{stata "ssc des listsome":{bf:listsome}},
{stata "ssc des randomtag":{bf:randomtag}}
{p_end}

{psee}
Help:  
{manhelp input D:input}, 
{manhelp data_types D:Data types}, 
{manhelp Datetime D},  
{manhelp label D},  
{manhelp encode D},
{manhelp list D}
{p_end}