UVM_EN                  ?= 1
UVM_VER                 ?= 1.2
DPI_HDL_API_EN          ?= 1
UVM_REG_ADDR_WIDTH      ?= 64
UVM_REG_DATA_WIDTH      ?= 64
UVM_DBG                 ?= 0
UVM_PHASE_TRACE_EN      ?= 0
UVM_OBJECTION_TRACE_EN  ?= 1
UVM_RESOURCE_TRACE_EN   ?= 0
UVM_CONFIG_DB_TRACE_EN  ?= 0

tc      ?=
vl      ?=
qc      ?=
to      ?= 5000000000

ifeq (${UVM_EN},1)

ifeq (${UVM_VER}, 1.1)
    CMP_OPTS += -ntb_opts uvm-1.1
else ifeq (${UVM_VER}, 1.2)
    CMP_OPTS += -ntb_opts uvm-1.2
else ifeq (${UVM_VER}, ieee)
    CMP_OPTS += -ntb_opts uvm-ieee
else ifeq (${UVM_VER}, ieee-2020)
    CMP_OPTS += -ntb_opts uvm-ieee-2020
else ifeq (${UVM_VER}, ieee-2020-2.0)
    CMP_OPTS += -ntb_opts uvm-ieee-2020-2.0
endif

ifeq (${DPI_HDL_API_EN}, 0)
    CMP_OPTS += +define+UVM_HDL_NO_DPI
endif

    CMP_OPTS += +define+UVM_REG_ADDR_WIDTH=${UVM_REG_ADDR_WIDTH}
    CMP_OPTS += +define+UVM_REG_DATA_WIDTH=${UVM_REG_DATA_WIDTH}

    SIM_OPTS += +UVM_TESTNAME=${tc} +UVM_VERBOSITY=${vl} +UVM_MAX_QUIT_COUNT=${qc} +UVM_TIMEOUT=${to}

ifeq (${UVM_DBG}, 1)

ifeq (${GUI_EN}, 1)
    SIM_OPTS += +UVM_PHASE_RECORD +UVM+TR+RECORD +UVM_VERDI_TRACE="UVM_AWARE+RAL+HIER+COMPWAVE"
endif

    VERDI_OPTS += -uvmDebug

ifeq (${UVM_PHASE_TRACE_EN}, 1)
    SIM_OPTS += +UVM_PHASE_TRACE
endif

ifeq (${UVM_OBJECTION_TRACE_EN}, 1)
    SIM_OPTS += +UVM_OBJECTION_TRACE
endif

ifeq (${UVM_RESOURCE_TRACE_EN}, 1)
    SIM_OPTS += +UVM_RESOURCE_TRACE
endif

ifeq (${UVM_CONFIG_DB_TRACE_EN}, 1)
    SIM_OPTS += +UVM_CONFIG_DB_TRACE
endif

endif

endif

ifeq (${tc},)

ifeq (${seed},)
    tc_full_name=novas
else
    tc_full_name=novas_${seed}
endif

else

ifeq (${seed},)
    tc_full_name=${tc}
else
    tc_full_name=${tc}_${seed}
endif

endif
