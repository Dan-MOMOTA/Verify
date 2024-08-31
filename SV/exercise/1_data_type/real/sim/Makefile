CMP_OPTS   ?=
SIM_OPTS   ?=
VERDI_OPTS ?=
DVE_OPTS   ?=

TB_FILES    = ../flist/tb.f
TOP_MODULE ?= test_top

USER_DEF_CMP_OPTS += +define+NO_CHECK_TRF -debug_all
USER_DEF_SIM_OPTS +=

MODE    = $(shell getconf LONG_BIT)
ifeq (${MODE}, 64)
    CMP_OPTS += -full64
endif

CPUS      = $(shell nproc)
CMP_OPTS += -j${CPUS}

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

.PHONY:all

all:cmp sim

cmp:
	vcs -V -top ${TOP_MODULE} ${CMP_OPTS} ${USER_DEF_CMP_OPTS} -f ${TB_FILES}

sim:
	./simv ${SIM_OPTS} ${USER_DEF_SIM_OPTS}
	@echo ""
	@echo "+-----------------------------------------------------------------+"
	@echo "+     Compile    log    :   ./log/cmp/cmp.log                     "
	@echo "+     Simulation log    :   ./log/sim/${tc_full_name}.log         "
	@echo "+     Coverage   check  :   dve -full64 -cov -dir ./cov/cm.vdb &  "
	@echo "+-----------------------------------------------------------------+"
	@echo ""

wav:
	verdi -sv -ntb_opts uvm-${UVM_VER} -ssf ${WAVE_DIR} -nologo -f ${TB_FILES} -ptrTitle ${TOP_MODULE}

cov_verdi:
	verdi -cov -covdir ${COV_DIR}/${TOP_MODULE}.vdb
	#verdi -cov -covdir ${COV_DIR}/${TOP_MODULE}.vdb -elfile xxx.el

clr:
	@find . -type f -name "*.log" -delete
	@find . -type f -name "*.fsdb" -delete
	@find . -type f -name "*.vdb" -delete
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
	@echo ""
	@echo "+-------------------------------------------+"
	@echo "+            clean done ... ...             "
	@echo "+-------------------------------------------+"
	@echo ""  
