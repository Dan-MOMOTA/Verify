CMP_LOG_DIR ?= $(GPU_PRJ)/ver/work/test/cmp
SIM_LOG_DIR ?= $(GPU_PRJ)/ver/work/test/sim

CMP_OPTS += -l ${CMP_LOG_DIR}/cmp.log
SIM_OPTS += -l ${SIM_LOG_DIR}/${tc_full_name}.log
