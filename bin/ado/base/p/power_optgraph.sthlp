{smcl}
{* *! version 1.0.12  27feb2019}{...}
{viewerdialog power "dialog power_graph"}{...}
{vieweralsosee "[PSS-2] power, graph" "mansection PSS-2 power,graph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{viewerjumpto "Syntax" "power_optgraph##syntax"}{...}
{viewerjumpto "Menu" "power_optgraph##menu"}{...}
{viewerjumpto "Description" "power_optgraph##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_optgraph##linkspdf"}{...}
{viewerjumpto "Suboptions" "power_optgraph##suboptions"}{...}
{viewerjumpto "Examples" "power_optgraph##examples"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[PSS-2] power, graph} {hline 2}}Graph results from the power
command{p_end}
{p2col:}({mansection PSS-2 power,graph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Produce default graph 

{p 8 16 2}
{opt power} ... {cmd:, graph} ...
  

{phang}
Graph power against sample size 

{p 8 16 2}
{opt power} ... {cmd:, graph(y(power) x(N))} ...


{phang}
Graph sample size against target parameter

{p 8 16 2}
{opt power} ... {cmd:, graph(y(N) x(target))} ...


{phang}
Graph effect size against sample size

{p 8 16 2}
{opt power} ... {cmd:, graph(y(delta) x(N))} ...


{phang}
Produce other custom graphs

{p 8 16 2}
[{opt power}] ... {cmd:,} {opt graph(graphopts)} ...


{marker graphopts}{...}
{synoptset 37 tabbed}{...}
{synopthdr:graphopts}
{synoptline}
{syntab:Main}
{synopt:{cmdab:y:dimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)}}use
	{it:dimlist} to define y axis{p_end}
{synopt:{cmdab:x:dimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)}}use
	{it:dimlist} to define x axis{p_end}
{synopt:{cmdab:plot:dimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)}}create
	plots for groups in {it:dimlist}{p_end}
{synopt:{cmdab:by:dimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)}}create 
	subgraphs for groups in {it:dimlist}{p_end}
{synopt:{cmdab:gr:aphdimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)}}create 
	graphs for groups in {it:dimlist}{p_end}
{synopt:{opt horiz:ontal}}swap 
	x and y axes{p_end}
{synopt:{opt schemeg:rid}}do not apply default x and y grid lines{p_end}
{synopt:{cmd:name(}{it:name}|{it:stub} [{cmd:, replace}]{cmd:)}}name 
	of graph, or {it:stub} if multiple graphs{p_end}

{syntab:Labels}
{synopt:{opt yreg:ular}}place regularly spaced ticks and labels on the y axis{p_end}
{synopt:{opt xreg:ular}}place regularly spaced ticks and labels on the x axis{p_end}
{synopt:{opt yval:ues}}place 
	ticks and labels on the y axis for each distinct value{p_end}
{synopt:{opt xval:ues}}place 
	ticks and labels on the x axis for each distinct value{p_end}
{synopt:{cmdab: collab:els(}{help power_optgraph##colspec:{it:colspec}}{cmd:)}}change 
	default labels for columns{p_end}
{synopt:{opt nolab:els}}label 
	groups with their values, not their labels{p_end}
{synopt:{opt allsim:plelabels}}forgo
	column label and equal signs in all labels{p_end}
{synopt:{opt nosim:plelabels}}include
	column label and equal signs in all labels{p_end}
{synopt:{opth eqsep:arator(strings:string)}}replace equal sign separator
	with {it:string}{p_end}
{synopt:{opth sep:arator(strings:string)}}separator
	for labels when multiple columns are specified in a dimension{p_end}
{synopt:{opt nosep:arator}}do not use a separator{p_end}
{synopt:{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}}format
	for converting numeric values to labels{p_end}

{syntab:Plot}
{synopt :{cmdab:plotop:ts(}{it:{help power_optgraph##plotopts:plot_options}}{cmd:)}}affect 
	rendition of all plots{p_end}
{synopt :{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help power_optgraph##plotopts:plot_options}}{cmd:)}}affect 
        rendition of {it:#}th plot{p_end}
{synopt:{opth recast:(twoway:plottype)}}plot
	all plots using {it:plottype}{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any 
	options documented in {manhelpi twoway_options G-3}{p_end}
{synopt :{opth byop:ts(by_option:byopts)}}how 
	subgraphs are combined, labeled, etc.{p_end}
{synoptline}

{marker dimlist}{...}
{pstd}
{it:dimlist} may contain any of the following columns:

{marker column}{...}
{synoptset 22}{...}
{synopthdr:column}
{synoptline}
{synopt:{opt alpha}}significance level{p_end}
{synopt:{opt power}}power{p_end}
{synopt:{opt beta}}type II error probability{p_end}
{synopt:{opt N}}total number of subjects{p_end}
{synopt:{opt N1}}number of subjects in the control group{p_end}
{synopt:{opt N2}}number of subjects in the experimental group{p_end}
{synopt:{opt nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt:{opt K}}number of clusters{p_end}
{synopt:{opt K1}}number of clusters in the control group{p_end}
{synopt:{opt K2}}number of clusters in the experimental group{p_end}
{synopt:{opt kratio}}ratio of numbers of clusters, experimental to control{p_end}
{synopt:{opt M}}cluster size{p_end}
{synopt:{opt M1}}cluster size in the control group{p_end}
{synopt:{opt M2}}cluster size in the experimental group{p_end}
{synopt:{opt mratio}}ratio of cluster sizes, experimental to control{p_end}
{synopt:{opt delta}}effect size{p_end}
{synopt:{opt target}}target parameter{p_end}
{synopt:{it:method_columns}}columns specific to the
         {help power##method:method} specified with {cmd:power}{p_end}
{synoptline}

{marker colspec}{...}
{pstd}
{it:colspec} is 

{p 8 16 2}
{help power_optgraph##column:{it:column}} {cmd:"}{it:label}{cmd:"} [{it:column} {cmd:"}{it:label}{cmd:"} [...]]

{marker dimopts}{...}
{synopthdr:dimopts}
{synoptline}
{synopt:{opt lab:els(lablist)}}list
	of quoted strings to label each level of the dimension{p_end}
{synopt:{opt elab:els(elablist)}}list of
	enumerated labels{p_end}
{synopt:{opt nolab:els}}label 
	groups with their values, not their labels{p_end}
{synopt:{opt allsim:plelabels}}forgo
	column name and equal signs in all labels{p_end}
{synopt:{opt nosim:plelabels}}include
	column name and equal signs in all labels{p_end}
{synopt:{opth eqsep:arator(strings:string)}}replace equal sign separator
	with {it:string} in the dimension{p_end}
{synopt:{opth sep:arator(strings:string)}}separator
	for labels when multiple columns are specified in the dimension{p_end}
{synopt:{opt nosep:arator}}do 
	not use a separator{p_end}
{synopt:{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}}format
	for converting numeric values to labels{p_end}
{synoptline}

{pstd}
where {it:lablist} is defined as

{p 8 16 2}
{cmd:"}{it:label}{cmd:"} [{cmd:"}{it:label}{cmd:"} [...]]

{pstd}
{it:elablist} is defined as

{p 8 16 2}
{it:#} {cmd:"}{it:label}{cmd:"} [{it:#} {cmd:"}{it:label}{cmd:"} [...]]

{pstd}
and the {it:#}s are the levels of the dimension.

{marker plotopts}{...}
{synopthdr:plot_options}
{synoptline}
INCLUDE help gr_markopt2
INCLUDE help gr_clopt
{synoptline}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
The {cmd:graph()} option of {helpb power} specifies that results of the
{cmd:power} command be graphed.

{pstd}
While there are many options for controlling the look of the graph, you will
often merely need to specify the {cmd:graph} option with your {cmd:power}
command.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 power,graphRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker suboptions}{...}
{title:Suboptions}

{pstd}
The following are suboptions within the {cmd:graph()} option of the 
{cmd:power} command.

{dlgtab:Main}

{phang}
{opt ydimension()}, {opt xdimension()}, {opt plotdimension()}, 
        {opt bydimension()}, and {opt graphdimension()} specify the dimension
        to be used for the graph's y axis, x axis, plots, {cmd:by()}
        subgraphs, and graphs.

{pmore}
        The default dimensions are based on your analysis.  The y dimension
        is power for power determination, sample size for sample-size
        determination, and target parameter for effect-size determination.  If
        there is only one column containing multiple values, this column is
        plotted on the x dimension.  Otherwise, the x dimension is sample
        size for power determination, target parameter for sample-size
        determination, and sample size for effect-size determination.  Other
        columns that contain multiple values are used as plot dimensions.
        See {mansection PSS-2 power,graphRemarksandexamplesDefaultgraphs:{it:Default graphs}}
	in {bf:[PSS-2] power, graph} for details.
        You may override the defaults and explicitly control which columns are
        used on each dimension of the graph using these dimension suboptions.

{pmore}
        Each of these suboptions supports 
        {help power_optgraph##dimopts:suboptions} that control the labeling of
        the dimension -- axis labels for {opt ydimension()} and 
        {opt xdimension()}, plot labels for {opt plotdimension()}, subgraph
        titles for {opt bydimension()}, and graph titles for 
	{opt graphdimension()}.

{pmore}
	For examples using the dimension suboptions, see
	{mansection PSS-2 power,graphRemarksandexamplesChangingdefaultgraphdimensions:{it:Changing default graph dimensions}}
	in {bf:[PSS-2] power, graph}.

{phang2}
{cmd:ydimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)} specifies
        the columns for the y axis in {it:dimlist} and controls the
        content of those labels with {it:dimopts}.

{phang2}
{cmd:xdimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)} specifies
        the columns for the x axis in {it:dimlist} and controls the
        content of those labels with {it:dimopts}.

{phang2}
{cmd:plotdimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)} specifies
	in {it:dimlist} the columns whose levels determine the plots
	and optionally specifies in {it:dimopts} the content of the plots'
	labels.

{phang2}
{cmd:bydimension(}{help power_optgraph##dimlist:{it:dimlist}} [{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)} specifies
        in {it:dimlist} the columns whose levels determine the
        {cmd:by()} subgraphs and optionally specifies in {it:dimopts} the
        content of the subgraphs' titles.

{phang2}
{cmd:graphdimension(}{help power_optgraph##dimlist:{it:dimlist}}
[{cmd:,} {help power_optgraph##dimopts:{it:dimopts}}]{cmd:)} specifies in
{it:dimlist} the columns whose levels determine the graphs and
optionally specifies in {it:dimopts} the content of the graphs' titles.

{pmore}
See the definition of {it:{help pss_glossary##def_columns:columns in graph}} in 
{bf:[PSS-5] Glossary}.

{phang}
{opt horizontal} reverses the default x and y axes.  By default, the values
        computed by {helpb power} are plotted on the y axis, and the x axis
        represents one of the other columns.  Specifying 
	{opt horizontal} swaps the axes.
	
{pmore}
        One common use is to put sample size on the x axis even when it is the
        value computed by {cmd:power}.  This suboption can also be useful with
        the long labels produced when the {cmd:parallel} option is specified
	with {cmd:power}.

{pmore}
        See {mansection PSS-2 power,graphRemarksandexamplesParallelplots:{it:Parallel plots}}
	in {bf:[PSS-2] power, graph} for an example of the {cmd:horizontal}
	suboption.

{phang}
{opt schemegrid} specifies that x and y grid lines not always be drawn on the
	{cmd:power} graph.  Instead, whether grid lines are drawn will be
	determined by the current {help scheme}.

{phang}
{cmd:name(}{it:name}|{it:stub} [{cmd:, replace}]{cmd:)} specifies the
        name of the graph or graphs.  If the {cmd:graphdimension()} suboption
        is specified, then the argument of {opt name()} is taken to be
        {it:stub}, and graphs named {it:stub}{cmd:1}, {it:stub}{cmd:2}, ... are
        created.

{pmore} 
        {opt replace} specifies that existing graphs of the same name may be
        replaced.

{pmore}
        If {cmd:name()} is not specified, default names are used, and the graphs
        may be replaced by subsequent {cmd:power} graphs or other graphing
        commands.

{dlgtab:Labels}
	
{pstd}
All the suboptions listed under the {bf:Labels} tab may be specified 
directly within the {cmd:graph()} option.  All of them except
{cmd:yregular}, {cmd:xregular}, {cmd:yvalues}, and {cmd:xvalues} 
may be specified as {it:dimopts} within
{cmd:ydimension()}, {cmd:xdimension()}, {cmd:plotdimension()},
{cmd:bydimension()}, and {cmd:graphdimension()}.  
When suboptions are specified in one of the dimension options, only the labels
for that dimension are affected.  When suboptions are specified outside the
dimension options, all labels on all dimensions are affected.  Specifications
within the dimension options take precedence.

{phang}
{opt yregular} and {opt yvalues} specify how tick marks and labels are to be
	placed on the y axis.  

{phang2}
{opt yregular} specifies that regularly spaced ticks and labels be placed on
	the y axis.

{phang2}
{opt yvalues} specifies that a tick and label be placed for each distinct
value.

{pmore}
If neither is specified, an attempt is made to choose the most reasonable
option based on your results.  Labeling may also be specified using the
standard {cmd:graph twoway}
{help axis label options:axis labeling rules and options}.

{phang}
{opt xregular} and {opt xvalues} do the same for tick marks and labels to be
	placed on the x axis.

{phang}
{cmd:collabels(}{help power_optgraph##colspec:{it:colspec}}{cmd:)} specifies 
        labels to be used on the graph for the specified columns.  For
        example, {cmd:collabels(N "N")} specifies that wherever the column
        {cmd:N} is used on a graph -- axis label, plot label, graph title,
        legend title, etc. -- "N" be shown rather than the default label
        "Sample size".

{pmore}
	Multiple columns may be relabeled by typing, for example,

{pmore2}
	{cmd:collabels(N "N" ma "Alternative mean")}

{pmore}
        and {help graph_text:SMCL} tags for Greek characters and other
	typesetting can be used by typing, for example,

{pmore2}
	{cmd:collabels(alpha "{&alpha}" ma "{&mu}{sub:a}")}

{pmore}
See the definition of {it:{help pss_glossary##def_columns:columns in graph}} in 
{bf:[PSS-5] Glossary}.

{phang}
{opt nolabels} specifies that value labels not be used to construct graph
        labels and titles for the levels in the dimension.  By default, if a
        column in a dimension has value labels, those labels are used to
        construct labels and titles for axis ticks, plots, subgraphs, and
        graphs.

{phang}
{opt allsimplelabels} and {opt nosimplelabels}
        control whether a graph's labels and titles include just the values of
        the columns or also include column labels and equal signs.  The
        default depends on whether the dimension is an axis dimension or one
        of the plot, by, and graph dimensions.  It also depends on whether the
        values for the level of the dimension are labeled.  An example of a
        simple label is "alpha" or ".05" and of a nonsimple label is
        "alpha=.05".

{pmore}
        In {cmd:power, graph} simple labels are almost universally best for
	x and y axes and also best for most plot labels.  Labels with an
	equal sign are typically preferred for subgraph and graph titles.
	These are the defaults used by {cmd:power, graph}.  The
	{opt allsimplelabels} and
        {opt nosimplelabels} suboptions let you override the default labeling.

{phang2}
{opt allsimplelabels}
	specifies that all titles and labels use just the value or value label
	of the column.

{phang2}
{opt nosimplelabels}
	specifies that all titles and labels include {it:dimname}{cmd:=} before
        the value or value label.

{phang}
{opth eqseparator:(strings:string)} specifies a custom separator between
        column labels and values in labels.  Use {it:string} in place of the
        default equal sign.  This option is for use with {opt nosimplelabels}.

{phang}
{opth separator:(strings:string)} and {opt noseparator} control the separator
       between label sections when more than one column is used to specify a
       dimension.  The default separator is a comma followed by a space, but
       no separator may be requested with {opt noseparator}, or the default
       may be changed to any string with {opt separator()}.

{pmore} 
        For example, if {cmd:bydimension(a b)} is specified, the subgraph
        labels in our graph legend might be "a=1, b=1", "a=1, b=2", ....
        Specifying {cmd:separator(:)} would create labels "a=1:b=1",
        "a=1:b=2", ....

{phang}
{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}
    specifies how numeric values are to be formatted for display as axis
    labels, labels on plots, and titles on subgraphs and graphs.

{dlgtab:Plot}

{phang}
{cmd:plotopts(}{it:{help power_optgraph##plotopts:plot_options}}{cmd:)}
        affects the rendition of all plots.  The {it:plot_options} can
        affect the size and color of markers, whether and how the markers are
        labeled, and whether and how the points are connected; 
        see {manhelpi marker_options G-3}, 
        {manhelpi marker_label_options G-3}, and {manhelpi cline_options G-3}.

{pmore} 
        These settings may be overridden for specific plots by using the
        {cmd:plot}{it:#}{cmd:opts()} suboption.

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:{help power_optgraph##plotopts:plot_options}}{cmd:)}
        affects the rendition of the {it:#}th plot.  The
        {it:plot_options} can affect the size and color of markers, whether
        and how the markers are labeled, and whether and how the points are
        connected; see {manhelpi marker_options G-3}, 
        {manhelpi marker_label_options G-3}, and {manhelpi cline_options G-3}.

{phang}
{opt recast(plottype)}
	specifies that results be plotted using {it:plottype}.  
        {it:plottype} may be {cmd:scatter}, {cmd:line}, {cmd:connected},
        {cmd:area}, {cmd:bar}, {cmd:spike}, {cmd:dropline}, or {cmd:dot}; see
	{manhelp graph_twoway G-2:graph twoway}.  When {cmd:recast()} is
	specified, the plot-rendition options appropriate to the specified
        {it:plottype} may be used in lieu of
	{it:{help power_optgraph##plotopts:plot_options}}.
	For details on those
        suboptions, follow the appropriate link from
        {manhelp graph_twoway G-2:graph twoway}.

{pmore} 
	You may specify {cmd:recast()} within a {cmd:plotopts()} or
        {cmd:plot}{it:#}{cmd:opts()} suboption.  It is better, however, to
        specify it as documented here, outside those suboptions.  When
	it is specified outside those suboptions, you have greater access to
	the plot-specific rendition suboptions of your specified
	{it:plottype}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} 
        provides a way to add other plots to the generated graph; see
        {manhelpi addplot_option G-3}.  

{pmore}
        If multiple graphs are drawn by a single {cmd:power} command or
        if {it:plot} specifies plots with multiple y variables, for example,
        {cmd:scatter y1 y2 x}, then the graph's legend will not clearly identify
	all the plots and will require customization using the 
	{opt legend()} suboption; see {manhelpi legend_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} 
        are any of the options documented in {manhelpi twoway_options G-3}.
        These include options for 
	titling the graph (see {manhelpi title_options G-3}); 
	for saving the graph to disk (see {manhelpi saving_option G-3});
	for controlling the labeling and look of the axes
	(see {manhelpi axis_options G-3});
	for controlling the look, contents, position, 
	and organization of the legend (see {manhelpi legend_options G-3});
	for adding lines (see {manhelpi added_line_options G-3})
	and text (see {manhelpi added_text_options G-3});
	and for controlling other aspects of the graph's appearance
	(see {manhelpi twoway_options G-3}).

{pmore}
        The {cmd:label()} suboption of the {cmd:legend()} option has no
        effect on {cmd:power, graph}.  Use the {cmd:order()} suboption instead.

{phang}
{opt byopts(byopts)} 
        affects the appearance of the combined graph when {cmd:bydimension()}
        is specified or when the default graph has subgraphs, including the
        overall graph title, the position of the legend, and the organization
        of subgraphs.  See {manhelpi by_option G-3}.


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:power, graph} and examples with discussion, see
{it:{mansection PSS-2 power,graphRemarksandexamples:Remarks and examples}} in
{bf:[PSS-2] power, graph}.

{pstd}
Display results in a graph{p_end}
{phang2}{cmd:. power onemean 0 1, n(10 20 30 50) graph}{p_end}
{phang2}{cmd:. power onemean 0 (1(0.5)5), n(20 30) graph}

{pstd}
Changing graph axes, here displaying type II error probability (beta)
on the y axis{p_end}
{phang2}{cmd:. power onemean 0 1, n(10 20 30 50 75 100) graph(y(beta))}

{pstd}
Vary more than two parameters{p_end}
{phang2}{cmd:. power onemean 0 (1 2), n(10 20 30 50) sd(1 1.5) graph}

{pstd}
Same as above, producing separate graphs for each level of the alternative
hypothesis{p_end}
{phang2}{cmd:. power onemean 0 (1 2), n(10 20 30 50) sd(1 1.5) graph(by(ma))}
{p_end}
