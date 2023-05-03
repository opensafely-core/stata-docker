Arrowload
---------

    arrowload -- Load an arrow file


Syntax
------

        arrowload filename [, options]

    options               Description
    ---------------------------------------------------------------------------------
    Main
      configfile(path/to/csv/file)    A csv file containing configuration for the import
    ---------------------------------------------------------------------------------


Description
-----------

    arrowload loads an arrow file


Options
-------

        +------+
    ----+ Main +---------------------------------------------------------------------

    configfile allows configuration of the import via a CSV file.  The following config can be provided:
        - aliases: mapping of original variable names in the arrow file to aliased names.
          The CSV configfile must contain the column headers "original_column" and "aliased_column"
          This can be used if the input arrow file contains variable names that are too
          long for use in stata. However, it is preferable fix the input file to use valid
          names. Some or all variable names can be mapped.


Examples
--------

    . arrowload "/workspace/dataset.arrow"

    . arrowload "/workspace/dataset.arrow", aliases("/workspace/aliases.csv")
