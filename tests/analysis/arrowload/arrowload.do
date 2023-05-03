. arrowload "output/data.arrow"

. desc

// list first line
list in 1, abbreviate(10) noobs clean compress
// list first line, big only
list big_val in 1, abbreviate(10) noobs clean compress

// list first line with human-readable date
format %td date
list in 1, abbreviate(10) noobs clean compress
list in 4, abbreviate(10) noobs clean compress
