CMP_LOG_DIR ?= log/cmp
SIM_LOG_DIR ?= log/sim

CMP_OPTS += -l ${CMP_LOG_DIR}/cmp.log
SIM_OPTS += -l ${SIM_LOG_DIR}/${tc_full_name}.log
