SVA_EN           ?= 1
SVA_FAIL_MAX_NUM ?= 20
SVA_SUCC_EN      ?= 1
SVA_SUCC_MAX_NUM ?= 20

ifeq (${SVA_EN}, 1)
    CMP_OPTS += -assert enable_diag -assert dbgopt
    SIM_OPTS += -assert maxfail=${SVA_FAIL_MAX_NUM} +fsdb_sva_index_info +fsdb+sva_status
ifeq (${SVA_SUCC_EN}, 1)
    SIM_OPTS += -assert success -assert summary +maxsuccess=${SVA_SUCC_MAX_NUM} +fsdb+sva_success
endif
    SIM_OPTS += -assert report=ova.report
else
    CMP_OPTS += -assert disable
endif
