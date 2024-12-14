 
#seed                 := $(shell date +%Y%m%d%H%M%S)
seed                  := $(shell date +%d%H%M%S)
#tc
cfg                   := default
TC_CFG_DIR            := ../tc/tc_cfg/
tc                    := tc_sanity
LOG_DIR               := log_dir
mode                  := normal
ifeq ($(mode),regress)
LOG_DIR               := rgr_log_dir
endif

pl   := UVM_MEDIUM
RUN_NAME              := $(tc)_$(cfg)_$(seed)
$(shell if [ ! -e $(LOG_DIR) ];then mkdir -p $(LOG_DIR); fi)
#assert
assert                :=off
ASSERT_CMP_OPT        :=
ASSERT_RUN_OPT        :=
ifeq ($(assert), on)
    ASSERT_CMP_OPT    := +define+ASSERT_ON
    ASSERT_RUN_OPT    := +fsdb+sva_success
endif

#cov
cov                   :=off
COV_CMP_OPT           :=
COV_RUN_OPT           :=

ifeq ($(cov),on)
    COV_CMP_OPT       :=  -cm tgl+branch+line+cond+fsm -cm_dir top_cov -cm_name $(RUN_NAME)
    COV_RUN_OPT       :=  -cm tgl+branch+line+cond+fsm -cm_dir top_cov -cm_name $(RUN_NAME)
endif

#wave
wave                  :=on
WAVE_RUN_OPT          :=
FSDB_DIR              := wave_dir
export TC_FSDB_NAME   :=
$(shell if [ ! -e $(FSDB_DIR) ];then mkdir -p $(FSDB_DIR); fi)
ifeq ($(wave), on)
    export TC_FSDB_NAME := $(FSDB_DIR)/$(RUN_NAME)
    WAVE_RUN_OPT        := -ucli -i ../bin/dump_fsdb.tcl +fsdb +autoflush
endif

FILE_LIST             := -f ../cfg/tb.f

all: run result

#elab:
cmp :
	   vcs -sverilog -full64 -debug_pp -fsdb -l ./$(LOG_DIR)/compile.log $(FILE_LIST)\
           -timescale=1ns/1ps\
		   -ntb_opts uvm-1.1\
           -kdb -lca $(ASSERT_CMP_OPT) $(COV_CMP_OPT)
run: ru result
ru : cmp
	   ./simv -l ./$(LOG_DIR)/$(RUN_NAME).log\
       -f $(TC_CFG_DIR)$(cfg).cfg\
       +ntb_random_seed=$(seed)\
       $(WAVE_RUN_OPT) $(ASSERT_RUN_OPT) $(COV_RUN_OPT)\
       +UVM_VERBOSITY=$(pl)\
       +UVM_TESTNAME=$(tc)

nrun : nru result
nru :
	   ./simv -l ./$(LOG_DIR)/$(RUN_NAME).log\
       -f $(TC_CFG_DIR)$(cfg).cfg \
       +ntb_random_seed=$(seed)\
       $(WAVE_RUN_OPT) $(ASSERT_RUN_OPT) $(COV_RUN_OPT)\
       +UVM_VERBOSITY=$(pl)\
       +UVM_TESTNAME=$(tc)

rung : cmp
	   ./ simv -gui -l run_log.log \
       +ntb_random_seed=$(seed)

verdi :
	   verdi -elab simv.daidir/kdb.elab++ &
cov:
	   dve -full64 -cov -dir top_cov.vdb&
clean :
	   rm -rf AN.DB DVEfiles csrc simv.* *simv inter.vpd ucli.key novas* *.fsdb simv* verdiLog *.log ./$(LOG_DIR)/* ./$(FSDB_DIR)/* stack.info*

result:
	   $(call print_result)

define print_result
    @echo "+--------------------------------------------------------+"
    @echo "+ Compile    log    : ./$(LOG_DIR)/compile.log            "
    @echo "+ Simulation log    : ./$(LOG_DIR)/$(RUN_NAME).log        "
    @echo "+--------------------------------------------------------+"
    @echo ""
endef



