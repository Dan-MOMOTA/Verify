//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_cfg.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:52:39
// Description : 
// 
//================================================================

`ifndef GPU_CFG_SV
`define GPU_CFG_SV

class gpu_cfg extends uvm_sequence_item;
    
    //1.CRTL_REG
    rand  bit          gpu_enable_reg   ;
    rand  bit  [2:1]   gpu_mode_reg     ;
    rand  bit          gpu_lsb1st_reg   ;
    rand  bit  [2:1]   gpu_length_reg   ;
    rand  bit          gpu_rxfen_reg    ;
    rand  bit  [5:0]   gpu_txfthres_reg ;
    rand  bit  [5:0]   gpu_rxfthres_reg ;
    rand  bit  [31:0]  ctrl_reg         ;//0x00

    //2.BAUD_REG
    rand  bit  [7:0]   gpu_baudrate_reg ;
    rand  bit  [31:0]  baud_reg         ;//0x08

    //3.INTR_ENA_REG
    rand  bit          gpu_endintr_ena_reg   ;
    rand  bit          gpu_txfintr_ena_reg   ;
    rand  bit          gpu_rxfintr_ena_reg   ;
    rand  bit          gpu_rxftointr_ena_reg ;
    rand  bit  [31:0]  intr_ena_reg          ;//0x1c

    //4.RXFIFO_TIMEOUT_REG
    rand  bit  [31:0]  gpu_rxf_timeout_reg   ;//0x24

    rand  bit  [31:0]  gpu_len               ;

    `uvm_object_utils_begin(gpu_cfg)
        `uvm_field_int(gpu_enable_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_mode_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_lsb1st_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_length_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_rxfen_reg,UVM_ALL_ON)    
        `uvm_field_int(gpu_txfthres_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_rxfthres_reg,UVM_ALL_ON)
        `uvm_field_int(ctrl_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_baudrate_reg,UVM_ALL_ON)
        `uvm_field_int(baud_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_endintr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_txfintr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_rxfintr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_rxftointr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(intr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(gpu_len,UVM_ALL_ON)
    `uvm_object_utils_end

    constraint ctrl_reg_c
    {
        gpu_enable_reg == plus::plus_gpu_en;

        gpu_mode_reg dist{
            2'b00:/plus::plus_gpu_mode_00_wt,
            2'b01:/plus::plus_gpu_mode_01_wt,
            2'b10:/plus::plus_gpu_mode_10_wt,
            2'b11:/plus::plus_gpu_mode_11_wt            
        };

        gpu_lsb1st_reg dist{
            2'b00:/100-plus::plus_gpu_lsb1st_en_wt,
            2'b01:/plus::plus_gpu_lsb1st_en_wt        
        };

        gpu_length_reg dist{
            2'b00:/plus::plus_gpu_length_8_wt,
            2'b01:/plus::plus_gpu_length_16_wt,
            2'b10:/plus::plus_gpu_length_24_wt,
            2'b11:/plus::plus_gpu_length_32_wt     
        };

        gpu_rxfen_reg == plus::plus_rxfen_en;

        gpu_txfthres_reg dist{
            6'd1          :/plus::plus_gpu_txfthres_min_wt,
            [6'd2 :6'd14] :/plus::plus_gpu_txfthres_mid_wt,
            [6'd15:6'd16] :/plus::plus_gpu_txfthres_max_wt 
        };

        gpu_rxfthres_reg dist{
            6'd1          :/plus::plus_gpu_rxfthres_min_wt,
            [6'd2 :6'd14] :/plus::plus_gpu_rxfthres_mid_wt,
            [6'd15:6'd16] :/plus::plus_gpu_rxfthres_max_wt 
        };
    }

    constraint gpu_baudrate_reg_c
    {
        baud_reg dist{
            8'd1          :/plus::plus_gpu_baudrate_min_wt,
            [8'd2:8'd127] :/plus::plus_gpu_baudrate_mid_wt,
            8'd128        :/plus::plus_gpu_baudrate_max_wt
        };
    }

    constraint intr_ena_reg_c
    {
        gpu_endintr_ena_reg   == plus::plus_gpu_endintr_ena_en   ; 
        gpu_txfintr_ena_reg   == plus::plus_gpu_txfintr_ena_en   ;
        gpu_rxfintr_ena_reg   == plus::plus_gpu_rxfintr_ena_en   ;
        gpu_rxftointr_ena_reg == plus::plus_gpu_rxftointr_ena_en ;
    }

    constraint gpu_rxf_timeout_reg_c
    {
        gpu_rxf_timeout_reg dist{
            100       :/plus::plus_gpu_rxf_timeout_min_wt,
            [101:499] :/plus::plus_gpu_rxf_timeout_mid_wt,
            500       :/plus::plus_gpu_rxf_timeout_max_wt
        };
    }

    function new (string name = "");
        super.new(name);
    endfunction:new

    extern function void post_randomize();
endclass:gpu_cfg

function void gpu_cfg::post_randomize();
    ctrl_reg[0]   = gpu_enable_reg;
    ctrl_reg[2:1] = gpu_mode_reg;
    ctrl_reg[3]   = gpu_lsb1st_reg;
    ctrl_reg[5:4] = gpu_length_reg;
    ctrl_reg[6]   = gpu_rxfen_reg;
    ctrl_reg[13:8]  = gpu_txfthres_reg;
    ctrl_reg[21:16] = gpu_rxfthres_reg;

    baud_reg[7:0] = gpu_baudrate_reg;

    intr_ena_reg[0] = gpu_endintr_ena_reg;
    intr_ena_reg[1] = gpu_txfintr_ena_reg;
    intr_ena_reg[2] = gpu_rxfintr_ena_reg;
    intr_ena_reg[3] = gpu_rxftointr_ena_reg;

    gpu_len = (gpu_length_reg + 1) * 8;
    
endfunction:post_randomize

`endif
