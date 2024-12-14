global env
fsdbDumpfile "$env(TC_FSDB_NAME).fsdb"
fsdbDumpvars 0 "top"
fsdbDumpSVA 0 "top"
fsdbDumpMDA
run
