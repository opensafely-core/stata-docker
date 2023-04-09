// load feather file with max_chunksize of 600 (1000 rows in file)
. arrowload output/data.arrow 600

. desc

// list first line
list in 1, abbreviate(10) noobs clean

// list first line with human-readable date
format %td date
list in 1, abbreviate(10) noobs clean
list in 4, abbreviate(10) noobs clean
