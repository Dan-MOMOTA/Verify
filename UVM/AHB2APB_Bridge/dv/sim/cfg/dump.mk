WAVE_EN         ?= 1
WAVE_FORMAT     ?= FSDB
DUMP_STRENGTH   ?= 1
DUMP_FORCE      ?= 1

ifeq (${WAVE)EN}, 1)

ifeq (${WAVE_FORMAT}, FSDB)
    WAVE_DIR = wave/fsdb
    CMP_OPTS += +vcs+fsdbon
ifeq (${DUMP_STRENGTH}, 1)
    SIM_OPTS += +fsdb+strength=on
endif

ifeq (${DUMP_FORCE}, 1)
    SIM_OPTS += +fsdb+force
endif

else ifeq (${WAVE_FORMAT}, VPD)
    WAVE_DIR = wave/vpd
else
    WAVE_DIR = wave/vcd
endif

SIM_OPTS += +fsdbfile+${WAVE_DIR}/${tc_full_name}.fsdb

endif
