!gunzip output/input.csv.gz
// now import the uncompressed csv using delimited
import delimited using output/input.csv
// save in compressed dta.gz format
gzsave output/model.dta.gz
