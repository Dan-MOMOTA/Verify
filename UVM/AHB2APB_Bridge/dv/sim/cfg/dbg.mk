DBG_EN      ?= 1
GUI_EN      ?= 0

ifeq (${DBG_EN},1)
    CMP_OPTS += -kdb -debug_access+all -lca
endif

ifeq (${GUI_EN},1)
    SIM_OPTS += -gui=verdi &
endif

#endless loop debug
LOOP_NUM ?= 1000
#CMP_OPTS += +vcs+loopreport+${LOOP_NUM}
