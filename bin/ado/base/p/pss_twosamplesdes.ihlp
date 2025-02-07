{* *! version 1.0.4  27feb2019}{...}
{phang}
{opth n(numlist)} specifies the total number of subjects in the study to be
used for power or effect-size determination.  If {cmd:n()} is specified, the
power is computed.  If {cmd:n()} and {cmd:power()} or {cmd:beta()} are
specified, the minimum effect size that is likely to be detected in a study is
computed.

{phang}
{opth n1(numlist)} specifies the number of subjects in the control group to be
used for power or effect-size determination.

{phang}
{opth n2(numlist)} specifies the number of subjects in the experimental group
to be used for power or effect-size determination.

{phang}
{opth nratio(numlist)} specifies the sample-size ratio of the experimental
group relative to the control group, {cmd:N2/N1}, for two-sample tests.
The default is {cmd:nratio(1)}, meaning equal allocation between the two
groups.

{phang}
{cmd:compute(N1}|{cmd:N2)} requests that the {cmd:power} command compute one
of the group sample sizes given the other one, instead of the total sample
size, for two-sample tests.  To compute the control-group sample size, you
must specify {cmd:compute(N1)} and the experimental-group sample size in
{cmd:n2()}.  Alternatively, to compute the experimental-group sample size, you
must specify {cmd:compute(N2)} and the control-group sample size in
{cmd:n1()}.

{phang}
{cmd:nfractional} specifies that fractional sample sizes be allowed.  When
this option is specified, fractional sample sizes are used in the intermediate
computations and are also displayed in the output.
{p_end}
