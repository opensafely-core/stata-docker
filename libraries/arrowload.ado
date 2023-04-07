// Call python script to load arrow file

cap prog drop arrowload, rclass
prog define arrowload
    syntax [anything(name=filename)]
    python script /python_scripts/load_arrow.py, args(`filename')
end
