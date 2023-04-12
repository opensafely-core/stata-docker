// Call python script to load arrow file

cap prog drop arrowload, rclass
prog define arrowload
    syntax anything(name=filename)   ///
    [,                               ///
    Aliases(string)                  ///
    Chunksize(integer 64000)         ///
    ]
    if ( mi("`aliases'") ) local aliases none
    python script /python_scripts/load_arrow.py, args(`filename' `aliases' `chunksize')
end
