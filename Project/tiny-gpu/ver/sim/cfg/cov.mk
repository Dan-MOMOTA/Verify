COV_EN          ?= 0
CODE_COV_EN     ?= 0
SVA_COV_EN      ?= 0
COV_DIR          = cov

ifeq (${COV_EN}, 1)

ifeq (${CODE_COV_EN}, 1)
    CMP_OPTS += -cm line+cond+fsm+tgl+branch -cm_dir ${COV_DIR}/${TOP_MODULE}..vdb -cm_hier cov/cfg/cov.cfg
    SIM_OPTS += -cm line+cond+fsm+tgl+branch -cm_log ${COV_DIR}/cov.log
endif

ifeq (${SVA_EN}, 1)

ifeq (${SVA_COV_EN}, 1)
    CMP_OPTS += -cm assert
    SIM_OPTS += -cm assert
else
    CMP_OPTS += -assert disable_cover
endif

endif

ifeq (${tc},)

ifeq (${seed},)
    SIM_OPTS += -cm_name novas
else
    SIM_OPTS += -cm_name novae_${seed}
endif

else

ifeq (${seed},)
    SIM_OPTS += -cm_name ${tc}
else
    SIM_OPTS += -cm_name ${tc}_${seed}
endif

endif

endif
