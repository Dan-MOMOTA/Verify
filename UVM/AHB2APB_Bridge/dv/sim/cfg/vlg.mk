SV_EN   ?= 1
V2K_EN  ?= 1
V95_EN  ?= 1

ifeq (${SV_EN},1)
    CMP_OPTS += -sverilog
endif

ifeq (${V2K_EN},1)
    CMP_OPTS += +v2k
endif
