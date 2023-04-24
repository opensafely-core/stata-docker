// Call python script to load arrow file

cap prog drop arrowload, rclass
prog define arrowload
    syntax anything(name=filename)   ///
    [,                               ///
    Configfile(string)               ///
    Chunksize(integer 64000)         ///
    ]
    if ( mi("`configfile'") ) local configfile none
    python script /python_scripts/load_arrow.py, args(`filename' `configfile' `chunksize')
end
