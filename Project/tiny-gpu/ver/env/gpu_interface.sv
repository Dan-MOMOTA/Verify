//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_interface.sv
// Creator     : Dan
// Create Date : 2024-12-15- 15:35:39
// Description : 
// 
//================================================================

`ifndef GPU_INTERFACE_SV
`define GPU_INTERFACE_SV

interface gpu_interface(
                        input  clk   ,
                        input  reset
                       );

    logic                                start                                                   ; // input 
    logic                                done                                                    ; // output
    logic                                device_control_write_enable                             ; // input
    logic [7:0]                          device_control_data                                     ; // input
                                                                                                            
    logic [PROGRAM_MEM_NUM_CHANNELS-1:0] program_mem_read_valid                                  ; // output
    logic [PROGRAM_MEM_ADDR_BITS-1:0]    program_mem_read_address [PROGRAM_MEM_NUM_CHANNELS-1:0] ; // output
    logic [PROGRAM_MEM_NUM_CHANNELS-1:0] program_mem_read_ready                                  ; // input
    logic [PROGRAM_MEM_DATA_BITS-1:0]    program_mem_read_data    [PROGRAM_MEM_NUM_CHANNELS-1:0] ; // input
                                                                                                            
    logic [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_read_valid                                     ; // output
    logic [DATA_MEM_ADDR_BITS-1:0]       data_mem_read_address    [DATA_MEM_NUM_CHANNELS-1:0]    ; // output
    logic [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_read_ready                                     ; // input
    logic [DATA_MEM_DATA_BITS-1:0]       data_mem_read_data       [DATA_MEM_NUM_CHANNELS-1:0]    ; // input
    logic [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_write_valid                                    ; // output
    logic [DATA_MEM_ADDR_BITS-1:0]       data_mem_write_address   [DATA_MEM_NUM_CHANNELS-1:0]    ; // output
    logic [DATA_MEM_DATA_BITS-1:0]       data_mem_write_data      [DATA_MEM_NUM_CHANNELS-1:0]    ; // output
    logic [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_write_ready                                    ; // input

    clocking drv_cb @(posedge clk);
        input  done                        ; 
        input  program_mem_read_valid      ; 
        input  program_mem_read_address    ; 
        input  data_mem_read_valid         ; 
        input  data_mem_read_address       ; 
        input  data_mem_write_valid        ; 
        input  data_mem_write_address      ; 
        input  data_mem_write_data         ; 
        output start                       ; 
        output device_control_write_enable ; 
        output device_control_data         ; 
        output program_mem_read_ready      ; 
        output program_mem_read_data       ; 
        output data_mem_read_ready         ; 
        output data_mem_read_data          ; 
        output data_mem_write_ready        ; 
    endclocking

    clocking mon_cb @(posedge clk);
        input  start                       ;
        input  done                        ;
        input  device_control_write_enable ;
        input  device_control_data         ;
        input  program_mem_read_valid      ;
        input  program_mem_read_address    ;
        input  program_mem_read_ready      ;
        input  program_mem_read_data       ;
        input  data_mem_read_valid         ;
        input  data_mem_read_address       ;
        input  data_mem_read_ready         ;
        input  data_mem_read_data          ;
        input  data_mem_write_valid        ;
        input  data_mem_write_address      ;
        input  data_mem_write_data         ;
        input  data_mem_write_ready        ;
    endclocking

endinterface

`endif
