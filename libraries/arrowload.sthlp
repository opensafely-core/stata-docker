Arrowload
---------

    arrowload -- Load an arrow file


Syntax
------

        arrowload filename [, options]

    options               Description
    ---------------------------------------------------------------------------------
    Main
      aliases(path/to/csv/file)    A csv file mapping original variable names to aliases
      chunksize(#)                 Specify the batch size to use when loading the arrow
                                   file; default is chunksize(64000)
    ---------------------------------------------------------------------------------


Description
-----------

    arrowload loads an arrow file


Options
-------

        +------+
    ----+ Main +---------------------------------------------------------------------

    aliases allows mapping of original variable names in the arrow file to aliased names.
        This can be used if the input arrow file contains variable names that are too
        long for use in stata. However, it is preferable fix the input file to use valid
        names. Some or all variable names can be mapped.

    chunksize allows a different max chunksize to be used when reading arrow files.
        Defaults to 64000.


Examples
--------

    . arrowload "/workspace/dataset.arrow"

    . arrowload "/workspace/dataset.arrow", aliases("/workspace/aliases.csv")

    . arrowload "/workspace/dataset.arrow", chunksize(500)

    . arrowload "/workspace/dataset.arrow", aliases("/workspace/aliases.csv") chunksize(500)
