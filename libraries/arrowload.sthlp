Arrowload
---------

    arrowload -- Load an arrow file


Syntax
------

        arrowload filename [, options]

    options                           Description
    ---------------------------------------------------------------------------------
    Main
      configfile(path/to/csv/file)    A csv file containing configuration for the import
      verbosity(#)                    An integer to control the level of output;
                                      default verbosity(3)
    ---------------------------------------------------------------------------------


Description
-----------

    arrowload loads an arrow file into the stata dataset.

    Columns in the arrow file are converted to the most appropriate stata variable type.

    NOTE: Integer types will be loaded as byte, int or long, depending on the values of the
    column in the arrow data. If the arrow data contains integers that are larger than 32 bit,
    which cannot be represented as an integer in stata, the column will be loaded as a
    string column, and values will be string representations of the integers.


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

    verbosity determine the level of output
        - 1: prints minimal info messages
        - 2: prints warnings only
        - 3: prints all info messages (the default)


Examples
--------
    . arrowload /workspace/dataset.arrow
    . arrowload /workspace/dataset.arrow, verbosity(1)
    . arrowload /workspace/dataset.arrow, configfile(/workspace/config.csv)
    . arrowload /workspace/dataset.arrow, configfile(/workspace/config.csv) verbosity(2)
