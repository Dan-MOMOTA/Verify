# -------------------------------------------------------------
#  File        : Makefile
#  Author      : Dan
#  Created     : 2024-03-03
#  Description : Makefile Configuration
# -------------------------------------------------------------

# -------------------------------------------------------------
#  environment variable
# -------------------------------------------------------------
VCS_HOME   = /opt/Synopsys/VCS2018/vcs/O-2018.09-SP2
VERDI_HOME = /opt/Synopsys/Verdi2018/verdi/Verdi_O-2018.09-SP2
UVM_HOME   = /opt/Synopsys/VCS2018/vcs/O-2018.09-SP2/etc/uvm-1.2

# -------------------------------------------------------------
#  systemverilog assertion/converage enable
#  SVA_EN = 0/1 (0:disable 1:enable)
#  COV_EN = 0/1 (0:disable 1:enable)
# -------------------------------------------------------------
SVA_EN ?= 0
COV_EN ?= 0

# -------------------------------------------------------------
#  specify simulate tools(vcs/ncverilog)
#  SIM_TOOL = vcs/nc
#  DBG_TOOL = dve/verdi
# -------------------------------------------------------------
SIM_TOOL ?= vcs
DBG_TOOL ?= verdi

# -------------------------------------------------------------
#  setting for c model complie(c model and c topfile)
#  CPP_COMP =0/1 (0:disable 1:enable -> complie c-model)
#  CTP_FILE = test
# -------------------------------------------------------------
CPP_COMP ?= 0
CTP_FILE ?= test

# -------------------------------------------------------------
#  setting for uvm source file complie(uvm1.2)
#  UVM_COMP = 0/1 (0:disable 1:enable -> complie uvm_pkg
#  TOP_NAME = xxx specify project top (test_top)
#  TOP_FILE = xxx specify project top file
#  TC = UVM_TC_NAME
# -------------------------------------------------------------
UVM_COMP                 ?= 1
UVM_AWARE_OPTS           ?= 
UVM_VL                   ?= UVM_MEDIUM
UVM_QC                   ?= 10000
UVM_PHASE_TRACE_EN       ?= 0
UVM_OBJECTION_TRACE_EN   ?= 0
UVM_RESOURCE_DB_TRACE_EN ?= 0
UVM_CONFIG_DB_TRACE_EN   ?= 0
TC                       ?= 
TOP_NAME                 ?= ahb2apb_tb
TOP_FILE                 ?= ./tb.f
# Synopsys VC Verification IP
VC_VIP ?= 0

# -------------------------------------------------------------
#  define seed
# -------------------------------------------------------------
#  seed = $(shell date +%m%d%H%M%S)

# -------------------------------------------------------------
#  define CFG
# -------------------------------------------------------------
#CFG ?= default
#TC_CFG_DIR = ../tc/tc_cfg/
LOG_NAME = ${TC}_${seed}

# -------------------------------------------------------------
#  define post-simulate options(post simulation control)
#  SIM_POST: select system-simulation(0:sim_pre 1:sim_post)
#  SDF_POST: select system-simulation(0:no-sdf  1:sdf)
# -------------------------------------------------------------
SIM_POST ?= 0
SDF_POST ?= 0

# -------------------------------------------------------------
#  define simulation scripts options
#  SIM_FILE: simulate execute filename
# -------------------------------------------------------------
SIM_FILE = simv

# -------------------------------------------------------------
#  option for controling power simulation
# -------------------------------------------------------------
PWE_EN   ?= 0
UPF_FILE ?= 

# -------------------------------------------------------------
#  define userself options
#  CMP_USER_DEF: userself complie options
#  SIM_USER_DEF: userself simulate options
#  DEFIINE: define marco, such as +define+NO_CHECK_TRF
# -------------------------------------------------------------
CMP_USER_DEF = 
CMP_POST_DEF = 
SIM_USER_DEF = 
DEFIINE      = 

# -------------------------------------------------------------
#  include common makefile
# -------------------------------------------------------------
include ./proj.mk
