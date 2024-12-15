//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : spi_cfg.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_CFG_SV
`define SPI_CFG_SV

class spi_cfg extends uvm_sequence_item;
    
    //1.CRTL_REG
    rand  bit          spi_enable_reg   ;
    rand  bit  [2:1]   spi_mode_reg     ;
    rand  bit          spi_lsb1st_reg   ;
    rand  bit  [2:1]   spi_length_reg   ;
    rand  bit          spi_rxfen_reg    ;
    rand  bit  [5:0]   spi_txfthres_reg ;
    rand  bit  [5:0]   spi_rxfthres_reg ;
    rand  bit  [31:0]  ctrl_reg         ;//0x00

    //2.BAUD_REG
    rand  bit  [7:0]   spi_baudrate_reg ;
    rand  bit  [31:0]  baud_reg         ;//0x08

    //3.INTR_ENA_REG
    rand  bit          spi_endintr_ena_reg   ;
    rand  bit          spi_txfintr_ena_reg   ;
    rand  bit          spi_rxfintr_ena_reg   ;
    rand  bit          spi_rxftointr_ena_reg ;
    rand  bit  [31:0]  intr_ena_reg          ;//0x1c

    //4.RXFIFO_TIMEOUT_REG
    rand  bit  [31:0]  spi_rxf_timeout_reg   ;//0x24

    rand  bit  [31:0]  spi_len               ;

    `uvm_object_utils_begin(spi_cfg)
        `uvm_field_int(spi_enable_reg,UVM_ALL_ON)
        `uvm_field_int(spi_mode_reg,UVM_ALL_ON)
        `uvm_field_int(spi_lsb1st_reg,UVM_ALL_ON)
        `uvm_field_int(spi_length_reg,UVM_ALL_ON)
        `uvm_field_int(spi_rxfen_reg,UVM_ALL_ON)    
        `uvm_field_int(spi_txfthres_reg,UVM_ALL_ON)
        `uvm_field_int(spi_rxfthres_reg,UVM_ALL_ON)
        `uvm_field_int(ctrl_reg,UVM_ALL_ON)
        `uvm_field_int(spi_baudrate_reg,UVM_ALL_ON)
        `uvm_field_int(baud_reg,UVM_ALL_ON)
        `uvm_field_int(spi_endintr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(spi_txfintr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(spi_rxfintr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(spi_rxftointr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(intr_ena_reg,UVM_ALL_ON)
        `uvm_field_int(spi_len,UVM_ALL_ON)
    `uvm_object_utils_end

    constraint ctrl_reg_c
    {
        spi_enable_reg == plus::plus_spi_en;

        spi_mode_reg dist{
            2'b00:/plus::plus_spi_mode_00_wt,
            2'b01:/plus::plus_spi_mode_01_wt,
            2'b10:/plus::plus_spi_mode_10_wt,
            2'b11:/plus::plus_spi_mode_11_wt            
        };

        spi_lsb1st_reg dist{
            2'b00:/100-plus::plus_spi_lsb1st_en_wt,
            2'b01:/plus::plus_spi_lsb1st_en_wt        
        };

        spi_length_reg dist{
            2'b00:/plus::plus_spi_length_8_wt,
            2'b01:/plus::plus_spi_length_16_wt,
            2'b10:/plus::plus_spi_length_24_wt,
            2'b11:/plus::plus_spi_length_32_wt     
        };

        spi_rxfen_reg == plus::plus_rxfen_en;

        spi_txfthres_reg dist{
            6'd1          :/plus::plus_spi_txfthres_min_wt,
            [6'd2 :6'd14] :/plus::plus_spi_txfthres_mid_wt,
            [6'd15:6'd16] :/plus::plus_spi_txfthres_max_wt 
        };

        spi_rxfthres_reg dist{
            6'd1          :/plus::plus_spi_rxfthres_min_wt,
            [6'd2 :6'd14] :/plus::plus_spi_rxfthres_mid_wt,
            [6'd15:6'd16] :/plus::plus_spi_rxfthres_max_wt 
        };
    }

    constraint spi_baudrate_reg_c
    {
        baud_reg dist{
            8'd1          :/plus::plus_spi_baudrate_min_wt,
            [8'd2:8'd127] :/plus::plus_spi_baudrate_mid_wt,
            8'd128        :/plus::plus_spi_baudrate_max_wt
        }
    }

    constraint intr_ena_reg
    {
        spi_endintr_ena_reg   == plus::plus_spi_endintr_ena_en   ; 
        spi_txfintr_ena_reg   == plus::plus_spi_txfintr_ena_en   ;
        spi_rxfintr_ena_reg   == plus::plus_spi_rxfintr_ena_en   ;
        spi_rxftointr_ena_reg == plus::plus_spi_rxftointr_ena_en ;
    }

    constraint spi_rxf_timeout_reg_c
    {
        spi_rxf_timeout_reg dist{
            100       :/plus::plus_spi_rxf_timeout_min_wt,
            [101:499] :/plus::plus_spi_rxf_timeout_mid_wt,
            500       :/plus::plus_spi_rxf_timeout_max_wt
        }
    }

    function new (string name = "");
        super.new(name);
    endfunction:new

    extern function void post_randomize();
endclass:spi_cfg

function void spi_cfg::post_randomize();
    ctrl_reg[0]   = spi_enable_reg;
    ctrl_reg[2:1] = spi_mode_reg;
    ctrl_reg[3]   = spi_lsb1st_reg;
    ctrl_reg[5:4] = spi_length_reg;
    ctrl_reg[6]   = spi_rxfen_reg;
    ctrl_reg[13:8]  = spi_txfthres_reg;
    ctrl_reg[21:16] = spi_rxfthres_reg;

    baud_reg[7:0] = spi_baudrate_reg;

    intr_ena_reg[0] = spi_endintr_ena_reg;
    intr_ena_reg[1] = spi_txfintr_ena_reg;
    intr_ena_reg[2] = spi_rxfintr_ena_reg;
    intr_ena_reg[3] = spi_rxftointr_ena_reg;

    spi_len = (spi_length_reg + 1) * 8;
    
endfunction:post_randomize

`endif