# -------------------------------------------------------------
#  File        : Makefile
#  Author      : Dan
#  Created     : 2024-03-03
#  Description : Makefile Configuration
# -------------------------------------------------------------

# -------------------------------------------------------------
#  declare makefile simulate-platform variable default value(orign)
# -------------------------------------------------------------
ifeq (${orign     seed}, undefined)
    seed = 0
endif
ifeq (${orign SIM_FPGA}, undefined)
    SIM_FPGA = 0
endif
ifeq (${orign CPP_COMP}, undefined)
    CPP_COMP = 0
endif
ifeq (${orign UVM_COMP}, undefined)
    UVM_COMP = 0
endif

# -------------------------------------------------------------
#  options for controling the lint
#  +lint=TFIPC-L
# -------------------------------------------------------------
CMP_OPTS += +lint=all

# -------------------------------------------------------------
#  options for controling power simulation
#  for low power simulation process
# -------------------------------------------------------------
ifeq (${PWE_EN}, 1)
    CMP_OPTS += -upf ${UPF_FILE} -power=coverage+dump_hvp
endif

# -------------------------------------------------------------
#  options for FSDB dumper
#  for low power simulation process
# -------------------------------------------------------------
#CMP_OPTS += -P ${tab} ${pli} +incdir+${VERDI_HOME}/etc/uvm-1.2/verdi

# -------------------------------------------------------------
#  options makefile simulate variable(simulation tools variable)
#  VCS_PATH: simulation env variables
#  VRD_PATH: simulation env variables
# -------------------------------------------------------------
SHELL    = /bin/sh
VCS_PATH = ${VCS_HOME}
VRD_PATH = ${VERDI_HOME}

# -------------------------------------------------------------
#  declare uvm version including uvm/sim path
#  SIM_INCL: include rtl c/sv library(ver/rtl code)
#  UVM_INCL: include uvm c/sv library
#  VRD_PATH: simulation env variables
# -------------------------------------------------------------
ifeq (${SIM_FPGA}, 1)
    SIM_INCL += +incdir+../fpga
    DIR_FPGA = fgpa
    CMP_OPTS += -top ${TOP_NAME} -top glbl ${SIM_INCL}
    CMP_OPTS += -f ../fpga
else
    DIR_FPGA =
    CMP_OPTS += -top ${TOP_NAME} ${SIM_INCL}
    CMP_OPTS += -f ${TOP_FILE}
endif

#SIM_INCL += -f ../cfg/tb.f \
+incdir+../

# -------------------------------------------------------------
#  systemverilog(uvm) option adding
#  UVM_COMP: declare/using uvm library
# -------------------------------------------------------------
ifeq (${UVM_COMP}, 1)
    CMP_OPTS += -ntb_opts uvm-1.2
else
    CMP_OPTS += 
endif

ifeq (${UVM_PHASE_TRACE_EN}, 1)
    UVM_AWARE_OPTS += +UVM_PHASE_TRACE
endif
ifeq (${UVM_OBJECTION_TRACE_EN}, 1)
    UVM_AWARE_OPTS += +UVM_OBJECTION_TRACE
endif
ifeq (${UVM_RESOURCE_DB_TRACE_EN}, 1)
    UVM_AWARE_OPTS += +UVM_RESOURCE_DB_TRACE
endif
ifeq (${UVM_CONFIG_DB_TRACE_EN}, 1)
    UVM_AWARE_OPTS += +UVM_CONFIG_DB_TRACE
endif

ifeq (${VC_VIP}, 1)
    CMP_OPTS += +define+SVT_UVM_TECHNOLOGY
    CMP_OPTS += +define+UVM_PACKER_MAX_BYTES=1500000
    CMP_OPTS += +define+UVM_DISABLE_AUTO_ITEM_RECORDING
    CMP_OPTS += +define+SYNOPSYS_SV
    CMP_OPTS += +define+SVT_AHB_INCLUDE_USER_DEFINES
endif

# -------------------------------------------------------------
#  systemverilog coverage enable and simulation platform(bch/lsf) option
#  SVA_EN: assertion enable
#  COV_EN: coverage enable
#  dut.hier: collect coverage(specify dut path)
#  SVA_ON: enable dut(insert) assertion
# -------------------------------------------------------------
ifeq (${COV_EN}, 1)
    CMP_OPTS += -cm cond+line+branch+fsm+assert+tgl ${COV_USER_DEF}
    SIM_OPTS += -cm cond+line+branch+fsm+assert+tgl ${COV_USER_DEF}

    CMP_OPTS += -cm_dir cov/cm -cm_log cov/cm.log -cm_hier ../cfg/dut.hier 
    SIM_OPTS += -cm_dir cov/cm -cm_log cov/cm.log -cm_name cm_${LOG_NAME} 
endif

ifeq (${SVA_EN}, 1)
    CMP_OPTS += +define+SVA_ON +incdir+${VCS_PATH}/packages/sva +libext+.sv \
		-y ${VCS_PATH}/packages/sva
endif

# -------------------------------------------------------------
#  setting for simulation selection
#  CPP_COMP: complie c model
#  SIM_POST: post simulation
#  SDF_POST: post simulation(0:no sdf 1:sdf)
# -------------------------------------------------------------
ifeq (${CPP_COMP}, 1)
    CMP_OPTS += ../env/cmodel/${CTP_FILE}.so
endif

CMP_OPTS += +define+CPU_UNPROT +nospecify +no_notifier -negdelay +notimingcheck \
	    +define+ARM_UD_MODEL +define+ARM_UD_DP

# -------------------------------------------------------------
#  declare simulate tools(vcs/nc) complie options
#  common complie options
#  +v2k:configure file
#  -mupdate: complie modify codes(improve speed)
#  +nospecify/notimingcheck:not check setup/hold time
#  +lint=all/PCWM:check some bad style in verilog code
#  -ntb/-ntb opts:native testbench
#  -kdb=both:dumping vpd/fsdb
#  -lca:limited customer availability
#  notes:-sverilog is omitted by +systemverilog+.sv/+verilog2001ext+.v
#  userself complie options/simv filename
#  ${CMP_USER_DEF} ${SIM_USER_DEF}
# -------------------------------------------------------------
CMP_OPTS += +define+VCS_RUN ${CMP_USER_DEF}

# -------------------------------------------------------------
#  basic option for vcs/xmverilog
# -------------------------------------------------------------
BSC_OPTS += -j8 -sverilog +vpi +ntb -Mupdate -full64 -kdb -debug_access+all -lca +v2k \
	    -Marchive -l complie.log -override_timescale=1ns/1ps -o ${SIM_FILE} +vcs+lic+wait

# -------------------------------------------------------------
#  declare simulate tools(vcs/nc) complie options
# -------------------------------------------------------------
SIM_OPTS += +rad +v2k +vpi -l log/${LOG_NAME}.log +ntb_random_seed=${seed} +fsdb+force \
	    +tarmac_on ${SIM_USER_DEF} +tc_name=${LOG_NAME} \
	    +fsdbfile+${LOG_NAME}.fsdb

ifeq (${UVM_COMP}, 1)
    SIM_OPTS += +UVM_TESTNAME=${TC} +UVM_VERDI_TRACE +UVM_TR_RECORD +UVM_LOG_RECORD \
		+UVM_VERBOSITY=${UVM_VL} +UVM_MAX_QUIT_COUNT=${UVM_QC} ${UVM_AWARE_OPTS}
endif

# -------------------------------------------------------------
#  three_setp flow: analysis elaboration simulation 
# -------------------------------------------------------------

# -------------------------------------------------------------
#  two_setp flow: elaboration simulation 
# -------------------------------------------------------------
all: cmp sim

# -------------------------------------------------------------
#  complie logs(before) 
# -------------------------------------------------------------
cmp_l0:
	@mkdir -p log

# -------------------------------------------------------------
#  complie logs(after) 
# -------------------------------------------------------------
cmp_l1:

# -------------------------------------------------------------
#  complie logs 
# -------------------------------------------------------------
cmp:
	@${VCS_PATH}/bin/vcs ${DEFIINE} ${BSC_OPTS} ${CMP_OPTS}

# -------------------------------------------------------------
#  simulation logs(before) 
# -------------------------------------------------------------
sim_l0:
	@mkdir -p log

# -------------------------------------------------------------
#  simulation logs(after) 
# -------------------------------------------------------------
sim_l1:
	@echo ""
	@echo "+----------------------------------------------------+"
	@echo "+     Compile    log    :   ./complie.log             "
	@echo "+     Simulation log    :   ./log/${LOG_NAME}.log     "
	@echo "+----------------------------------------------------+"
	@echo ""

chk:
	@echo ""
	@echo "******************************************************"
	@echo "           check mem errors/warnings begin            "
	@echo "******************************************************"
	@echo ""
	@grep "error"   ./log/* -R >>! /dev/null
	@grep "warning" ./log/* -R >>! /dev/null
	@echo ""

# -------------------------------------------------------------
#  simulation logs (no gui) 
# -------------------------------------------------------------
sim_vcs:
	@./${SIM_FILE} ${SIM_OPTS}
#	@${SIM_FILE} ${SIM_OPTS} -gui=verdi &

sim: sim_l0 sim_${SIM_TOOL} sim_l1

# -------------------------------------------------------------
#  wav control 
#  -ssf novas.fsdb: automatic open wav
# -------------------------------------------------------------
wav_verdi:
	#@${VRD_PATH}/bin/verdi ${CMP_OPTS} -simflow -workMode hardwareDebug -nologo &
	@${VRD_PATH}/bin/verdi -sv -ntb_opts uvm-1.2 -simflow -workMode hardwareDebug -nologo -f ${TOP_FILE} -top ${TOP_NAME} &

wav: wav_${DBG_TOOL}

nmv: ${VRD_PATH}/bin/nWave ${LOG_NAME}.fsdb &


# -------------------------------------------------------------
#  coverage control 
# -------------------------------------------------------------
cov: cov_${SIM_TOOL}

cov_vcs:
	@bsub -I urg -dir cov/{cm,cm.vdb} -report urgReport
	@firefox urgReport/dashboard.html &
dve:
	dve -full64 -cov -dir cov/cm.vdb &
vdi:
	verdi -cov -dir cov/cm.vdb &

# -------------------------------------------------------------
#  plan mode 
# -------------------------------------------------------------
plan:
	verdi -plan ${HVP}

# -------------------------------------------------------------
#  coverage + plan mode 
# -------------------------------------------------------------
cov_plan:
	verdi -cov -covdir cov/cm.vdb -plan ${HVP} &

# -------------------------------------------------------------
#  clean option 
# -------------------------------------------------------------
clean:
	@rm -rf complie.log csrc verdi* novas* sim* tr* ucli* vc*
	@rm -rf DVEfiles log *fsdb cov fsdb_log
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "                   clean trash !!! >.<                  "
	@echo "--------------------------------------------------------"
	@echo ""

