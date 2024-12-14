//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_data_interface.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_DATA_INTERFACE_SV
`define SPI_DATA_INTERFACE_SV

interface spi_data_interface(
                              input  clk,
                              input  rst_n
                             );

    logic          spi_wr_vld    ; 
    logic  [31:0]  spi_wr_data   ; 
    logic          spi_rd_vld    ; 
    logic  [31:0]  spi_rd_data   ;
    logic          spi_intr_reg  ;

    clocking drv_cb @(posedge clk);
        output spi_wr_vld     ;
        output spi_wr_data    ;
        input  spi_rd_vld     ;
        input  spi_rd_data    ;
        input  spi_intr_reg   ;
    endclocking

    clocking mon_cb @(posedge clk);
        input spi_wr_vld     ;
        input spi_wr_data    ;
        input spi_rd_vld     ;
        input spi_rd_data    ;
        input spi_intr_reg   ;
    endclocking
    
endinterface

`endif
