. arrowload "output/data_multiple_batches.arrow", configfile("configfiles/aliases.csv")

. desc

// s1, aliased_s1, aliased_i3a
list s1 aliased_s1 aliased_i3a in f/2, abbreviate(10) clean
list s1 aliased_s1 aliased_i3a in 100000, abbreviate(10) clean
