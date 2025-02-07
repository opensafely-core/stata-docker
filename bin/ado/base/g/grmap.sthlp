{smcl}
{* *! version 1.0.10  16apr2019}{...}
{vieweralsosee "[SP] grmap" "mansection SP grmap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spcompress" "help spcompress"}{...}
{viewerjumpto "Attribution" "grmap##attribution"}{...}
{viewerjumpto "Syntax" "grmap##syntax"}{...}
{viewerjumpto "Menu" "grmap##menu"}{...}
{viewerjumpto "Description" "grmap##desc"}{...}
{viewerjumpto "Options" "grmap##options"}{...}
{viewerjumpto "Examples" "grmap##examples"}{...}
{viewerjumpto "References" "grmap##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[SP] grmap} {hline 2}}Visualization of spatial data{p_end}
{p2col:}({mansection SP grmap:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker attribution}{...}
{title:Attribution}

{pstd}
{cmd:grmap} is community-contributed software.
It is adapted from Pisati's {help grmap##P2007:(2007)} {cmd:spmap} command,
which was preceded by his {cmd:tmap} command ({help grmap##P2004:Pisati 2004}).
To use {cmd:grmap}, activate it by clicking on or typing
{bf:{stata grmap, activate}}.


{marker syntax}{...}
{title:Syntax}

{phang}Basic syntax

{p 8 15 2}
{cmd:grmap} [{help grmap##choromap:{it:attribute}}] {ifin}
[{cmd:,}
{it:{help grmap##basemap1:basemap_options}}
{it:{help grmap##supplots:supplots}}]


{phang}Panel data syntax

{p 8 15 2}
{cmd:grmap} [{help grmap##choromap:{it:attribute}}] {ifin}{cmd:,}
{opt t(#)}
[{it:{help grmap##basemap1:basemap_options}}
{it:{help grmap##supplots:supplots}}]


{synoptset 35}{...}
{synopthdr:{help grmap##panel2:panel_data_option}{col 41}}
{synoptline}
{synopt :{opt t(#)}}select time {it:#} for panel data{p_end}
{synoptline}

{synoptset 35 tabbed}{...}
{marker basemap1}{synopthdr:{help grmap##basemap2:basemap_options}{col 41}}
{synoptline}
{syntab: Cartogram}
{synopt :{cmdab:a:rea(}{help varname:{it:areavar}}{cmd:)}}draw base map
   polygons with area proportional to variable {it:areavar}{p_end}
{synopt :{opt split}}split multipart base map polygons{p_end}
{synopt :{cmdab:m:ap(}{help grmap##spatdata:{it:backgroundmap}}{cmd:)}}draw
   background map defined in Stata dataset {it:backgroundmap}{p_end}
{synopt :{opth mfc:olor(colorstyle)}}fill color of the
   background map{p_end}
{synopt :{opth moc:olor(colorstyle)}}outline color of the
   background map{p_end}
{synopt :{opth mos:ize(linewidthstyle)}}outline thickness of the
   background map{p_end}
{synopt :{opth mop:attern(linepatternstyle)}}outline pattern of the
   background map{p_end}
{synopt :{opth moa:lign(linealignmentstyle)}}outline alignment (inside,
   outside, center) of the background map{p_end}

{syntab: Choropleth map}
{synopt :{opt clm:ethod(method)}}{it:attribute} classification method, where
   {it:method} is one of the following: {cmdab:q:uantile}, {cmdab:b:oxplot},
   {cmdab:e:qint}, {cmdab:s:tdev}, {cmdab:k:means}, {cmdab:c:ustom},
   {cmdab:u:nique}{p_end}
{synopt :{opt cln:umber(#)}}number of classes{p_end}
{synopt :{opth clb:reaks(numlist)}}custom class breaks{p_end}
{synopt :{opt eir:ange(min max)}}{it:attribute} range for {cmd:eqint}
   classification method{p_end}
{synopt :{opt kmi:ter(#)}}number of iterations for {cmd:kmeans}
   classification method{p_end}
{synopt :{opth ndf:color(colorstyle)}}fill color of empty (no data)
   base map polygons{p_end}
{synopt :{opth ndo:color(colorstyle)}}outline color of empty (no data)
   base map polygons{p_end}
{synopt :{opth nds:ize(linewidthstyle)}}outline thickness of empty
   (no data) base map polygons{p_end}
{synopt :{opth ndp:attern(linepatternstyle)}}outline pattern of empty
   (no data) base map polygons{p_end}
{synopt :{opth nda:lign(linealignmentstyle)}}outline alignment (inside,
   outside, center) of empty (no data) base map polygons{p_end}
{synopt :{opt ndl:abel(string)}}legend label of empty (no data)
   base map polygons{p_end}

{syntab: Format}
{synopt :{cmdab:fc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}fill color
   of base map polygons{p_end}
{synopt :{cmdab:oc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}outline
   color of base map polygons{p_end}
{synopt :{cmdab:os:ize(}{it:{help linewidthstyle}_list}{cmd:)}}outline
   thickness of base map polygons{p_end}
{synopt :{cmdab:op:attern(}{it:{help linepatternstyle}_list}{cmd:)}}outline
   pattern of base map polygons{p_end}
{synopt :{cmdab:oa:lign(}{it:{help linealignmentstyle}_list}{cmd:)}}outline
   alignment (inside, outside, center) of base map polygons{p_end}

{syntab: Legend}
{synopt :{cmdab:legenda(on}|{cmd:off)}}display/hide base map legend{p_end}
{synopt :{opt legt:itle(string)}}base map legend title{p_end}
{synopt :{opt legl:abel(string)}}single-key base map legend label{p_end}
{synopt :{cmdab:lego:rder(hilo}|{cmd:lohi)}}base map legend order{p_end}
{synopt :{cmdab:legs:tyle(0}|{cmd:1}|{cmd:2}|{cmd:3)}}base map legend
   style{p_end}
{synopt :{opt legj:unction(string)}}string connecting lower- and upper-class
   limits in base map legend labels when {cmd:legstyle(2)}{p_end}
{synopt :{opt legc:ount}}display number of base map polygons belonging
   to each class{p_end}

{syntab: Miscellaneous}
{synopt :{opt polyfirst}}draw supplementary polygons before the base
   map{p_end}
{synopt :{opt gs:ize(#)}}length of shortest side of {it:available area}
   (in inches){p_end}
{synopt :{opt free:style}}ignore built-in graph formatting presets and
   restrictions{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any 
options documented in {manhelpi twoway_options G-3}, except for
   {cmd:aspectratio()}, {cmd:scheme()}, {cmd:by()}, and
   {it:advanced_options}{p_end}
{synoptline}

{synoptset 35 tabbed}{...}
{marker supplots}{synopthdr:supplots}
{synoptline}
{syntab: Supplementary map data}
{synopt :{cmdab:pol:ygon(}{help grmap##polygon1:{it:polygon_suboptions}}{cmd:)}}add {it:{help grmap##sd_polygon:polygons}} from a supplementary dataset{p_end}
{synopt :{cmdab:lin:e(}{help grmap##line1:{it:line_suboptions}}{cmd:)}}add {it:{help grmap##sd_line:lines}} from a supplementary dataset{p_end}
{synopt :{cmdab:poi:nt(}{help grmap##point1:{it:point_suboptions}}{cmd:)}}add {it:{help grmap##sd_point:points}} from a supplementary dataset{p_end}
{synopt :{cmdab:dia:gram(}{help grmap##diagram1:{it:diagram_suboptions}}{cmd:)}}add {it:{help grmap##sd_diagram:diagrams}} from a supplementary dataset{p_end}
{synopt :{cmdab:arr:ow(}{help grmap##arrow1:{it:arrow_suboptions}}{cmd:)}}add {it:{help grmap##sd_arrow:arrows}} from a supplementary dataset{p_end}
{synopt :{cmdab:lab:el(}{help grmap##label1:{it:label_suboptions}}{cmd:)}}add {it:{help grmap##sd_label:labels}} from a supplementary dataset{p_end}
{synopt :{cmdab:sca:lebar(}{help grmap##scalebar1:{it:scalebar_suboptions}}{cmd:)}}add {it:scalebar}{p_end}
{synoptline}

{synoptset 35 tabbed}{...}
{marker polygon1}{synopthdr:{help grmap##polygon2:polygon_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{p2coldent :* {cmdab:d:ata(}{help grmap##spatdata:{it:polygon}{bf:.dta}}{cmd:)}}Stata
   dataset defining one or more supplementary polygons to be superimposed onto
   the base map{p_end}
{synopt :{cmdab:s:elect(}{help drop:{it:command}}{cmd:)}}keep/drop
  specified records of dataset {it:polygon}{p_end}
{synopt :{cmdab:by(}{help varname:{it:byvar_pl}}{cmd:)}}group supplementary
  polygons by variable {it:byvar_pl}{p_end}

{syntab: Format}
{synopt :{cmdab:fc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}fill color
   of supplementary polygons{p_end}
{synopt :{cmdab:oc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}outline color
   of supplementary polygons{p_end}
{synopt :{cmdab:os:ize(}{it:{help linewidthstyle}_list}{cmd:)}}outline thickness
   of supplementary polygons{p_end}
{synopt :{cmdab:op:attern(}{it:{help linepatternstyle}_list}{cmd:)}}outline
   pattern of supplementary polygons{p_end}
{synopt :{cmdab:oa:lign(}{it:{help linealignmentstyle}_list}{cmd:)}}outline
   alignment (inside, outside, center) of supplementary polygons{p_end}

{syntab: Legend}
{synopt :{cmdab:legenda(on}|{cmd:off)}}display/hide supplementary-polygon
   legend{p_end}
{synopt :{opt legt:itle(string)}}supplementary-polygon legend title{p_end}
{synopt :{opt legl:abel(string)}}single-key supplementary-polygon legend
   label{p_end}
{synopt :{opth legs:how(numlist)}}display only selected keys of
   supplementary-polygon legend{p_end}
{synopt :{opt legc:ount}}display number of supplementary polygons belonging
   to each group{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:polygon()} is specified{p_end}

{synoptset 35 tabbed}{...}
{marker line1}{synopthdr:{help grmap##line2:line_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{p2coldent :* {cmdab:d:ata(}{help grmap##spatdata:{it:line}{bf:.dta}}{cmd:)}}Stata
   dataset defining one or more polylines to be superimposed onto the
   base map{p_end}
{synopt :{cmdab:s:elect(}{help drop:{it:command}}{cmd:)}}keep/drop
   specified records of dataset {it:line}{p_end}
{synopt :{cmdab:by(}{help varname:{it:byvar_ln}}{cmd:)}}group polylines
   by variable {it:byvar_ln}{p_end}

{syntab: Format}
{synopt :{cmdab:co:lor(}{help grmap##color:{it:colorlist}}{cmd:)}}polyline
   color{p_end}
{synopt :{cmdab:si:ze(}{it:{help linewidthstyle}_list}{cmd:)}}polyline
   thickness{p_end}
{synopt :{cmdab:pa:ttern(}{it:{help linepatternstyle}_list}{cmd:)}}polyline
   pattern{p_end}

{syntab: Legend}
{synopt :{cmdab:legenda(on}|{cmd:off)}}display/hide polyline legend{p_end}
{synopt :{opt legt:itle(string)}}polyline legend title{p_end}
{synopt :{opt legl:abel(string)}}single-key polyline legend label{p_end}
{synopt :{opth legs:how(numlist)}}display only selected keys of polyline
   legend{p_end}
{synopt :{opt legc:ount}}display number of polylines belonging to each
   group{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:line()} is specified{p_end}

{synoptset 35 tabbed}{...}
{marker point1}{synopthdr:{help grmap##point2:point_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{synopt :{cmdab:d:ata(}{help grmap##spatdata:{it:point}{bf:.dta}}{cmd:)}}Stata
   dataset defining one or more points to be superimposed onto the
   base map{p_end}
{synopt :{cmdab:s:elect(}{help drop:{it:command}}{cmd:)}}keep/drop specified
   records of dataset {it:point}{p_end}
{synopt :{cmdab:by(}{help varname:{it:byvar_pn}}{cmd:)}}group points by
   variable {it:byvar_pn}{p_end}
{p2coldent :* {cmdab:x:coord(}{help varname:{it:xvar_pn}}{cmd:)}}variable
   containing the x coordinate of points{p_end}
{p2coldent :* {cmdab:y:coord(}{help varname:{it:yvar_pn}}{cmd:)}}variable
   containing the y coordinate of points{p_end}

{syntab: Proportional size}
{synopt :{cmdab:prop:ortional(}{help varname:{it:propvar_pn}}{cmd:)}}draw
   point markers with size proportional to variable {it:propvar_pn}{p_end}
{synopt :{opt pr:ange(min max)}}normalization range of variable
   {it:propvar_pn}{p_end}
{synopt :{cmdab:ps:ize(relative}|{cmd:absolute)}}reference system for
   drawing point markers{p_end}

{syntab: Deviation}
{synopt :{cmdab:dev:iation(}{help varname:{it:devvar_pn}}{cmd:)}}draw
   point markers as deviations from given reference value of
   variable {it:devvar_pn}{p_end}
{synopt :{cmdab:refv:al(}{cmd:mean}|{cmd:median}|{it:#}{cmd:)}}reference
   value of variable {it:devvar_pn}{p_end}
{synopt :{cmdab:refw:eight(}{help varname:{it:weightvar_pn}}{cmd:)}}compute
   reference value of variable {it:devvar_pn} weighting observations by
   variable {it:weightvar_pn}{p_end}
{synopt :{opt dm:ax(#)}}absolute value of maximum deviation{p_end}

{syntab: Format}
{synopt :{cmdab:si:ze(}{it:{help markersizestyle}_list}{cmd:)}}size of
   point markers{p_end}
{synopt :{cmdab:sh:ape(}{it:{help symbolstyle}_list}{cmd:)}}shape of
   point markers{p_end}
{synopt :{cmdab:fc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}fill
   color of point markers{p_end}
{synopt :{cmdab:oc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}outline
   color of point markers{p_end}
{synopt :{cmdab:os:ize(}{it:{help linewidthstyle}_list}{cmd:)}}outline
   thickness of point markers{p_end}

{syntab: Legend}
{synopt :{cmdab:legenda(on}|{cmd:off)}}display/hide point legend{p_end}
{synopt :{opt legt:itle(string)}}point legend title{p_end}
{synopt :{opt legl:abel(string)}}single-key point legend label{p_end}
{synopt :{opth legs:how(numlist)}}display only selected keys of point
   legend{p_end}
{synopt :{opt legc:ount}}display number of points belonging to each
   group{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:point()} is specified{p_end}

{synoptset 35 tabbed}{...}
{marker diagram1}{synopthdr:{help grmap##diagram2:diagram_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{synopt :{cmdab:d:ata(}{help grmap##spatdata:{it:diagram}{bf:.dta}}{cmd:)}}Stata
   dataset defining one or more diagrams to be superimposed onto the
   base map at given reference points{p_end}
{synopt :{cmdab:s:elect(}{help drop:{it:command}}{cmd:)}}keep/drop specified
   records of dataset {it:diagram}{p_end}
{synopt :{cmdab:by(}{help varname:{it:byvar_dg}}{cmd:)}}group diagrams by
   variable {it:byvar_dg}{p_end}
{p2coldent :* {cmdab:x:coord(}{help varname:{it:xvar_dg}}{cmd:)}}variable
   containing the x coordinate of diagram reference points{p_end}
{p2coldent :* {cmdab:y:coord(}{help varname:{it:yvar_dg}}{cmd:)}}variable
   containing the y coordinate of diagram reference points{p_end}
{p2coldent :* {cmdab:v:ariables(}{help varlist:{it:diagvar_dg}}{cmd:)}}variable
   or variables to be represented by diagrams{p_end}
{synopt :{cmdab:t:ype(frect}|{cmd:pie)}}diagram type{p_end}

{syntab: Proportional size}
{synopt :{cmdab:prop:ortional(}{help varname:{it:propvar_dg}}{cmd:)}}draw
   diagrams with area proportional to variable {it:propvar_dg}{p_end}
{synopt :{opt pr:ange(min max)}}reference range of variable
   {it:propvar_dg}{p_end}

{syntab: Framed-rectangle chart}
{synopt :{opt r:ange(min max)}}reference range of variable {it:diagvar_dg}
   {p_end}
{synopt :{cmdab:refv:al(}{cmd:mean}|{cmd:median}|{it:#}{cmd:)}}reference value
   of variable {it:diagvar_dg}{p_end}
{synopt :{cmdab:refw:eight(}{help varname:{it:weightvar_dg}}{cmd:)}}compute the
   reference value of variable {it:diagvar_dg} weighting observations by
   variable {it:weightvar_dg}{p_end}
{synopt :{opth refc:olor(colorstyle)}}color of the line representing the
   reference value of variable {it:diagvar_dg}{p_end}
{synopt :{opth refs:ize(linewidthstyle)}}thickness of the line
   representing the reference value of variable {it:diagvar_dg}{p_end}

{syntab: Format}
{synopt :{opt si:ze(#)}}diagram size{p_end}
{synopt :{cmdab:fc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}fill
   color of the diagrams{p_end}
{synopt :{cmdab:oc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}outline
   color of the diagrams{p_end}
{synopt :{cmdab:os:ize(}{it:{help linewidthstyle}_list}{cmd:)}}outline
   thickness of the diagrams{p_end}

{syntab: Legend}
{synopt :{cmdab:legenda(on}|{cmd:off)}}display/hide diagram legend{p_end}
{synopt :{opt legt:itle(string)}}diagram legend title{p_end}
{synopt :{opth legs:how(numlist)}}display only selected keys of diagram
   legend{p_end}
{synopt :{opt legc:ount}}display number of diagrams belonging to each
   group{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:diagram()} is specified{p_end}

{synoptset 35 tabbed}{...}
{marker arrow1}{synopthdr:{help grmap##arrow2:arrow_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{p2coldent :* {cmdab:d:ata(}{help grmap##spatdata:{it:arrow}{bf:.dta}}{cmd:)}}Stata
   dataset defining one or more arrows to be superimposed onto the
   base map{p_end}
{synopt :{cmdab:s:elect(}{help drop:{it:command}}{cmd:)}}keep/drop
   specified records of dataset {it:arrow}{p_end}
{synopt :{cmdab:by(}{help varname:{it:byvar_ar}}{cmd:)}}group arrows by
   variable {it:byvar_ar}{p_end}

{syntab: Format}
{synopt :{opt dir:ection(directionstyle_list)}}arrow direction, where
   {it:directionstyle} is one of the following: {cmd:1} (monodirectional
   arrow), {cmd:2} (bidirectional arrow){p_end}
{synopt :{cmdab:hsi:ze(}{it:{help markersizestyle}_list}{cmd:)}}arrowhead
   size{p_end}
{synopt :{cmdab:han:gle(}{it:{help anglestyle}_list}{cmd:)}}arrowhead
   angle{p_end}
{synopt :{cmdab:hba:rbsize(}{it:{help markersizestyle}_list}{cmd:)}}size of
   filled portion of arrowhead{p_end}
{synopt :{cmdab:hfc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}arrowhead
   fill color{p_end}
{synopt :{cmdab:hoc:olor(}{help grmap##color:{it:colorlist}}{cmd:)}}arrowhead
   outline color{p_end}
{synopt :{cmdab:hos:ize(}{it:{help linewidthstyle}_list}{cmd:)}}arrowhead
   outline thickness{p_end}
{synopt :{cmdab:lco:lor(}{help grmap##color:{it:colorlist}}{cmd:)}}arrow shaft
   line color{p_end}
{synopt :{cmdab:lsi:ze(}{it:{help linewidthstyle}_list}{cmd:)}}arrow shaft
   line thickness{p_end}
{synopt :{cmdab:lpa:ttern(}{it:{help linepatternstyle}_list}{cmd:)}}arrow
   shaft line pattern{p_end}

{syntab: Legend}
{synopt :{cmdab:legenda(on}|{cmd:off)}}display/hide arrow legend{p_end}
{synopt :{opt legt:itle(string)}}arrow legend title{p_end}
{synopt :{opt legl:abel(string)}}single-key arrow legend label{p_end}
{synopt :{opth legs:how(numlist)}}display only selected keys of
   arrow legend{p_end}
{synopt :{opt legc:ount}}display number of arrows belonging to each
   group{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:arrow()} is specified{p_end}

{synoptset 35 tabbed}{...}
{marker label1}{synopthdr:{help grmap##label2:label_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{synopt :{cmdab:d:ata(}{help grmap##spatdata:{it:label}{bf:.dta}}{cmd:)}}Stata
   dataset defining one or more labels to be superimposed onto the
   base map at given reference points{p_end}
{synopt :{cmdab:s:elect(}{help drop:{it:command}}{cmd:)}}keep/drop specified
   records of dataset {it:label}{p_end}
{synopt :{cmdab:by(}{help varname:{it:byvar_lb}}{cmd:)}}group labels by
   variable {it:byvar_lb}{p_end}
{p2coldent :* {cmdab:x:coord(}{help varname:{it:xvar_lb}}{cmd:)}}variable
   containing the x coordinate of label reference points{p_end}
{p2coldent :* {cmdab:y:coord(}{help varname:{it:yvar_lb}}{cmd:)}}variable
   containing the y coordinate of label reference points{p_end}
{p2coldent :* {cmdab:l:abel(}{help varname:{it:labvar_lb}}{cmd:)}}variable
   containing the labels{p_end}

{syntab: Format}
{synopt :{opt le:ngth(lengthstyle_list)}}maximum number of label
   characters, where {it:lengthstyle} is any integer>0{p_end}
{synopt :{cmdab:si:ze(}{it:{help textsizestyle}_list}{cmd:)}}label size{p_end}
{synopt :{cmdab:co:lor(}{help grmap##color:{it:colorlist}}{cmd:)}}label color{p_end}
{synopt :{cmdab:po:sition(}{it:{help clockpos}_list}{cmd:)}}position of labels
   relative to their reference point{p_end}
{synopt :{cmdab:ga:p(}{it:{help size}_list}{cmd:)}}gap between labels
   and their reference point{p_end}
{synopt :{cmdab:an:gle(}{it:{help anglestyle}_list}{cmd:)}}label angle{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:label()} is specified{p_end}

{synoptset 35 tabbed}{...}
{marker scalebar1}{synopthdr:{help grmap##scalebar2:scalebar_suboptions}{col 41}}
{synoptline}
{syntab: Main}
{p2coldent :* {opt u:nits(#)}}scale bar extent{p_end}
{synopt :{opt s:cale(#)}}ratio of scale bar units to map units{p_end}
{synopt :{opt x:pos(#)}}scale bar horizontal position relative to plot region
   center{p_end}
{synopt :{opt y:pos(#)}}scale bar vertical position relative to plot region
   center{p_end}

{syntab: Format}
{synopt :{opt si:ze(#)}}scale bar height multiplier{p_end}
{synopt :{opth fc:olor(colorstyle)}}fill color of scale bar{p_end}
{synopt :{opth oc:olor(colorstyle)}}outline color of scale bar{p_end}
{synopt :{opth os:ize(linewidthstyle)}}outline thickness of scale bar{p_end}
{synopt :{opt la:bel(string)}}scale bar label{p_end}
{synopt :{opth oa:lign(linealignmentstyle)}}outline alignment (inside,
   outside, center) of scale bar{p_end}
{synopt :{opth tc:olor(colorstyle)}}color of scale bar text{p_end}
{synopt :{opth ts:ize(textsizestyle)}}size of scale bar text{p_end}
{synopt :{opth ta:lign(linealignmentstyle)}}outline alignment (inside,
   outside, center) of scale bar text{p_end}
{synoptline}
{p 4 6 2}* Required when option {cmd:scalebar()} is specified{p_end}


INCLUDE help menu_spatial


{marker desc}{title:Description}

{pstd} {cmd:grmap} is aimed at visualizing several kinds of spatial data
       and is particularly suited for drawing thematic maps and displaying
       the results of spatial data analyses.

{pstd} {cmd:grmap} functioning rests on three basic principles:

{phang2}{space 1}o{space 2}First, a base map representing a given study
                           region {it:R} made up of {it:N} polygons
                           is drawn.{p_end}

{phang2}{space 1}o{space 2}Second, at the user's choice, one or more types
                           of additional spatial objects may be superimposed
                           onto the base map. In the current version of
                           {cmd:grmap}, six different types of spatial
                           objects can be superimposed onto the base
                           map: polygons (via option {cmd:polygon()}),
                           polylines (via option {cmd:line()}),
                           points (via option {cmd:point()}),
                           diagrams (via option {cmd:diagram()}),
                           arrows (via option {cmd:arrow()}),
                           and labels (via option {cmd:label()}).{p_end}

{phang2}{space 1}o{space 2}Third, at the user's choice, one or more additional
                           map elements may be added, such as a scale bar
                           (via option {cmd:scalebar()}), a title, a subtitle,
                           a note, and a caption
                           (via {it:{help title_options}}).{p_end}

{pstd}Proper specification of {cmd:grmap} options and suboptions,
      combined with the availability of properly formatted spatial data,
      allows the user to draw several kinds of maps, including choropleth
      maps, proportional symbol maps, pin maps, pie chart maps, and
      noncontiguous area cartograms.

{pstd}While providing sensible defaults for most options and supoptions,
      {cmd:grmap} gives the user full control over the formatting of almost
      every map element, thus allowing the production of highly customized
      maps.


{marker spatdata}{title:Spatial data format}

{pstd} {cmd:grmap} requires that the spatial data to be visualized be
       arranged into properly formatted Stata datasets. Such datasets
       can be classified into nine
       categories: {help grmap##sd_master:{it:master}},
       {help grmap##sd_basemap:{it:basemap}},
       {help grmap##sd_backgroundmap:{it:backgroundmap}},
       {help grmap##sd_polygon:{it:polygon}},
       {help grmap##sd_line:{it:line}},
       {help grmap##sd_point:{it:point}},
       {help grmap##sd_diagram:{it:diagram}},
       {help grmap##sd_arrow:{it:arrow}},
       {help grmap##sd_label:{it:label}}.

{marker sd_master}{pstd} The {it:master} dataset is the dataset that resides
       in memory when {cmd:grmap} is invoked.
       At the minimum, it must be {helpb spset}.
       If a
       {help grmap##choromap:choropleth map} is to be drawn, then the
       {it:master} dataset should contain also variable {it:attribute}, a
       numeric variable expressing the values of the feature to be
       represented. Additionally, if a noncontiguous area cartogram is to be
       drawn -- i.e., if the polygons making up the {help grmap##desc:base map}
       are to be drawn with area proportional to the values of a given numeric
       variable {it:areavar} -- then the {it:master} dataset should contain
       also variable {it:areavar}.

{marker sd_basemap}{pstd} A {it:basemap} dataset is a Stata dataset that
       contains the definition of the polygon or polygons making up the
       {help grmap##desc:base map}.
       {cmd:grmap} assumes that the {it:basemap} dataset has been previously
       {helpb spset}.
       A {it:basemap} dataset is required to
       have the following structure:

{center: _ID        _X        _Y  _EMBEDDED}
{center:{hline 37}}
{center:   1         .         .          0}
{center:   1        10        30          0}
{center:   1        10        50          0}
{center:   1        30        50          0}
{center:   1        30        30          0}
{center:   1        10        30          0}
{center:   2         .         .          0}
{center:   2        10        10          0}
{center:   2        10        30          0}
{center:   2        18        30          0}
{center:   2        18        10          0}
{center:   2        10        10          0}
{center:   2         .         .          0}
{center:   2        22        10          0}
{center:   2        22        30          0}
{center:   2        30        30          0}
{center:   2        30        10          0}
{center:   2        22        10          0}
{center:   3         .         .          1}
{center:   3        15        35          1}
{center:   3        15        45          1}
{center:   3        25        45          1}
{center:   3        25        35          1}
{center:   3        15        35          1}
{center:{hline 37}}

{pstd} _ID is required and is a numeric variable that uniquely identifies
       the polygons making up the {help grmap##desc:base map}. _X is required
       and is a numeric variable that contains the x coordinate of the
       nodes of the {help grmap##desc:base map} polygons. _Y is required and
       is a numeric variable that contains the y coordinate of the nodes
       of the {help grmap##desc:base map} polygons. Finally, _EMBEDDED is
       optional and is an indicator variable taking value 1 if the
       corresponding polygon is completely enclosed in another polygon, and
       value 0 otherwise. The following should be noticed:

{phang2}{space 1}o{space 2}Both simple and multipart polygons are allowed. In
       the example above, polygons 1 and 3 are simple (i.e., they consist of
       a single area), while polygon 2 is multipart (i.e., it consists of two
       distinct areas).{p_end}

{phang2}{space 1}o{space 2}The first record of each simple polygon or of each
       part of a multipart polygon must contain missing x and
       y coordinates.{p_end}

{phang2}{space 1}o{space 2}The nonmissing coordinates of each simple polygon
       or of each part of a multipart polygon must be ordered to
       correspond to consecutive nodes.{p_end}
  
{phang2}{space 1}o{space 2}Each simple polygon or each part of a multipart
       polygon must be "closed"; i.e., the last pair of nonmissing coordinates
       must be equal to the first pair.{p_end}
       
{phang2}{space 1}o{space 2}A {it:basemap} dataset is always required to be
       sorted by variable _ID.{p_end}

{marker sd_backgroundmap}{pstd} A {it:backgroundmap} dataset is a Stata dataset
       that contains the definition of the polygon or polygons making up the
       background map -- a map that can be optionally drawn as
       background of a noncontiguous area cartogram. A {it:backgroundmap}
       dataset has exactly the same structure as a
       {help grmap##sd_basemap:{it:basemap}} dataset, except for variable
       _EMBEDDED, which is never used.

{marker sd_polygon}{pstd} A {it:polygon} dataset is a Stata dataset that
       contains the definition of one or more supplementary polygons to
       be superimposed onto the {help grmap##desc:base map}. A {it:polygon}
       dataset is required to have the following structure:

{center: _ID        _X        _Y   {it:byvar_pl}}
{center:{hline 37}}
{center:   1         .         .          1}
{center:   1        20        40          1}
{center:   1        20        42          1}
{center:   1        25        42          1}
{center:   1        25        40          1}
{center:   1        20        40          1}
{center:   2         .         .          1}
{center:   2        11        20          1}
{center:   2        11        25          1}
{center:   2        13        25          1}
{center:   2        13        20          1}
{center:   2        11        20          1}
{center:   3         .         .          2}
{center:   3        25        25          2}
{center:   3        25        35          2}
{center:   3        30        35          2}
{center:   3        30        25          2}
{center:   3        25        25          2}
{center:{hline 37}}

{pstd} Variables _ID, _X, and _Y are defined exactly in the same way as in a
       {help grmap##sd_basemap:{it:basemap}} dataset, with the sole exception
       that only simple polygons are allowed. In turn, {it:byvar_pl} is a
       placeholder denoting an optional variable that can be specified to
       distinguish different kinds of supplementary polygons.

{marker sd_line}{pstd} A {it:line} dataset is a Stata dataset that contains
       the definition of one or more polylines to be superimposed onto the
       {help grmap##desc:base map}. A {it:line} dataset is required to have
       the following structure:

{center: _ID        _X        _Y   {it:byvar_ln}}
{center:{hline 37}}
{center:   1         .         .          1}
{center:   1        11        30          1}
{center:   1        12        33          1}
{center:   1        15        33          1}
{center:   1        16        35          1}
{center:   1        18        40          1}
{center:   1        25        38          1}
{center:   1        25        42          1}
{center:   2         .         .          2}
{center:   2        12        20          2}
{center:   2        18        15          2}
{center:   3         .         .          2}
{center:   3        27        28          2}
{center:   3        27        25          2}
{center:   3        28        27          2}
{center:   3        29        25          2}
{center:{hline 37}}

{pstd} _ID is required and is a numeric variable that uniquely identifies
       the polylines. _X is required and is a numeric variable that
       contains the x coordinate of the nodes of the polylines. _Y is
       required and is a numeric variable that contains the y coordinate
       of the nodes of the polylines. Finally, {it:byvar_ln} is a placeholder
       denoting an optional variable that can be specified to distinguish
       different kinds of polylines. The following should be noticed:

{phang2}{space 1}o{space 2}The first record of each polyline must contain
       missing x and y coordinates.{p_end}

{phang2}{space 1}o{space 2}The nonmissing coordinates of each polyline
       must be ordered so as to correspond to consecutive nodes.{p_end}

{marker sd_point}{pstd} A {it:point} dataset is a Stata dataset that contains
       the definition of one or more points to be superimposed onto the
       {help grmap##desc:base map}. A {it:point} dataset is required to have
       the following structure:

{center:{it:xvar_pn}  {it:yvar_pn}  {it:byvar_pn}  {it:propvar_pn}  {it:devvar_pn}  {it:weightvar_pn}}
{center:{hline 65}}
{center:     11       30         1         100         30          1000}
{center:     20       34         1         110         25          1500}
{center:     25       40         1          90         40          1230}
{center:     25       45         2         200         10           950}
{center:     15       20         2          50         70           600}
{center:{hline 65}}

{pstd} {it:xvar_pn} is a placeholder denoting a required numeric variable
       that contains the x coordinate of the points. {it:yvar_pn} is
       a placeholder denoting a required numeric variable that contains the
       y coordinate of the points. {it:byvar_pn} is a placeholder
       denoting an optional variable that can be specified to distinguish
       different kinds of points. {it:propvar_pn} is a placeholder denoting
       an optional variable that, when specified, requests that the point
       markers be drawn with size proportional to {it:propvar_pn}. {it:devvar_pn}
       is a placeholder denoting an optional variable that, when specified,
       requests that the point markers be drawn as deviations from a given
       reference value of {it:devvar_pn}. Finally, {it:weightvar_pn} is a
       placeholder denoting an optional variable that, when specified, requests
       that the reference value of {it:devvar_pn} be computed weighting
       observations by variable {it:weightvar_pn}. It is important to note that
       the required and optional variables making up a {it:point} dataset can
       either reside in an external dataset or be part of the
       {help grmap##sd_master:{it:master}} dataset.

{marker sd_diagram}{pstd} A {it:diagram} dataset is a Stata dataset that
       contains the definition of one or more diagrams to be superimposed
       onto the {help grmap##desc:base map} at given reference points. A
       {it:diagram} dataset is required to have the following structure:

{center:{it:xvar_dg}  {it:yvar_dg}  {it:byvar_dg}  {it:diagvar_dg}  {it:propvar_dg}  {it:weightvar_dg}}
{center:{hline 66}}
{center:     15       30         1         ...          30          1000}
{center:     18       40         1         ...          25          1500}
{center:     20       45         1         ...          40          1230}
{center:     25       45         2         ...          10           950}
{center:     15       20         2         ...          70           600}
{center:{hline 66}}

{pstd} {it:xvar_dg} is a placeholder denoting a required numeric variable
       that contains the x coordinate of the diagram reference
       points. {it:yvar_dg} is a placeholder denoting a required numeric
       variable that contains the y coordinate of the diagram reference
       points. {it:byvar_dg} is a placeholder denoting an optional variable
       that can be specified to distinguish different groups of
       diagrams. {it:diagvar_dg} is a placeholder denoting one or more
       variables to be represented by the diagrams. {it:propvar_dg} is a
       placeholder denoting an optional variable that, when specified,
       requests that the diagrams be drawn with area proportional to
       {it:propvar_dg}. Finally, {it:weightvar_dg} is a placeholder denoting
       an optional variable that, when specified, requests that the reference
       value of the diagrams be computed weighting observations by variable
       {it:weightvar_dg} (this applies only to framed-rectangle charts). It
       is important to note that the required and optional variables making
       up a {it:diagram} dataset can either reside in an external dataset or
       be part of the {help grmap##sd_master:{it:master}} dataset.

{marker sd_arrow}{pstd} An {it:arrow} dataset is a Stata dataset that contains
       the definition of one or more arrows to be superimposed onto the
       {help grmap##desc:base map}. An {it:arrow} dataset is required to have
       the following structure:

{center: _ID       _X1       _Y1       _X2       _Y2   {it:byvar_ar}}
{center:{hline 57}}
{center:   1        11        30        18        30          1}
{center:   2        15        40        15        45          1}
{center:   3        15        40        25        40          1}
{center:   4        20        35        28        45          2}
{center:   5        17        20        20        11          2}
{center:{hline 57}}

{pstd} _ID is required and is a numeric variable that uniquely identifies
       the arrows. _X1 is required and is a numeric variable that contains
       the x coordinate of the starting point of the arrows. _Y1 is
       required and is a numeric variable that contains the y coordinate
       of the starting point of the arrows. _X2 is required and is a numeric
       variable that contains the x coordinate of the ending point of
       the arrows. _Y2 is required and is a numeric variable that contains
       the y coordinate of the ending point of the arrows. Finally,
       {it:byvar_ar} is a placeholder denoting an optional variable that can
       be specified to distinguish different kinds of arrows.

{marker sd_label}{pstd} A {it:label} dataset is a Stata dataset that contains
       the definition of one or more labels to be superimposed onto the
       {help grmap##desc:base map} at given reference points. A {it:label}
       dataset is required to have the following structure:

{center:{it:xvar_lb}  {it:yvar_lb}  {it:byvar_lb}  {it:labvar_lb}}
{center:{hline 39}}
{center:     11       33         1      Abcde}
{center:     20       37         1        Fgh}
{center:     25       43         1       IJKL}
{center:     25       48         2     Mnopqr}
{center:     15       22         2        stu}
{center:{hline 39}}

{pstd} {it:xvar_lb} is a placeholder denoting a required numeric variable
       that contains the x coordinate of the label reference
       points. {it:yvar_lb} is a placeholder denoting a required numeric
       variable that contains the y coordinate of the label reference
       points. {it:byvar_lb} is a placeholder denoting an optional variable
       that can be specified to distinguish different kinds of labels. Finally,
       {it:labvar_lb} is a placeholder denoting the variable that contains the
       labels. It is important to note that the required and optional variables
       making up a {it:label} dataset can either reside in an external dataset
       or be part of the {help grmap##sd_master:{it:master}} dataset.


{marker color}{title:Color lists}

{pstd} Some {cmd:grmap} options and suboptions request the user to specify
       a list of one or more colors. When the list includes only one color,
       the user is required to specify a standard {it:{help colorstyle}}. On
       the other hand, when the list includes two or more colors, the user
       can either specify a standard
       {help colorstyle:{it:colorstyle}} {help stylelists:{it:list}},
       or specify the name of a predefined color scheme.{p_end}

{marker colorscheme}{pstd}The following table lists the predefined color
      schemes available in the current version of {cmd:grmap}, indicating
      the name of each scheme, the maximum number of different colors it
      allows, its type, and its source.

{center:       NAME     MAXCOL         TYPE     SOURCE}
{center:{hline 48}}
{center:      Blues          9   Sequential     Brewer}
{center:     Blues2         99   Sequential     Custom}
{center:       BuGn          9   Sequential     Brewer}
{center:       BuPu          9   Sequential     Brewer}
{center:       GnBu          9   Sequential     Brewer}
{center:     Greens          9   Sequential     Brewer}
{center:    Greens2         99   Sequential     Custom}
{center:      Greys          9   Sequential     Brewer}
{center:     Greys2         99   Sequential     Brewer}
{center:       Heat         16   Sequential     Custom}
{center:       OrRd          9   Sequential     Brewer}
{center:    Oranges          9   Sequential     Brewer}
{center:       PuBu          9   Sequential     Brewer}
{center:     PuBuGn          9   Sequential     Brewer}
{center:       PuRd          9   Sequential     Brewer}
{center:    Purples          9   Sequential     Brewer}
{center:    Rainbow         99   Sequential     Custom}
{center:       RdPu          9   Sequential     Brewer}
{center:       Reds          9   Sequential     Brewer}
{center:      Reds2         99   Sequential     Custom}
{center:    Terrain         16   Sequential     Custom}
{center:Topological         16   Sequential     Custom}
{center:       YlGn          9   Sequential     Brewer}
{center:     YlGnBu          9   Sequential     Brewer}
{center:     YlOrBr          9   Sequential     Brewer}
{center:     YlOrRd          9   Sequential     Brewer}
{center:       BrBG         11    Diverging     Brewer}
{center:       BuRd         11    Diverging     Custom}
{center:     BuYlRd         11    Diverging     Custom}
{center:       PRGn         11    Diverging     Brewer}
{center:       PiYG         11    Diverging     Brewer}
{center:       PuOr         11    Diverging     Brewer}
{center:       RdBu         11    Diverging     Brewer}
{center:       RdGy         11    Diverging     Brewer}
{center:     RdYlBu         11    Diverging     Brewer}
{center:     RdYlGn         11    Diverging     Brewer}
{center:   Spectral         11    Diverging     Brewer}
{center:     Accent          8  Qualitative     Brewer}
{center:      Dark2          8  Qualitative     Brewer}
{center:     Paired         12  Qualitative     Brewer}
{center:    Pastel1          9  Qualitative     Brewer}
{center:    Pastel2          8  Qualitative     Brewer}
{center:       Set1          9  Qualitative     Brewer}
{center:       Set2          8  Qualitative     Brewer}
{center:       Set3         12  Qualitative     Brewer}
{center:{hline 48}}

{pstd}Following Brewer (1999), {it:sequential schemes} are typically used to
      represent ordered data, so that higher data values are represented by
      darker colors; in turn, {it:diverging schemes} are used when there is
      a meaningful midpoint in the data, to emphasize progressive divergence
      from this midpoint in the two opposite directions; finally,
      {it:qualitative schemes} are generally used to represent unordered,
      categorical data.

{pstd}The color schemes whose source is indicated as "Brewer" were designed by
      Dr. Cynthia A. Brewer, Department of Geography, The Pennsylvania State
      University, University Park, Pennsylvania, USA (Brewer, Hatchard, and
      Harrower 2003). These color schemes are used with Dr. Brewer's
      permission and are taken from the ColorBrewer map design tool available
      at {browse "ColorBrewer.org"}.


{marker choromap}{title:Choropleth maps}

{pstd} A choropleth map can be defined as a map in which each subarea (e.g.,
   each census tract) of a given study region (e.g., a city) is colored
   or shaded with an intensity proportional to the value taken on by a given
   quantitative variable in that subarea (Slocum et al. 2005). Since
   choropleth maps are one of the most popular means for representing the
   spatial distribution of quantitative variables, it is worth noting the way
   {cmd:grmap} can be used to draw this kind of map.
   
{pstd} In {cmd:grmap}, a choropleth map is a {help grmap##desc:base map} whose
   constituent polygons are colored according to the values taken on by
   {it:attribute}, a numeric variable that must be contained in the
   {help grmap##sd_master:{it:master}} dataset and specified immediately after
   the main command (see {help grmap##syntax:syntax diagram} above). To draw
   the desired choropleth map, {cmd:grmap} first groups the values taken on
   by variable {it:attribute} into {it:k} classes defined by a given set
   of class breaks and then assigns a different color to each class. The
   current version of {cmd:grmap} offers six methods for determining class
   breaks:

{phang2}{space 1}o{space 2}{it:Quantiles}: Class breaks correspond to quantiles
                           of the distribution of variable {it:attribute}, so
                           that each class includes approximately the same
                           number of polygons.{p_end}

{phang2}{space 1}o{space 2}{it:Boxplot}: The distribution of variable
                           {it:attribute} is divided into 6 classes defined
                           as follows: [min,{space 1}p25{space 1}-{space 1}1.5*iqr],
                           (p25{space 1}-{space 1}1.5*iqr,{space 1}p25],
                           (p25,{space 1}p50], (p50,{space 1}p75],
                           (p75,{space 1}p75{space 1}+{space 1}1.5*iqr], and
                           (p75{space 1}+{space 1}1.5*iqr,{space 1}max],
                           where iqr{space 1}={space 1}interquartile
                           range.{p_end}

{phang2}{space 1}o{space 2}{it:Equal intervals}: Class breaks correspond to
                           values that divide the distribution of variable
                           {it:attribute} into {it:k} equal-width
                           intervals.{p_end}

{phang2}{space 1}o{space 2}{it:Standard deviates}: The distribution of
                           variable {it:attribute} is divided
                           into {it:k} classes
                           (2{space 1}<={space 1}{it:k}{space 1}<={space 1}9)
                           whose width is defined as a fraction {it:p} of its
                           standard deviation sd. Following the suggestions
                           of Evans (1977), this proportion {it:p} varies
                           with {it:k} as follows:{p_end}

{center: {it:k}      {it:p}}
{center:{hline 12}}
{center:  2     inf}
{center:  3     1.2}
{center:  4     1.0}
{center:  5     0.8}
{center:  6     0.8}
{center:  7     0.8}
{center:  8     0.6}
{center:  9     0.6}
{center:{hline 12}}

{phang2}{space 1}{space 3}Class intervals are centered on the arithmetic mean
                          {it:m}, which is a class midpoint if {it:k} is odd
                          and a class boundary if {it:k} is even; the lowest
                          and highest classes are open ended (Evans
                          1977).{p_end}

{phang2}{space 1}o{space 2}{it:k-means}: The distribution of variable
                           {it:attribute} is divided into {it:k} classes using
                           {help cluster kmeans:k-means partition cluster analysis}. The
                           clustering procedure is applied several times to
                           variable {it:attribute}, and the solution that
                           maximizes the goodness-of-variance fit (Armstrong
                           et al. 2003) is used.

{phang2}{space 1}o{space 2}{it:Custom}: Class breaks are specified by the user.

{pstd}Alternatively, {cmd:grmap} allows the user to leave the values of
      variable {it:attribute} ungrouped. In this case, {it:attribute} is
      treated as a categorical variable, and a different color is assigned to
      each of its values.


{marker options}{...}
{marker panel2}{title:Options for panel data}

{phang}
{opt t(#)} restricts {cmd:grmap} to use observations where
{it:timevar}=={it:#}.
{it:timevar} is the currently {cmd:xtset} time variable,
see {helpb xtset}.
This option is required for panel data; otherwise, it is not allowed.


{marker basemap2}{title:Options for drawing the base map}

{dlgtab:Cartogram}

{phang}
{cmdab:area(}{help varname:{it:areavar}}{cmd:)} requests that the polygons
   making up the {help grmap##desc:base map} be drawn with area proportional
   to the values taken on by numeric variable {it:areavar}, so that a  
   noncontiguous area cartogram (Olson 1976) is obtained. {it:areavar} must
   be contained in the {help grmap##sd_master:{it:master}} dataset.

{phang}
{cmd:split} requests that, before drawing a noncontiguous area cartogram, all
   multipart {help grmap##desc:base map} polygons be split into their
   constituent parts, each of which will then be treated as a distinct simple
   polygon.

{phang}
{cmdab:map(}{help grmap##sd_backgroundmap:{it:backgroundmap}}{cmd:)} requests
   that, when drawing a noncontiguous area cartogram, the polygons making up
   the {help grmap##desc:base map} be superimposed onto a background map
   defined in Stata dataset {it:backgroundmap}.

{phang}
{opth mfcolor(colorstyle)} specifies the fill color of the background map. The
   default is {cmd:mfcolor(none)}.

{phang}
{opth mocolor(colorstyle)} specifies the outline color of the background
   map. The default is {cmd:mocolor(black)}.

{phang}
{opth mosize(linewidthstyle)} specifies the outline thickness of the
   background map. The default is {cmd:mosize(thin)}.

{phang}
{opth mopattern(linepatternstyle)} specifies the outline pattern of the
   background map. The default is {cmd:mopattern(solid)}.

{phang}
{opth moalign(linealignmentstyle)} specifies whether the line outlining the
   background map is drawn inside, is drawn outside, or is centered.  The
   default is {cmd:moalign(center)}.

{dlgtab:Choropleth map}

{phang}
{opt clmethod(method)} specifies the method to be used for classifying variable
   {it:attribute} and representing its spatial distribution as a
   {help grmap##choromap:choropleth map}.

{phang2}{cmd:clmethod(quantile)} is the default and requests that
   the quantiles method be used.{p_end}

{phang2}{cmd:clmethod(boxplot)} requests that the boxplot
   method be used.{p_end}

{phang2}{cmd:clmethod(eqint)} requests that the equal intervals
   method be used.{p_end}

{phang2}{cmd:clmethod(stdev)} requests that the standard deviates
   method be used.{p_end}

{phang2}{cmd:clmethod(kmeans)} requests that the {it:k}-means
   method be used.{p_end}

{phang2}{cmd:clmethod(custom)} requests that class breaks be
   specified by the user with option {opt clbreaks(numlist)}.{p_end}

{phang2}{cmd:clmethod(unique)} requests that each value of variable
   {it:attribute} be treated as a distinct class.{p_end}

{phang}
{opt clnumber(#)} specifies the number of classes {it:k} in which variable
   {it:attribute} is to be divided. When the quantiles, equal intervals,
   standard deviates, or {it:k}-means classification method is chosen, the
   default is {cmd:clnumber(4)}. When the boxplot classification method is
   chosen, this option is inactive and {it:k}=6. When the custom
   classification method is chosen, this option is inactive, and {it:k} equals
   the number of elements of {it:numlist} specified in option
   {opt clbreaks(numlist)} minus 1. When the unique classification method
   is chosen, this option is inactive, and {it:k} equals the number of
   different values taken on by variable {it:attribute}.

{phang}
{opth clbreaks(numlist)} is required when option {cmd:clmethod(custom)}
   is specified. It defines the custom class breaks to be used for classifying
   variable {it:attribute}. {it:numlist} should be specified so that the
   first element is the minimum value of variable {it:attribute} to be
   considered; the second to {it:k}th elements are the class breaks; and the
   last element is the maximum value of variable {it:attribute} to be
   considered. For example, suppose we want to group the values of variable
   {it:attribute} into the following four classes: [10,15], (15,20], (20,25],
   and (25,50]. For this, we must specify {cmd:clbreaks(10 15 20 25 50)}.

{phang}
{opt eirange(min max)} specifies the range of values (minimum and maximum)
   to be considered in the calculation of class breaks when option
   {cmd:clmethod(eqint)} is specified. This option overrides the default
   range [min({it:attribute}), max({it:attribute})].

{phang}
{opt kmiter(#)} specifies the number of times the clustering procedure is
   applied when option {cmd:clmethod(kmeans)} is specified. The default
   is {cmd:kmiter(20)}.

{phang}
{opth ndfcolor(colorstyle)} specifies the fill color of the empty (no data)
   polygons of the {help grmap##choromap:choropleth map}. The default is
   {cmd:ndfcolor(white)}.

{phang}
{opth ndocolor(colorstyle)} specifies the outline color of the empty (no data)
   polygons of the {help grmap##choromap:choropleth map}. The default is
   {cmd:ndocolor(black)}.

{phang}
{opth ndsize(linewidthstyle)} specifies the outline thickness of the empty
   (no data) polygons of the {help grmap##choromap:choropleth map}. The
   default is {cmd:ndsize(thin)}.

{phang}
{opth ndpattern(linepatternstyle)} specifies the outline pattern of the empty
   (no data) polygons of the {help grmap##choromap:choropleth map}. The
   default is {cmd:ndpattern(solid)}.

{phang}
{opth ndalign(linealignmentstyle)} specifies whether the line outlining the
   empty (no data) polygons of the {help grmap##choromap:choropleth map} is
   drawn inside, is drawn outside, or is centered. The default is
   {cmd:ndalign(center)}.

{phang}
{opt ndlabel(string)} specifies the legend label to be attached to the empty
   (no data) polygons of the {help grmap##choromap:choropleth map}. The
   default is {cmd:ndlabel(No data)}.

{dlgtab:Format}

{phang}
{cmdab:fcolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the
   list of fill colors of the {help grmap##desc:base map} polygons. When
   no {help grmap##choromap:choropleth map} is drawn, the list should
   include only one element. On the other hand, when a
   {help grmap##choromap:choropleth map} is drawn, the list should
   be either composed of {it:k} elements or represented by the name
   of a predefined {help grmap##colorscheme:color scheme}. The default
   fill color is {cmd:none}. When a {help grmap##choromap:choropleth map}
   is drawn, the default argument is a {help grmap##colorscheme:color scheme}
   that depends on the classification method specified in option
   {opt clmethod(method)}:

{center:Classification         Default  }
{center:      method          color scheme  }
{center:{hline 34}}
{center:  quantile            Greys  }
{center:  boxplot             BuRd   }
{center:  eqint               Greys  }
{center:  stdev               BuRd   }
{center:  kmeans              Greys  }
{center:  custom              Greys  }
{center:  unique              Paired }
{center:{hline 34}}

{phang}
{cmdab:ocolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the
   list of outline colors of the {help grmap##desc:base map} polygons. When
   no {help grmap##choromap:choropleth map} is drawn, the list should
   include only one element. On the other hand, when a
   {help grmap##choromap:choropleth map} is drawn, the list should
   be either composed of {it:k} elements or represented by the name
   of a predefined {help grmap##colorscheme:color scheme}. The default
   outline color is {cmd:black}; the default specification is
   {cmd:ocolor(black ...)}.

{phang}
{cmdab:osize(}{it:{help linewidthstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline thicknesses of the
   {help grmap##desc:base map} polygons. When no
   {help grmap##choromap:choropleth map} is drawn, the list should
   include only one element. On the other hand, when a
   {help grmap##choromap:choropleth map} is drawn, the list should
   be composed of {it:k} elements. The default outline thickness is
   {cmd:thin}; the default specification is {cmd:osize(thin ...)}.

{phang}
{cmdab:opattern(}{it:{help linepatternstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline patterns of the
   {help grmap##desc:base map} polygons. When no
   {help grmap##choromap:choropleth map} is drawn, the list should
   include only one element. On the other hand, when a
   {help grmap##choromap:choropleth map} is drawn, the list should
   be composed of {it:k} elements. The default outline pattern is
   {cmd:solid}; the default specification is {cmd:opattern(solid ...)}.

{phang}
{cmdab:oalign(}{it:{help linealignmentstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline alignments of the
   {help grmap##desc:base map} polygons. When no
   {help grmap##choromap:choropleth map} is drawn, the list should
   include only one element. On the other hand, when a
   {help grmap##choromap:choropleth map} is drawn, the list should
   be composed of {it:k} elements. The default outline alignment is
   {cmd:center}; the default specification is {cmd:oalign(center ...)}.

{dlgtab:Legend}

{phang}
{cmdab:legenda(on}|{cmd:off)} specifies whether the {help grmap##desc:base map}
   legend should be displayed or hidden.

{phang2}{cmd:legenda(on)} requests that the {help grmap##desc:base map} legend
   be displayed. This is the default when a
   {help grmap##choromap:choropleth map} is drawn.{p_end}

{phang2}{cmd:legenda(off)} requests that the {help grmap##desc:base map} legend
   be hidden. This is the default when no {help grmap##choromap:choropleth map}
   is drawn.{p_end}

{phang}
{opt legtitle(string)} specifies the title of the {help grmap##desc:base map}
   legend. When a {help grmap##choromap:choropleth map} is drawn, option
   {cmd:legtitle(varlab)} requests that the label of variable {it:attribute}
   be used as the legend title.

{phang}
{opt leglabel(string)} specifies the label to be attached to the single key of
   the {help grmap##desc:base map} legend when no
   {help grmap##choromap:choropleth map} is drawn. This option is required when
   option {cmd:legenda(on)} is specified and no
   {help grmap##choromap:choropleth map} is drawn.

{phang}
{cmdab:legorder(hilo}|{cmd:lohi)} specifies the display order of the keys of
   the {help grmap##desc:base map} legend when a
   {help grmap##choromap:choropleth map} is drawn.

{phang2}{cmd:legorder(hilo)} is the default and requests that the keys of the
   {help grmap##desc:base map} legend be displayed in descending order of
   variable {it:attribute}.{p_end}

{phang2}{cmd:legorder(lohi)} requests that the keys of the
   {help grmap##desc:base map} legend be displayed in ascending order of
   variable {it:attribute}. This is the default when option
   {cmd:clmethod({cmdab:u:nique})} is specified.{p_end}

{phang}
{cmdab:legstyle(0}|{cmd:1}|{cmd:2}|{cmd:3)} specifies the way the keys of
   the {help grmap##desc:base map} legend are labeled when a
   {help grmap##choromap:choropleth map} is drawn.

{phang2}{cmd:legstyle(0)} requests that the keys of the
   {help grmap##desc:base map} legend not be labeled.{p_end}

{phang2}{cmd:legstyle(1)} is the default and requests that the keys of the
   {help grmap##desc:base map} legend be labeled using the standard
   mathematical notation for value intervals (e.g., (20,35]).{p_end}

{phang2}{cmd:legstyle(2)} requests that the keys of the
   {help grmap##desc:base map} legend be labeled using the notation
   ll&ul, where ll denotes the lower limit of the class interval, ul
   denotes the upper limit of the class interval, and & denotes a
   string that separates the two values. For example, if ll=20, ul=35,
   and &=" - ", then the resulting label will be "20 - 35".{p_end}

{phang2}{cmd:legstyle(3)} requests that only the first and last keys of
   the {help grmap##desc:base map} legend be labeled. The first key is
   labeled with the lower limit of the corresponding class interval; the
   last key is labeled with the upper limit of the corresponding class
   interval.{p_end}

{phang}
{opt legjunction(string)} specifies the string to be used as separator
   when option {cmd:legstyle(2)} is specified. The default is
   {cmd:legjunction(" - ")}.

{phang}
{opt legcount} requests that, when a {help grmap##choromap:choropleth map}
   is drawn, the number of {help grmap##desc:base map} polygons belonging
   to each class of variable {it:attribute} be displayed in the legend.


{marker polygon2}{title:Option polygon() suboptions}

{dlgtab:Main}

{phang}
{cmdab:data(}{help grmap##sd_polygon:{it:polygon}{bf:.dta}}{cmd:)} requests that one
   or more supplementary polygons defined in Stata dataset {it:polygon}
   be superimposed onto the {help grmap##desc:base map}.

{phang}
{cmdab:select(}{help drop:{it:command}}{cmd:)} requests that a given subset
   of records of dataset {it:polygon} be selected using Stata commands
   {help drop:keep} or {help drop}.

{phang}
{cmdab:by(}{help varname:{it:byvar_pl}}{cmd:)} indicates that the
   supplementary polygons defined in dataset {it:polygon} belong
   to {it:kpl} different groups specified by variable {it:byvar_pl}.

{dlgtab:Format}

{phang}
{cmdab:fcolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of fill colors of the supplementary polygons. When suboption
   {opt by(byvar_pl)} is not specified, the list should include only one
   element. On the other hand, when suboption {opt by(byvar_pl)} is
   specified, the list should be either composed of {it:kpl} elements
   or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default fill color is
   {cmd:none}; the default specification is {cmd:fcolor(none{space 1}...)}.

{phang}
{cmdab:ocolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of outline colors of the supplementary polygons. When suboption
   {opt by(byvar_pl)} is not specified, the list should include only one
   element. On the other hand, when suboption {opt by(byvar_pl)} is
   specified, the list should be either composed of {it:kpl} elements
   or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default outline color is
   {cmd:black}; the default specification is {cmd:ocolor(black{space 1}...)}.

{phang}
{cmdab:osize(}{it:{help linewidthstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline thicknesses of the supplementary
   polygons. When suboption {opt by(byvar_pl)} is not specified, the
   list should include only one element. On the other hand, when
   suboption {opt by(byvar_pl)} is specified, the list should be
   composed of {it:kpl} elements. The default outline thickness is
   {cmd:thin}; the default specification is {cmd:osize(thin{space 1}...)}.

{phang}
{cmdab:opattern(}{it:{help linepatternstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline patterns of the supplementary
   polygons. When suboption {opt by(byvar_pl)} is not specified, the
   list should include only one element. On the other hand, when
   suboption {opt by(byvar_pl)} is specified, the list should be
   composed of {it:kpl} elements. The default outline pattern is
   {cmd:solid}; the default specification is
   {cmd:opattern(solid{space 1}...)}.

{phang}
{cmdab:oalign(}{it:{help linealignmentstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline alignments of the supplementary
   polygons. When suboption {opt by(byvar_pl)} is not specified, the
   list should include only one element. On the other hand, when
   suboption {opt by(byvar_pl)} is specified, the list should be
   composed of {it:kpl} elements. The default outline alignment is
   {cmd:center}; the default specification is
   {cmd:oalign(center ...)}.

{dlgtab:Legend}

{phang}
{cmdab:legenda(on}|{cmd:off)} specifies whether the supplementary-polygon
   legend should be displayed or hidden.

{phang2}{cmd:legenda(on)} requests that the supplementary-polygon legend
   be displayed.{p_end}

{phang2}{cmd:legenda(off)} is the default and requests that the
   supplementary-polygon legend be hidden.{p_end}

{phang}
{opt legtitle(string)} specifies the title of the supplementary-polygon
   legend. When suboption {opt by(byvar_pl)} is specified, suboption
   {cmd:legtitle(varlab)} requests that the label of variable {it:byvar_pl}
   be used as the legend title.

{phang}
{opt leglabel(string)} specifies the label to be attached to the single key of
   the supplementary-polygon legend when suboption {opt by(byvar_pl)} is not
   specified. This suboption is required when suboption {cmd:legenda(on)} is
   specified and suboption {opt by(byvar_pl)} is not specified.
   
{phang}
{opth legshow(numlist)} requests that, when suboption {opt by(byvar_pl)} is
   specified, only the keys included in {it:numlist} be displayed in the
   supplementary-polygon legend.

{phang}
{opt legcount} requests that the number of supplementary polygons be displayed
   in the legend.


{marker line2}{title:Option line() suboptions}

{dlgtab:Main}

{phang}
{cmdab:data(}{help grmap##sd_line:{it:line}{bf:.dta}}{cmd:)} requests that one
   or more polylines defined in Stata dataset {it:line} be superimposed
   onto the {help grmap##desc:base map}.

{phang}
{cmdab:select(}{help drop:{it:command}}{cmd:)} requests that a given subset
   of records of dataset {it:line} be selected using Stata commands
   {help drop:keep} or {help drop}.

{phang}
{cmdab:by(}{help varname:{it:byvar_ln}}{cmd:)} indicates that the
   polylines defined in dataset {it:line} belong to {it:kln} different
   groups specified by variable {it:byvar_ln}.

{dlgtab:Format}

{phang}
{cmdab:color(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of polyline colors. When suboption {opt by(byvar_ln)} is not specified,
   the list should include only one element. On the other hand, when suboption
   {opt by(byvar_ln)} is specified, the list should be either composed of
   {it:kln} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default color is {cmd:black};
   the default specification is {cmd:color(black{space 1}...)}.

{phang}
{cmdab:size(}{it:{help linewidthstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of polyline thicknesses. When suboption
   {opt by(byvar_ln)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ln)}
   is specified, the list should be composed of {it:kln} elements. The
   default thickness is {cmd:thin}; the default specification is
   {cmd:size(thin{space 1}...)}.

{phang}
{cmdab:pattern(}{it:{help linepatternstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of polyline patterns. When suboption
   {opt by(byvar_ln)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ln)}
   is specified, the list should be composed of {it:kln} elements. The
   default pattern is {cmd:solid}; the default specification is
   {cmd:pattern(solid{space 1}...)}.

{dlgtab:Legend}

{phang}
{cmdab:legenda(on}|{cmd:off)} specifies whether the polyline legend
   should be displayed or hidden.

{phang2}{cmd:legenda(on)} requests that the polyline legend be
   displayed.{p_end}

{phang2}{cmd:legenda(off)} is the default and requests that the
   polyline legend be hidden.{p_end}

{phang}
{opt legtitle(string)} specifies the title of the polyline legend. When
   suboption {opt by(byvar_ln)} is specified, suboption {cmd:legtitle(varlab)}
   requests that the label of variable {it:byvar_ln} be used as the legend
   title.

{phang}
{opt leglabel(string)} specifies the label to be attached to the single key of
   the polyline legend when suboption {opt by(byvar_ln)} is not specified. This
   suboption is required when suboption {cmd:legenda(on)} is specified and
   suboption {opt by(byvar_ln)} is not specified.

{phang}
{opth legshow(numlist)} requests that, when suboption {opt by(byvar_ln)} is
   specified, only the keys included in {it:numlist} be displayed in the
   polyline legend.

{phang}
{opt legcount} requests that the number of polylines be displayed in the
   legend.


{marker point2}{title:Option point() suboptions}

{dlgtab:Main}

{phang}
{cmdab:data(}{help grmap##sd_point:{it:point}{bf:.dta}}{cmd:)} requests that one
   or more points defined in Stata dataset {it:point} be superimposed
   onto the {help grmap##desc:base map}.

{phang}
{cmdab:select(}{help drop:{it:command}}{cmd:)} requests that a given subset
   of records of dataset {it:point} be selected using Stata commands
   {help drop:keep} or {help drop}.

{phang}
{cmdab:by(}{help varname:{it:byvar_pn}}{cmd:)} indicates that the
   points defined in dataset {it:point} belong to {it:kpn} different
   groups specified by variable {it:byvar_pn}.

{phang}
{cmdab:xcoord(}{help varname:{it:xvar_pn}}{cmd:)} specifies the name of
   the variable containing the x coordinate of each point.

{phang}
{cmdab:ycoord(}{help varname:{it:yvar_pn}}{cmd:)} specifies the name of
   the variable containing the y coordinate of each point.

{dlgtab:Proportional size}

{phang}
{cmd:proportional(}{help varname:{it:propvar_pn}}{cmd:)} requests that the
   point markers be drawn with size proportional to the values taken on by
   numeric variable {it:propvar_pn}.

{phang}
{opt prange(min max)} requests that variable {it:propvar_pn} specified in
   suboption {opt proportional(propvar_pn)} be normalized based on range
   [{it:min}, {it:max}]. This suboption overrides the default normalization
   based on range [0, max({it:propvar_pn})].

{phang}
{cmd:psize(relative}|{cmd:absolute)} specifies the reference system for
   drawing the point markers.

{phang2}{cmd:psize(relative)} is the default and requests that the point
   markers be drawn using relative minimum and maximum reference values. This
   is the best choice when there is no need to compare the map at hand with
   other maps of the same kind.{p_end}

{phang2}{cmd:psize(absolute)} requests that the point markers be drawn using
   absolute minimum and maximum reference values. This is the best choice when
   the map at hand is to be compared with other maps of the same kind.{p_end}

{dlgtab:Deviation}

{phang}
{cmd:deviation(}{help varname:{it:devvar_pn}}{cmd:)} requests that the
   point markers be drawn as deviations from a reference value of numeric
   variable {it:devvar_pn} specified in option {cmd:refval()}. When this
   suboption is specified, in the first place the values of variable
   {it:devvar_pn} are reexpressed as deviations from the chosen reference
   value. Then, points associated with positive deviations are represented
   by solid markers, whereas points associated with negative deviations are
   represented by hollow markers of the same shape; in both cases, markers
   are drawn with size proportional to the absolute value of the
   deviation. This suboption is incompatible with suboption
   {opt proportional(propvar_pn)}.

{phang}
{cmd:refval(}{cmd:mean}|{cmd:median}|{it:#}{cmd:)} specifies the reference
   value of variable {it:devvar_pn} for computing deviations.

{phang2}{cmd:refval(mean)} is the default and requests that the arithmetic
   mean of variable {it:devvar_pn} be taken as the reference value.{p_end}

{phang2}{cmd:refval(median)} requests that the median of variable
   {it:devvar_pn} be taken as the reference value.{p_end}

{phang2}{cmd:refval(}{it:#}{cmd:)} requests that an arbitrary real value
   {it:#} be taken as the reference value.{p_end}

{phang}
{cmd:refweight(}{help varname:{it:weightvar_pn}}{cmd:)} requests that the
   reference value of variable {it:devvar_pn} be computed weighting
   observations by values of variable {it:weightvar_pn}.

{phang}
{opt dmax(#)} requests that the point markers be drawn using value {it:#}
   as the maximum absolute deviation of reference.

{dlgtab:Format}

{phang}
{cmd:size(}{it:{help markersizestyle}_list}{cmd:)} specifies the
   {help stylelists:list} of point marker sizes. When suboption
   {opt by(byvar_pn)} is not specified, suboption
   {opt proportional(propvar_pn)} is specified, or suboption
   {opt deviation(devvar_pn)} is specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_pn)}
   is specified and neither suboption {opt proportional(propvar_pn)}
   or suboption {opt deviation(devvar_pn)} is specified, the list should be
   composed of {it:kpn} elements. The default size is {cmd:*1}; the
   default specification is {cmd:size(*1{space 1}...)}.

{phang}
{cmd:shape(}{it:{help symbolstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of point marker shapes. When suboption
   {opt by(byvar_pn)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_pn)}
   is specified, the list should be composed of {it:kpn} elements. The
   default shape is {cmd:o}; the default specification is
   {cmd:shape(o{space 1}...)}. When suboption {opt deviation(devvar_pn)}
   is specified, this suboption accepts only solid
   {help symbolstyle:{it:symbolstyles}} written in short
   form: {cmd:O D T S o d t s}.

{phang}
{cmd:fcolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of fill colors of the point markers. When suboption {opt by(byvar_pn)}
   is not specified, the list should include only one element. On the other
   hand, when suboption {opt by(byvar_pn)} is specified, the list should be
   either composed of {it:kpn} elements or represented by the name of a
   predefined {help grmap##colorscheme:color scheme}. The default fill color
   is {cmd:black}; the default specification is
   {cmd:fcolor(black{space 1}...)}.

{phang}
{cmd:ocolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of outline colors of the point markers. When suboption {opt by(byvar_pn)}
   is not specified, the list should include only one element. On the other
   hand, when suboption {opt by(byvar_pn)} is specified, the list should be
   either composed of {it:kpn} elements or represented by the name of a
   predefined {help grmap##colorscheme:color scheme}. The default outline
   color is {cmd:none}; the default specification is
   {cmd:ocolor(none{space 1}...)}.

{phang}
{cmd:osize(}{it:{help linewidthstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of outline thicknesses of the point markers. When
   suboption {opt by(byvar_pn)} is not specified, the list should include
   only one element. On the other hand, when suboption {opt by(byvar_pn)}
   is specified, the list should be composed of {it:kpl} elements. The default
   outline thickness is {cmd:thin}; the default specification is
   {cmd:osize(thin{space 1}...)}.

{dlgtab:Legend}

{phang}
{cmdab:legenda(on}|{cmd:off)} specifies whether the point legend
   should be displayed or hidden.

{phang2}{cmd:legenda(on)} requests that the point legend be
   displayed.{p_end}

{phang2}{cmd:legenda(off)} is the default and requests that the
   point legend be hidden.{p_end}

{phang}
{opt legtitle(string)} specifies the title of the point legend. When
   suboption {opt by(byvar_pn)} is specified, suboption {cmd:legtitle(varlab)}
   requests that the label of variable {it:byvar_pn} be used as the legend
   title.

{phang}
{opt leglabel(string)} specifies the label to be attached to the single key of
   the point legend when suboption {opt by(byvar_pn)} is not specified. This
   suboption is required when suboption {cmd:legenda(on)} is specified and
   suboption {opt by(byvar_pn)} is not specified.

{phang}
{opth legshow(numlist)} requests that, when suboption {opt by(byvar_pn)} is
   specified, only the keys included in {it:numlist} be displayed in the
   point legend.

{phang}
{opt legcount} requests that the number of points be displayed in the legend.


{marker diagram2}{title:Option diagram() suboptions}

{dlgtab:Main}

{phang}
{cmd:data(}{help grmap##sd_diagram:{it:diagram}{bf:.dta}}{cmd:)} requests that one
   or more diagrams defined in Stata dataset {it:diagram} be superimposed
   onto the {help grmap##desc:base map} at given reference points.

{phang}
{cmd:select(}{help drop:{it:command}}{cmd:)} requests that a given subset
   of records of dataset {it:diagram} be selected using Stata commands
   {help drop:keep} or {help drop}.

{phang}
{cmd:by(}{help varname:{it:byvar_dg}}{cmd:)} indicates that the
   diagrams defined in dataset {it:diagram} belong to {it:kdg} different
   groups specified by variable {it:byvar_dg}. This option is active only
   when just one variable is specified in suboption
   {opt variables(diagvar_dg)}.

{phang}
{cmd:xcoord(}{help varname:{it:xvar_dg}}{cmd:)} specifies the name of
   the variable containing the x coordinate of each diagram reference
   point.

{phang}
{cmd:ycoord(}{help varname:{it:yvar_dg}}{cmd:)} specifies the name of
   the variable containing the y coordinate of each diagram reference
   point.

{phang}
{cmd:variables(}{help varname:{it:diagvar_dg}}{cmd:)} specifies the list of
   variables to be represented by the diagrams.

{phang}
{cmd:type(frect}|{cmd:pie)} specifies the type of diagram to be used.

{phang2}{cmd:type(frect)} is the default when only one variable is specified
   in suboption {opt variables(diagvar_dg)} and requests that framed-rectangle
   charts (Cleveland and McGill 1984; Cleveland 1994) be used.{p_end}

{phang2}{cmd:type(pie)} is the default (and the only possibility) when two
   or more variables are specified in suboption {opt variables(diagvar_dg)}
   and requests that pie charts be used. When option {cmd:type(pie)} is
   specified, the variables specified in suboption {opt variables(diagvar_dg)}
   are rescaled so that they sum to 1 within each observation.{p_end}

{dlgtab:Proportional size}

{phang}
{cmdab:proportional(}{help varname:{it:propvar_dg}}{cmd:)} requests that the
   diagrams be drawn with size proportional to the values taken on by
   numeric variable {it:propvar_dg}.

{phang}
{opt prange(min max)} requests that variable {it:propvar_dg} specified in
   suboption {opt proportional(propvar_dg)} be normalized based on range
   [{it:min}, {it:max}]. This suboption overrides the default normalization
   based on range [0, max({it:propvar_dg})].

{dlgtab:Framed-rectangle chart}

{phang}
{opt range(min max)} requests that variable {it:diagvar_dg} specified in
   suboption {opt variables(diagvar_dg)} be normalized based on range
   [{it:min}, {it:max}]. This suboption overrides the default normalization
   based on range [0, max({it:diagvar_dg})].

{phang}
{cmd:refval(}{cmd:mean}|{cmd:median}|{it:#}{cmd:)} specifies the reference
   value of variable {it:diagvar_dg} for drawing the reference line.

{phang2}{cmd:refval(mean)} is the default and requests that the arithmetic
   mean of variable {it:diagvar_dg} be taken as the reference value.{p_end}

{phang2}{cmd:refval(median)} requests that the median of variable
   {it:diagvar_dg} be taken as the reference value.{p_end}

{phang2}{cmd:refval(}{it:#}{cmd:)} requests that an arbitrary real value
   {it:#} be taken as the reference value.{p_end}

{phang}
{cmdab:refweight(}{help varname:{it:weightvar_dg}}{cmd:)} requests that the
   reference value of variable {it:diagvar_dg} be computed weighting
   observations by values of variable {it:weightvar_dg}.

{phang}
{opth refcolor(colorstyle)} specifies the color of the reference line. The
   default is {cmd:refcolor(black)}.

{phang}
{opth refsize(linewidthstyle)} specifies the thickness of the reference
   line. The default is {cmd:refsize(medium)}.

{dlgtab:Format}

{phang}
{opt size(#)} specifies a multiplier that affects the size of the
   diagrams. For example, {cmd:size(1.5)} requests that the default size
   of all the diagrams be increased by 50%. The default is {cmd:size(1)}.

{phang}
{cmdab:fcolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of fill colors of the diagrams. When just one variable is specified in
   suboption {opt variables(diagvar_dg)} and suboption {opt by(byvar_dg)} is
   not specified, the list should include only one element. When just one
   variable is specified in suboption {opt variables(diagvar_dg)} and
   suboption {opt by(byvar_dg)} is specified, the list should be either
   composed of {it:kdg} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. Finally, when {it:J}>1 variables
   are specified in suboption {opt variables(diagvar_dg)}, the list should
   be either composed of {it:J} elements or represented by the name of a
   predefined {help grmap##colorscheme:color scheme}. The default fill color
   is {cmd:black}, the default specification when {it:J}=1 is
   {cmd:fcolor(black{space 1}...)}, and the default specification when
   {it:J}>1 is {cmd:fcolor(red blue orange green lime navy sienna ltblue}
   {cmd:cranberry emerald eggshell magenta olive brown yellow dkgreen)}.

{phang}
{cmdab:ocolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of outline colors of the diagrams. When just one variable is specified in
   suboption {opt variables(diagvar_dg)} and suboption {opt by(byvar_dg)} is
   not specified, the list should include only one element. When just one
   variable is specified in suboption {opt variables(diagvar_dg)} and
   suboption {opt by(byvar_dg)} is specified, the list should be either
   composed of {it:kdg} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. Finally, when {it:J}>1 variables
   are specified in suboption {opt variables(diagvar_dg)}, the list should
   be either composed of {it:J} elements or represented by the name of a
   predefined {help grmap##colorscheme:color scheme}. The default fill color
   is {cmd:black}; the default specification is {cmd:ocolor(black{space 1}...)}.

{phang}
{cmdab:osize(}{it:{help linewidthstyle}_list}{cmd:)} specifies the list of
   outline thicknesses of the diagrams. When just one variable is specified
   in suboption {opt variables(diagvar_dg)} and suboption {opt by(byvar_dg)}
   is not specified, the list should include only one element. When just one
   variable is specified in suboption {opt variables(diagvar_dg)} and
   suboption {opt by(byvar_dg)} is specified, the list should be composed
   of {it:kdg} elements. Finally, when {it:J}>1 variables are specified in
   suboption {opt variables(diagvar_dg)}, the list should be composed of
   {it:J} elements. The default outline thickness is {cmd:thin}, the default
   specification is {cmd:osize(thin{space 1}...)}.

{dlgtab:Legend}

{phang}
{cmdab:legenda(on}|{cmd:off)} specifies whether the diagram legend
   should be displayed or hidden.

{phang2}{cmd:legenda(on)} requests that the diagram legend be
   displayed.{p_end}

{phang2}{cmd:legenda(off)} is the default and requests that the
   point diagram be hidden.{p_end}

{phang}
{opt legtitle(string)} specifies the title of the diagram legend. When just
   one variable is specified in suboption {opt variables(diagvar_dg)},
   suboption {cmd:legtitle(varlab)} requests that the label of variable
   {it:diagvar_dg} be used as the legend title.

{phang}
{opth legshow(numlist)} requests that only the keys included in {it:numlist}
   be displayed in the diagram legend.

{phang}
{opt legcount} requests that the number of diagrams be displayed in the legend.


{marker arrow2}{title:Option arrow() suboptions}

{dlgtab:Main}

{phang}
{cmdab:data(}{help grmap##sd_arrow:{it:arrow}{bf:.dta}}{cmd:)} requests that one
   or more arrows defined in Stata dataset {it:arrow} be superimposed
   onto the {help grmap##desc:base map}.

{phang}
{cmdab:select(}{help drop:{it:command}}{cmd:)} requests that a given subset
   of records of dataset {it:arrow} be selected using Stata commands
   {help drop:keep} or {help drop}.

{phang}
{cmdab:by(}{help varname:{it:byvar_ar}}{cmd:)} indicates that the
   arrows defined in dataset {it:arrow} belong to {it:kar} different
   groups specified by variable {it:byvar_ar}.

{dlgtab:Format}

{phang}
{opt direction(directionstyle_list)} specifies the {help stylelists:list} of
   arrow directions, where {it:directionstyle} is one of the following:
   {cmd:1} (monodirectional arrow) or {cmd:2} (bidirectional arrow). When
   suboption {opt by(byvar_ar)} is not specified, the list should include
   only one element. On the other hand, when suboption {opt by(byvar_ar)} is
   specified, the list should be composed of {it:kar} elements. The default
   direction is {cmd:1}; the default specification is
   {cmd:direction(1{space 1}...)}.

{phang}
{cmdab:hsize(}{it:{help markersizestyle}_list}{cmd:)} specifies the
   {help stylelists:list} of arrowhead sizes. When suboption
   {opt by(byvar_ar)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ar)}
   is specified, the list should be composed of {it:kar} elements. The
   default size is {cmd:1.5}; the default specification is
   {cmd:hsize(1.5{space 1}...)}.

{phang}
{cmdab:hangle(}{it:{help anglestyle}_list}{cmd:)}  specifies the
   {help stylelists:list} of arrowhead angles. When suboption
   {opt by(byvar_ar)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ar)}
   is specified, the list should be composed of {it:kar} elements. The
   default angle is {cmd:28.64}; the default specification is
   {cmd:hangle(28.64{space 1}...)}.

{phang}
{cmdab:hbarbsize(}{it:{help markersizestyle}_list}{cmd:)}  specifies the
   {help stylelists:list} of sizes of the filled portion of arrowheads. When
   suboption {opt by(byvar_ar)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ar)} is
   specified, the list should be composed of {it:kar} elements. The default
   size is {cmd:1.5}; the default specification is
   {cmd:hbarbsize(1.5{space 1}...)}.

{phang}
{cmdab:hfcolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of arrowhead fill colors. When suboption {opt by(byvar_ar)} is not
   specified, the list should include only one element. On the other hand,
   when suboption {opt by(byvar_ar)} is specified, the list should be either
   composed of {it:kar} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default fill color is
   {cmd:black}; the default specification is {cmd:hfcolor(black{space 1}...)}.

{phang}
{cmdab:hocolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of arrowhead outline colors. When suboption {opt by(byvar_ar)} is not
   specified, the list should include only one element. On the other hand,
   when suboption {opt by(byvar_ar)} is specified, the list should be either
   composed of {it:kar} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default outline color is
   {cmd:black}; the default specification is {cmd:hocolor(black{space 1}...)}.

{phang}
{cmdab:hosize(}{it:{help linewidthstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of arrowhead outline thicknesses. When suboption
   {opt by(byvar_ar)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ar)}
   is specified, the list should be composed of {it:kar} elements. The
   default outline thickness is {cmd:thin}; the default specification is
   {cmd:hosize(thin{space 1}...)}.

{phang}
{cmdab:lcolor(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of arrow shaft line colors. When suboption {opt by(byvar_ar)} is not
   specified, the list should include only one element. On the other hand,
   when suboption {opt by(byvar_ar)} is specified, the list should be either
   composed of {it:kar} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default color is {cmd:black};
   the default specification is {cmd:lcolor(black{space 1}...)}.

{phang}
{cmdab:lsize(}{it:{help linewidthstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of arrow shaft line thicknesses. When suboption
   {opt by(byvar_ar)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ar)}
   is specified, the list should be composed of {it:kar} elements. The
   default thickness is {cmd:thin}; the default specification is
   {cmd:lsize(thin{space 1}...)}.

{phang}
{cmdab:lpattern(}{it:{help linepatternstyle}_list}{cmd:)} specifies the
   {help stylelists:list} of arrow shaft line patterns. When suboption
   {opt by(byvar_ar)} is not specified, the list should include only
   one element. On the other hand, when suboption {opt by(byvar_ar)}
   is specified, the list should be composed of {it:kar} elements. The
   default pattern is {cmd:solid}; the default specification is
   {cmd:lpattern(solid{space 1}...)}.

{dlgtab:Legend}

{phang}
{cmdab:legenda(on}|{cmd:off)} specifies whether the arrow legend
   should be displayed or hidden.

{phang2}{cmd:legenda(on)} requests that the arrow legend be
   displayed.{p_end}

{phang2}{cmd:legenda(off)} is the default and requests that the
   arrow legend be hidden.{p_end}

{phang}
{opt legtitle(string)} specifies the title of the arrow legend. When
   suboption {opt by(byvar_ar)} is specified, suboption {cmd:legtitle(varlab)}
   requests that the label of variable {it:byvar_ar} be used as the legend
   title.

{phang}
{opt leglabel(string)} specifies the label to be attached to the single key of
   the arrow legend when suboption {opt by(byvar_ar)} is not specified. This
   suboption is required when suboption {cmd:legenda(on)} is specified and
   suboption {opt by(byvar_ar)} is not specified.

{phang}
{opth legshow(numlist)} requests that, when suboption {opt by(byvar_ar)} is
   specified, only the keys included in {it:numlist} be displayed in the
   arrow legend.

{phang}
{opt legcount} requests that the number of arrows be displayed in the
   legend.


{marker label2}{title:Option label() suboptions}

{dlgtab:Main}

{phang}
{cmdab:data(}{help grmap##sd_label:{it:label}{bf:.dta}}{cmd:)} requests that one
   or more labels defined in Stata dataset {it:label} be superimposed
   onto the {help grmap##desc:base map} at given reference points.

{phang}
{cmdab:select(}{help drop:{it:command}}{cmd:)} requests that a given subset
   of records of dataset {it:label} be selected using Stata commands
   {help drop:keep} or {help drop}.

{phang}
{cmdab:by(}{help varname:{it:byvar_lb}}{cmd:)} indicates that the
   labels defined in dataset {it:label} belong to {it:klb} different
   groups specified by variable {it:byvar_lb}.

{phang}
{cmdab:xcoord(}{help varname:{it:xvar_lb}}{cmd:)} specifies the name of
   the variable containing the x coordinate of each label reference
   point.

{phang}
{cmdab:ycoord(}{help varname:{it:yvar_lb}}{cmd:)} specifies the name of
   the variable containing the y coordinate of each label reference
   point.

{phang}
{cmdab:label(}{help varname:{it:labvar_lb}}{cmd:)} specifies the name of
   the variable containing the labels.

{dlgtab:Format}

{phang}
{opt length(lengthstyle_list)} specifies the {help stylelists:list} of
   label lengths, where {it:lengthstyle} is any integer greater than 0
   indicating the maximum number of characters of the labels. When
   suboption {opt by(byvar_lb)} is not specified, the list should include
   only one element. On the other hand, when suboption {opt by(byvar_lb)} is
   specified, the list should be composed of {it:klb} elements. The default
   label length is {cmd:12}; the default specification is {cmd:length(12 ...)}.

{phang}
{cmdab:size(}{it:{help textsizestyle}_list}{cmd:)} specifies the
   {help stylelists:list} of label sizes. When suboption {opt by(byvar_lb)}
   is not specified, the list should include only one element. On the other
   hand, when suboption {opt by(byvar_lb)} is specified, the list should be
   composed of {it:klb} elements. The default label size is {cmd:*1}; the
   default specification is {cmd:size(*1 ...)}.

{phang}
{cmdab:color(}{help grmap##color:{it:colorlist}}{cmd:)} specifies the list
   of label colors. When suboption {opt by(byvar_lb)} is not specified, the
   list should include only one element. On the other hand, when suboption
   {opt by(byvar_lb)} is specified, the list should be either composed of
   {it:klb} elements or represented by the name of a predefined
   {help grmap##colorscheme:color scheme}. The default label color is
   {cmd:black}; the default specification is {cmd:color(black ...)}.

{phang}
{cmdab:position(}{it:{help clockpos}_list}{cmd:)} specifies the
   {help stylelists:list} of label positions relative to their reference
   point. When suboption {opt by(byvar_lb)} is not specified, the list
   should include only one element. On the other hand, when suboption
   {opt by(byvar_lb)} is specified, the list should be composed of {it:klb}
   elements. The default label position is {cmd:0}; the default specification
   is {cmd:position(0 ...)}.

{phang}
{cmdab:gap(}{it:{help size}_list}{cmd:)} specifies the
   {help stylelists:list} of gaps between labels and their reference
   point. When suboption {opt by(byvar_lb)} is not specified, the list
   should include only one element. On the other hand, when suboption
   {opt by(byvar_lb)} is specified, the list should be composed of {it:klb}
   elements. The default label gap is {cmd:*1}; the default specification
   is {cmd:gap(*1 ...)}.

{phang}
{cmdab:angle(}{it:{help anglestyle}_list}{cmd:)} specifies the
   {help stylelists:list} of label angles. When suboption {opt by(byvar_lb)}
   is not specified, the list should include only one element. On the other
   hand, when suboption {opt by(byvar_lb)} is specified, the list should be
   composed of {it:klb} elements. The default label angle is {cmd:horizontal};
   the default specification is {cmd:angle(horizontal ...)}.


{marker scalebar2}{title:Option scalebar() suboptions}

{dlgtab:Main}

{phang}
{opt units(#)} specifies the length of the scale bar expressed in
   arbitrary units.

{phang}
{opt scale(#)} specifies the ratio of scale bar units to map units. For
   example, suppose map coordinates are expressed in meters: if the scale
   bar length is to be expressed in meters too, then the ratio of scale
   bar units to map units will be 1; if, on the other hand, the scale
   bar length is to be expressed in kilometers, then the ratio of scale
   bar units to map units will be 1/1000. The default is {cmd:scale(1)}.

{phang}
{opt xpos(#)} specifies the distance of the scale bar from the center
   of the {help region_options:plot region} on the horizontal axis,
   expressed as percentage of half the total width of the
   {help region_options:plot region}. Positive values request that the
   distance be computed from the center to the right, whereas negative
   values request that the distance be computed from the center to the
   left. The default is {cmd:xpos(0)}.

{phang}
{opt ypos(#)} specifies the distance of the scale bar from the center
   of the {help region_options:plot region} on the vertical axis,
   expressed as percentage of half the total height of the
   {help region_options:plot region}. Positive values request that the
   distance be computed from the center to the top, whereas negative
   values request that the distance be computed from the center to the
   bottom. The default is {cmd:ypos(-110)}.

{dlgtab:Format}

{phang}
{opt size(#)} specifies a multiplier that affects the height of the
   scale bar. For example, {cmd:size(1.5)} requests that the default
   height of the scale bar be increased by 50%. The default is
   {cmd:size(1)}.

{phang}
{opth fcolor(colorstyle)} specifies the fill color of the scale bar. The
   default is {cmd:fcolor(black)}.

{phang}
{opth ocolor(colorstyle)} specifies the outline color of the scale bar. The
   default is {cmd:ocolor(black)}.

{phang}
{opth osize(linewidthstyle)} specifies the outline thickness of the scale
   bar. The default is {cmd:osize(vthin)}.

{phang}
{opt label(string)} specifies the descriptive label of the scale bar. The
   default is {cmd:label(Units)}.

{phang}
{opth oalign(linealignmentstyle)} specifies whether the scale bar is drawn
inside, is drawn outside, or is centered.  The default is
{cmd:oalign(center)}.

{phang}
{opth tcolor(colorstyle)} specifies the color of the scale bar text. The
   default is {cmd:tcolor(black)}.

{phang}
{opth tsize(textsizestyle)} specifies the size of the scale bar text. The
   default is {cmd:tsize(*1)}.

{phang}
{opth talign(linealignmentstyle)} specifies whether the scale bar text is
drawn inside, is drawn outside, or is centered.  The default is
{cmd:talign(center)}.


{marker graph2}{title:Graph options}

{dlgtab:Main}

{phang}
{opt polyfirst} requests that the supplementary polygons specified in option
   {cmd:polygon()} be drawn before the base map. By default, the base map
   is drawn before any other spatial object.

{phang}
{opt gsize(#)} specifies the length (in inches) of the shortest side of the
   graph {it: available area} (the length of the longest side is set
   internally by {cmd:grmap} to minimize the amount of blank space around
   the map). The default ranges from 1 to 4, depending on the aspect ratio
   of the map. Alternatively, the height and width of the graph
   {it: available area} can be set using the standard
   {bf:{help region_options:xsize()}} and {bf:{help region_options:ysize()}}
   options.

{phang}
{opt freestyle} requests that, when drawing the graph, all the formatting
   presets and restrictions built in {cmd:grmap} be ignored. By default,
   {cmd:grmap} presets the values of some graph options and restricts the
   use of some others, so as to produce a "nice" graph automatically. By
   specifying option {cmd:freestyle}, the user loses this feature but gains
   full control over most of the graph formatting options.

{phang}
{it:{help twoway_options}} include all the options documented in
   {bind:{bf:[G] {it:twoway_options}}}, except for
   {it:aspect_option}, {it:scheme_option}, {it:by_option}, and
   {it:advanced_options}. These include {it:{help added_line_options}},
   {it:{help added_text_options}}, {it:{help axis_options}},
   {it:{help title_options}}, {it:{help legend_option}},
   and {it:{help region_options}},
   as well as options {bf:{help nodraw_option:nodraw}},
   {bf:{help name_option:name()}}, and {bf:{help saving_option:saving()}}. When
   option {cmd:freestyle} is specified, it is possible to control also
   {it:{help aspect_option}} and {it:{help scheme_option}}.


{marker examples}{...}
{title:Examples}

{pstd}
In order to use {bf:grmap}, activate it by clicking on or typing
{bf:{stata grmap, activate}}.

{pstd}
Click {stata grmap_copy:here} to get a copy of all datasets used
in the following examples.
The datasets will be put in the current working directory.


{title:Examples 1: Choropleth maps}
{cmd}
    . use "italy-regionsdata.dta", clear
    . grmap relig1

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(2) legend(region(lcolor(black)))                        

    . use "italy-regionsdata.dta", clear
    . grmap relig1m,                                                     ///
        ndfcolor(red)                                                    ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(2) legend(region(lcolor(black)))                        

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clmethod(eqint) clnumber(5) eirange(20 70)                       ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(2) legend(region(lcolor(black)))                        

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clnumber(20) fcolor(Reds2) ocolor(none ..)                       ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(3)                                                      

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clnumber(20) fcolor(Reds2) ocolor(none ..)                       ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(3) legend(ring(1) position(3))                          

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clnumber(20) fcolor(Reds2) ocolor(none ..)                       ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(3) legend(ring(1) position(3))                          ///
        plotregion(margin(vlarge))                                       

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clnumber(20) fcolor(Reds2) ocolor(none ..)                       ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(3) legend(ring(1) position(3))                          ///
        plotregion(icolor(stone)) graphregion(icolor(stone))

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clnumber(20) fcolor(Greens2) ocolor(white ..) osize(medthin ..)  ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(3) legend(ring(1) position(3))                          ///
        plotregion(icolor(stone)) graphregion(icolor(stone))

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
        clnumber(20) fcolor(Greens2) ocolor(white ..) osize(thin ..)     ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        legstyle(3) legend(ring(1) position(3))                          ///
        plotregion(icolor(stone)) graphregion(icolor(stone))             ///
        polygon(data("italy-highlights.dta") ocolor(white)               ///
        osize(medthick))

    . use "italy-regionsdata.dta", clear
    . grmap relig1,                                                      ///
      clnumber(20) fcolor(Greens2) ocolor(white ..) osize(medthin ..)    ///
      title("Pct. Catholics without reservations", size(*0.8))           ///
      subtitle("Italy, 1994-98" " ", size(*0.8))                         ///
      legstyle(3) legend(ring(1) position(3))                            ///
      plotregion(icolor(stone)) graphregion(icolor(stone))               ///
      scalebar(units(500) scale(1/1000) xpos(-100) label(Kilometers))
{reset}

{title:Examples 2: Proportional symbol maps}
{cmd}
    . use "italy-outlinedata.dta", clear
    . grmap,                                                             ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) proportional(relig1) fcolor(red) size(*1.5))

    . use "italy-outlinedata.dta", clear
    . grmap,                                                             ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) proportional(relig1) fcolor(red) size(*1.5)       ///
        shape(s))

    . use "italy-outlinedata.dta", clear
    . grmap,                                                             ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) proportional(relig1) fcolor(red)                  ///
        ocolor(white) size(*3))                                          ///
        label(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) label(relig1) color(white) size(*0.7))

    . use "italy-outlinedata.dta", clear
    . grmap,                                                             ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) deviation(relig1) fcolor(red) dmax(30)            ///
        legenda(on) leglabel(Deviation from the mean))

    . use "italy-outlinedata.dta", clear
    . grmap, fcolor(white)                                               ///
        title("Catholics without reservations", size(*0.9) box bexpand   ///
        span margin(medsmall) fcolor(sand)) subtitle(" ")                ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) proportional(relig1) prange(0 70)                 ///
        psize(absolute) fcolor(red) ocolor(white) size(*0.6))            ///
        plotregion(margin(medium) color(stone))                          ///
        graphregion(fcolor(stone) lcolor(black))                         ///
        name(g1, replace) nodraw
    . grmap, fcolor(white)                                               ///
        title("Catholics with reservations", size(*0.9) box bexpand      ///
        span margin(medsmall) fcolor(sand)) subtitle(" ")                ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) proportional(relig2) prange(0 70)                 ///
        psize(absolute) fcolor(green) ocolor(white) size(*0.6))          ///
        plotregion(margin(medium) color(stone))                          ///
        graphregion(fcolor(stone) lcolor(black))                         ///
        name(g2, replace) nodraw
    . grmap, fcolor(white)                                               ///
        title("Other", size(*0.9) box bexpand                            ///
        span margin(medsmall) fcolor(sand)) subtitle(" ")                ///
        point(data("italy-regionsdata.dta") xcoord(xcoord)               ///
        ycoord(ycoord) proportional(relig3) prange(0 70)                 ///
        psize(absolute) fcolor(blue) ocolor(white) size(*0.6))           ///
        plotregion(margin(medium) color(stone))                          ///
        graphregion(fcolor(stone) lcolor(black))                         ///
        name(g3, replace) nodraw
    . graph combine g1 g2 g3, rows(1) title("Religious orientation")     ///
        subtitle("Italy, 1994-98" " ") xsize(5) ysize(2.6)               ///
        plotregion(margin(medsmall) style(none))                         ///
        graphregion(margin(zero) style(none))                            ///
        scheme(s1mono)
{reset}

{title:Examples 3: Other maps}
{cmd}
    . use "italy-regionsdata.dta", clear
    . grmap, fcolor(stone)                                               ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8))                       ///
        diagram(variable(relig1) range(0 100) refweight(pop98)           ///
        xcoord(xcoord) ycoord(ycoord) fcolor(red))

    . use "italy-regionsdata.dta", clear
    . grmap, fcolor(stone)                                               ///
        diagram(variable(relig1 relig2 relig3) proportional(fortell)     ///
        xcoord(xcoord) ycoord(ycoord) legenda(on))                       ///
        legend(title("Religious orientation", size(*0.5) bexpand         ///
        justification(left)))                                            ///
        note(" "                                                         ///
        "NOTE: Chart size proportional to number of fortune tellers per million population", ///
        size(*0.75))

    . use "italy-regionsdata.dta", clear
    . grmap,                                                             ///
        clmethod(stdev) clnumber(5)                                      ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8)) area(pop98)           ///
        note(" "                                                         ///
        "NOTE: Region size proportional to population", size(*0.75))

    . use "italy-regionsdata.dta", clear
    . grmap,                                                             ///
        clmethod(stdev) clnumber(5)                                      ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Italy, 1994-98" " ", size(*0.8)) area(pop98)           ///
        map("italy-outlinecoordinates.dta") mfcolor(stone)               ///
        note(" "                                                         ///
        "NOTE: Region size proportional to population", size(*0.75))

    . use "italy-outlinedata.dta", clear
    . grmap, fc(bluishgray)                                              ///
        ocolor(none)                                                     ///
        title("Provincial capitals" " ", size(*0.9) color(white))        ///
        point(data("italy-capitals.dta") xcoord(xcoord)                  ///
        ycoord(ycoord) fcolor(emerald))                                  ///
        plotregion(margin(medium) icolor(dknavy) color(dknavy))          ///
        graphregion(icolor(dknavy) color(dknavy))

    . use "italy-outlinedata.dta", clear
    . grmap, fc(bluishgray)                                              ///
        ocolor(none)                                                     ///
        title("Provincial capitals" " ", size(*0.9) color(white))        ///
        point(data("italy-capitals.dta") xcoord(xcoord)                  ///
        ycoord(ycoord) by(size) fcolor(orange red maroon) shape(s ..)    ///
        legenda(on))                                                     ///
        legend(title("Population 1998", size(*0.5) bexpand               ///
        justification(left)) region(lcolor(black) fcolor(white))         ///
        position(2))                                                     ///
        plotregion(margin(medium) icolor(dknavy) color(dknavy))          ///
        graphregion(icolor(dknavy) color(dknavy))

    . use "italy-outlinedata.dta", clear
    . grmap, fc(sand)                                                    ///
        title("Main lakes and rivers" " ", size(*0.9))                   ///
        polygon(data("italy-lakes.dta") fcolor(blue) ocolor(blue))       ///
        line(data("italy-rivers.dta") color(blue) )

    . use "italy-regionsdata.dta", clear
    . grmap relig1 if zone==1,                                           ///
        fcolor(Blues2) ocolor(white ..) osize(medthin ..)                ///
        title("Pct. Catholics without reservations", size(*0.8))         ///
        subtitle("Northern Italy, 1994-98" " ", size(*0.8))              ///
        polygon(data("italy-outlinecoordinates.dta") fcolor(gs12)        ///
        ocolor(white) osize(medthin)) polyfirst

    . use "italy-outlinedata.dta", clear
    . grmap, fc(sand)                                                    ///
        title("Main lakes and rivers" " ", size(*0.9))                   ///
        polygon(data("italy-lakes.dta") fcolor(blue) ocolor(blue))       ///
        line(data("italy-rivers.dta") color(blue) )                      ///
        freestyle aspect(1.4) xlab(400000 900000 1400000, grid)
{reset}

{marker references}{...}
{title:References}

{p 4 8 2}Armstrong, M.P., Xiao, N. and D.A. Bennett. 2003. Using genetic
algorithms to create multicriteria class intervals for choropleth
maps. {it:Annals of the Association of American Geographers} 93: 595{c -}623.

{p 4 8 2}Brewer, C.A. 1999. Color use guidelines for data
representation. {it:Proceedings of the Section on Statistical }
{it: Graphics, American Statistical Association}. Alexandria VA,
55{c -}60.

{p 4 8 2}Brewer, C.A., Hatchard, G.W. and M.A. Harrower. 2003. ColorBrewer
in print: A catalog of color schemes for maps. {it:Cartography and Geographic}
{it:Information Science} 30: 5{c -}32.

{p 4 8 2}Cleveland, W.S. 1994. {it:The Elements of Graphing Data}. Summit: Hobart
Press.

{p 4 8 2}Cleveland, W.S. and R. McGill. 1984. Graphical perception: Theory,
experimentation, and application to the development of graphical
methods. {it:Journal of the American Statistical Association} 79: 531{c -}554.

{p 4 8 2}Evans, I.S. 1977. The selection of class
intervals. {it:Transactions of the Institute of British Geographers}
2: 98{c -}124.

{p 4 8 2}Olson, J.M. 1976. Noncontiguous area
cartograms. {it:The Professional Geographer} 28: 371{c -}380.

{marker P2004}{...}
{p 4 8 2}Pisati, M. 2004.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=gr0008":Simple thematic mapping}.
{it:Stata Journal} 4: 361{c -}378.

{marker P2007}{...}
{p 4 8 2}------. 2007.
spmap: Stata module to visualize spatial data. Statistical Software
Components S456812, Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s456812.html"}.

{p 4 8 2}Slocum, T.A., McMaster, R.B., Kessler, F.C and
H.H. Howard. 2005. {it:Thematic Cartography and Geographic Visualization}. 2nd
ed. Upper Saddle River: Pearson Prentice Hall.
