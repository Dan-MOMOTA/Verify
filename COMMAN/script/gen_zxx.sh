#!/bin/bash
if [[ ! -d sim ]]; then
    mkdir -pv sim
    touch sim/Makefile

    if [[ ! -d sim/cfg ]]; then
        mkdir -pv sim/cfg
        touch     sim/cfg/vlg.mk
        touch     sim/cfg/assert.mk
        touch     sim/cfg/cov.mk
        touch     sim/cfg/dump.mk
        touch     sim/cfg/lint.mk
        touch     sim/cfg/macros.mk
        touch     sim/cfg/solver.mk
        touch     sim/cfg/uvm.cfg
        touch     sim/cfg/timescale.mk
        touch     sim/cfg/log.mk
    fi

    if [[ ! -d sim/log ]]; then
        mkdir -pv sim/log
        mkdir -pv sim/log/cmp
        mkdir -pv sim/log/sim
    fi
    


    if [[ ! -d sim/log ]]; then
        mkdir -pv sim/wave
        mkdir -pv sim/wave/fsdb
        mkdir -pv sim/wave/vpb
        mkdir -pv sim/wave/vcb
    fi
fi

if [[ ! -d flist ]]; then
    mkdir -pv flist
    touch flist/tb.f
    touch flist/test.sv

    echo -e "../flist/test.sv" > flist/tb.f
    echo -e "module test_top;

endmodule" > flist/test.sv
fi

#Makefile
echo -e "CMP_OPTS   ?=
SIM_OPTS   ?=
VERDI_OPTS ?=
DVE_OPTS   ?=

TB_FILES    = ../flist/tb.f
TOP_MODULE ?= test_top

USER_DEF_CMP_OPTS += +define+NO_CHECK_TRF -debug_all
USER_DEF_SIM_OPTS +=

MODE    = \$(sehll getconf LONG_BIT)
ifeq (\${MODE}, 64)
    CMP_OPTS += -full64
endif

CPUS    = \$(shell nproc)
CMP_OPTS += -j\${CPUS}

include cfg/vlg.mk
include cfg/macros.mk
include cfg/lint.mk
include cfg/dbg.mk
include cfg/solver.mk
include cfg/uvm.mk
include cfg/assert.mk
include cfg/cov.mk
include cfg/log.mk
include cfg/dump.mk

cmp:
    vcs -V -top \${TOP_MODULE} \${CMP_OPTS} \${USER_DEF_CMP_OPTS} -f \${TB_FILES}

sim:
    simv \${SIM_OPTS} \${USER_DEF_SIM_OPTS}
	@echo \"\"
	@echo \"+-----------------------------------------------------------------+\"
	@echo \"+     Compile    log    :   ./log/cmp/cmp.log                     \"
	@echo \"+     Simulation log    :   ./log/sim/\${tc_full_name}.log         \"
	@echo \"+     Coverage   check  :   dve -full64 -cov -dir ./cov/cm.vdb &  \"
	@echo \"+-----------------------------------------------------------------+\"
	@echo \"\"

wav:
    verdi -sv -ntb_opts uvm-\${UVM_VER} -ssf \${WAVE_DIR} -nologo -f \${TB_FILES} -ptrTitle \${TOP_MODULE}

cov_verdi:
    verdi -cov -covdir \${COV_DIR}/\${TOP_MODULE}.vdb
    #verdi -cov -covdir \${COV_DIR}/\${TOP_MODULE}.vdb -elfile xxx.el

clr:
    @find . -type f -name \"*.log\" -delete
    @find . -type f -name \"*.fsdb\" -delete
    @find . -type f -name \"*.vdb\" -delete
    @rm -rf *simv*
    @rm -rf *.daidir
    @rm -rf csrc vc_hdrs.h ucli.key
    @rm -rf vdCovLog
    @rm -rf stack.info.*
    @rm -rf urgReport
    @rm -rf *.vpd
    @rm -rf vcs.cfg
    @rm -rf pli_learn.tab
    @rm -rf novas.* verdiLog
    @rm -rf DVEfiles
    @rm -rf ova.report.disablelog
    @rm -rf ova.report
    @rm -rf xsim.dir
    @rm -rf xvlog.pb
    @rm -rf .__solver_cache__
	@echo \"\"
	@echo \"+-------------------------------------------+\"
	@echo \"+            clean done ... ...             \"
	@echo \"+-------------------------------------------+\"
	@echo \"\"  " > sim/Makefile

#vlg.mk
echo -e "SV_EN   ?= 1
V2K_EN  ?= 1
V95_EN  ?= 1

ifeq (\${SV_EN},1)
    CMP_OPTS += -sverilog
endif

ifeq (\${V2K_EN},1)
    CMP_OPTS += +v2k
endif" sim/cfg/vlg.mk

#assert.mk
echo -e "SVA_EN         ?= 1
SVA_FAIL_MAX_NUM ?= 20
SVA_SUCC_EN      ?= 1
SVA_SUCC_MAX_NUM ?= 20

ifeq (\${SVA_EN}, 1)
    CMP_OPTS += -assert enable_diag -assert dbgopt
    SIM_OPTS += -assert maxfail=\${SVA_FAIL_MAX_NUM} +fsdb_sva_index_info +fsdb+sva_status
ifeq (\${SVA_SUCC_EN}, 1)
    SIM_OPTS += -assert success -assert summary +maxsuccess=\${SVA_SUCC_MAX_NUM} +fsdb+sva_success
endif
    SIM_OPTS += -assert report=ova.report
else
    CMP_OPTS += -assert disable
endif" > sim/cfg/assert.mk

#cov.mk
echo -e "COV_EN         ?= 0
CODE_COV_EN     ?= 0
SVA_COV_EN      ?= 0
COV_DIR          = cov

ifeq (\${COV_EN}, 1)

ifeq (\${CODE_COV_EN}, 1)
    CMP_OPTS += -cm line+cond+fsm+tgl+branch -cm_dir \${COV_DIR}/\${TOP_MODULE}..vdb -cm_hier cov/cfg/cov.cfg
    SIM_OPTS += -cm line+cond+fsm+tgl+branch -cm_log \${COV_DIR}/cov.log
endif

ifeq (\${SVA_EN}, 1)

ifeq (\${SVA_COV_EN}, 1)
    CMP_OPTS += -cm assert
    SIM_OPTS += -cm assert
else
    CMP_OPTS += -assert disable_cover
endif

endif

ifeq (\${tc},)

ifeq (\${seed},)
    SIM_OPTS += -cm_name novas
else
    SIM_OPTS += -cm_name novae_\${seed}
endif

else

ifeq (\${seed},)
    SIM_OPTS += -cm_name \${tc}
else
    SIM_OPTS += -cm_name \${tc}_\${seed}
endif

endif

endif" > sim/cfg/cov.mk

#cov.cfg
echo -e "#+tree
#-tree
#+module
#-module
#+moduletree
#-moduletree
#+file
#-file" > sim/cov/cfg/cov.cfg

#dbg.mk
echo -e "DBG_EN     ?= 1
GUI_EN      ?= 0

ifeq (\${DBG_EN},1)
    CMP_OPTS += -kdb -debug_access+all -lca
endif

ifeq (\${GUI_EN},1)
    SIM_OPTS += -gui
endif

#endless loop debug
LOOP_NUM ?= 1000
#CMP_OPTS += +vcs+loopreport+\${LOOP_NUM}" > sim/cfg/dbg.mk

#lint.mk
echo -e "CMP_OPTS += +lint=TFIPC-L" > sim/cfg/lint.mk

#log.mk
echo -e "CMP_LOG_DIR ?= log/cmp
SIM_LOG_DIR ?= log/sim

CMP_OPTS += -l \${CMP_LOG_DIR}/cmp.log
SIM_OPTS += -l \${SIM_LOG_DIR}/\${tc_full_name}.log" > sim/cfg/log.mk

#macros.mk
echo -e "MACROS_DEBUG_EN = 0

ifeq (\${MACROS_DEBUG_EN}, 1)
    CMP_OPTS += -Xrawtoken=debug_macros
endif" > sim/cfg/macros.mk

#solver.mk
echo -e "SEED_MANUAL     ?= 1
seed        ?= \$(shell data \"+%m%d%H%M%S\")

ifeq (\${SEED_MANUAL},1)
    SIM_OPTS += ntb_random_seed=\${seed}
else
    SIM_OPTS += ntb_random_seed_automatic
endif

SIM_OPTS += solver_array_size_warn=10000" > sim/cfg/solver.mk

#timescale.mk
echo -e "CMP_OPTS += -override_timescale=1ns/1ps" > sim/cfg/timescale.mk

#uvm.mk
echo -e "UVM_EN             ?= 1
UVM_VER                 ?= 1.2
DPI_HDL_API_EN          ?= 1
UVM_REG_ADDR_WIDTH      ?= 64
UVM_REG_DATA_WIDTH      ?= 64
UVM_DBG                 ?= 0
UVM_PHASE_TRACE_EN      ?= 0
UVM_OBJECTION_TRACE_EN  ?= 0
UVM_RESOURCE_TRACE_EN   ?= 0
UVM_CONFIG_DB_TRACE_EN  ?= 0

tc      ?=
vl      ?=
qc      ?=
to      ?= 5000000000

ifeq (\${UVM_EN},1)

ifeq (\${UVM_VER}, 1.1)
    CMP_OPTS += -ntb_opts uvm-1.1
else ifeq (\${UVM_VER}, 1.2)
    CMP_OPTS += -ntb_opts uvm-1.2
else ifeq (\${UVM_VER}, ieee)
    CMP_OPTS += -ntb_opts uvm-ieee
else ifeq (\${UVM_VER}, ieee-2020)
    CMP_OPTS += -ntb_opts uvm-ieee-2020
else ifeq (\${UVM_VER}, ieee-2020-2.0)
    CMP_OPTS += -ntb_opts uvm-ieee-2020-2.0
endif

ifeq (\${DPI_HDL_API_EN}, 0)
    CMP_OPTS += +define+UVM_HDL_NO_DPI
endif

    CMP_OPTS += +define+UVM_REG_ADDR_WIDTH=\${UVM_REG_ADDR_WIDTH}
    CMP_OPTS += +define+UVM_REG_DATA_WIDTH=\${UVM_REG_DATA_WIDTH}

    SIM_OPTS += UVM_TESTNAME=\${tc} +UVM_VERBOSITY=\${vl} +UVM_MAX_QUIT_COUNT=\${qc} +UVM_TIMEOUT=\${to}

ifeq (\${UVM_DBG}, 1)

ifeq (\${GUI_EN}, 1)
    SIM_OPTS += +UVM_PHASE_RECORD +UVM+TR+RECORD +UVM_VERDI_TRACE=\"UVM_AWARE+RAL+HIER+COMPWAVE\"
endif

    VERDI_OPTS += -uvmDebug

ifeq (\${UVM_PHASE_TRACE_EN}, 1)
    SIM_OPTS += +UVM_PHASE_TRACE
endif

ifeq (\${UVM_OBJECTION_TRACE_EN}, 1)
    SIM_OPTS += +UVM_OBJECTION_TRACE
endif

ifeq (\${UVM_RESOURCE_TRACE_EN}, 1)
    SIM_OPTS += +UVM_RESOURCE_TRACE
endif

ifeq (\${UVM_CONFIG_DB_TRACE_EN}, 1)
    SIM_OPTS += +UVM_CONFIG_DB_TRACE
endif

endif

endif

ifeq (\${tc},)

ifeq (\${seed},)
    tc_full_name=novas
else
    tc_full_name=novas_\${seed}
endif

else

ifeq (\${seed},)
    tc_full_name=\${tc}
else
    tc_full_name=\${tc}_\${seed}
endif

endif" > sim/cfg/uvm.mk

#dump.mk
echo -e "WAVE_EN        ?= 1
WAVE_FORMAT     ?= FSDB
DUMP_STRENGTH   ?= 1
DUMP_FORCE      ?= 1

ifeq (\${WAVE)EN}, 1)

ifeq (\${WAVE_FORMAT}, FSDB)
    WAVE_DIR = wave/fsdb
    CMP_OPTS += +vcs+fsdbon
ifeq (\${DUMP_STRENGTH}, 1)
    SIM_OPTS += +fsdb+strength=on
endif

ifeq (\${DUMP_FORCE}, 1)
    SIM_OPTS += +fsdb+force
endif

else ifeq (\${WAVE_FORMAT}, VPD)
    WAVE_DIR = wave/vpd
else
    WAVE_DIR = wave/vcd
endif

SIM_OPTS += +fsdbfile+\${WAVE_DIR}/\${tc_full_name}.fsdb

endif" > sim/cfg/dump.mk

echo 'successful ...'