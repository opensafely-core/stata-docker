* Create a simple dataset
set obs 10  // Create 10 observations
gen x = _n  // Create variable x as the observation number
gen y = x^2 // Create variable y as x squared

* Generate a scatterplot of y vs. x
graph twoway scatter y x, title("Test Graph") xlabel(, grid) ylabel(, grid)

* Save the graph as a file
graph export "test.eps", replace

* convert to png using convert utility
! convert test.eps test.png
