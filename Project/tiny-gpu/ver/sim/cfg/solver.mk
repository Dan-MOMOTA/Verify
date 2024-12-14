SEED_MANUAL  ?= 1
seed         ?= $(shell date "+%m%d%H%M%S")

ifeq (${SEED_MANUAL},1)
    SIM_OPTS += ntb_random_seed=${seed}
else
    SIM_OPTS += ntb_random_seed_automatic
endif

SIM_OPTS += solver_array_size_warn=10000
