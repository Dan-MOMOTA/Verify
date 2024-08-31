MACROS_DEBUG_EN = 0

ifeq (${MACROS_DEBUG_EN}, 1)
    CMP_OPTS += -Xrawtoken=debug_macros
endif
