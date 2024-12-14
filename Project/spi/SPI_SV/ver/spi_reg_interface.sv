//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_reg_interface.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_REG_INTERFACE_SV
`define SPI_REG_INTERFACE_SV

interface spi_reg_interface(
                              input  clk,
                              input  rst_n
                             );

    logic  [1:0]   spi_mode_reg     ; 
    logic  [7:0]   spi_baudrate_reg ; 
    logic  [5:0]   spi_length_reg   ; 
    logic          spi_lsb1st_reg   ; 
    logic          spi_rxfen_reg    ; 
    logic          spi_intr_reg     ;

    clocking drv_cb @(posedge clk);
        output spi_mode_reg     ;
        output spi_baudrate_reg ;
        output spi_length_reg   ;
        output spi_lsb1st_reg   ;
        output spi_rxfen_reg    ;
        input  spi_intr_reg     ;
    endclocking

    clocking mon_cb @(posedge clk);
        input spi_mode_reg     ;
        input spi_baudrate_reg ;
        input spi_length_reg   ;
        input spi_lsb1st_reg   ;
        input spi_rxfen_reg    ;
        input spi_intr_reg     ;
    endclocking
    
endinterface

`endif
