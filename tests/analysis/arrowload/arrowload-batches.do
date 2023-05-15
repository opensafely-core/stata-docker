. arrowload "output/data_multiple_batches.arrow"

. desc

// boolean and category values
list b1 c1 c1a in f/2, abbreviate(10) clean
list b1 c1 c1a in 100000, abbreviate(10) clean

// date and timestamp values with human-readable date
format %td d1 d1a
format %tc t1 t1a
list d1 d1a t1 t1a in f/2, abbreviate(10) clean
list d1 d1a t1 t1a in 100000, abbreviate(10) clean

// byte, int, long
list i1 i1a i2 i2a i3 i3a in f/2, abbreviate(10) clean
list i1 i1a i2 i2a i3 i3a in 100000, abbreviate(10) clean

// int64 and string equivalent (converted to string)
list i4 s1 in f/2, abbreviate(10) clean
list i4 s1 in 100000, abbreviate(10) clean
