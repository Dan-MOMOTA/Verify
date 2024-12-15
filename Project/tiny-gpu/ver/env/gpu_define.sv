//=================================================================
//Copyright (C) 2024 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :gpu_define.sv
// Creater     :Dan
// Create Date :2024-12-15 18:57:22
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef GPU_DEFINE_SV
`define GPU_DEFINE_SV

    // PARAMETER
    parameter DATA_MEM_ADDR_BITS       = 8 ; // Number of bits in data memory address (256 rows)
    parameter DATA_MEM_DATA_BITS       = 8 ; // Number of bits in data memory value (8 bit data)
    parameter DATA_MEM_NUM_CHANNELS    = 4 ; // Number of concurrent channels for sending requests to data memory
    parameter PROGRAM_MEM_ADDR_BITS    = 8 ; // Number of bits in program memory address (256 rows)
    parameter PROGRAM_MEM_DATA_BITS    = 16; // Number of bits in program memory value (16 bit instruction)
    parameter PROGRAM_MEM_NUM_CHANNELS = 1 ; // Number of concurrent channels for sending requests to program memory
    parameter NUM_CORES                = 2 ; // Number of cores to include in this GPU
    parameter THREADS_PER_BLOCK        = 4 ; // Number of threads to handle per block (determines the compute resources of each core)

    // DEFINE

    // ENUM

`endif 
