//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_interface.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_INTERFACE_SV
`define SPI_INTERFACE_SV

interface spi_interface(
                        input  clk
                        );

    logic      csn     ; 
    logic      mosi    ; 
    logic      miso    ; 

    clocking drv_p_cb @(posedge clk);
        output miso     ;
        input  csn      ;
        input  mosi     ;
    endclocking

    clocking drv_n_cb @(negedge clk);
        output miso     ;
        input  csn      ;
        input  mosi     ;
    endclocking

    clocking mon_p_cb @(posedge clk);
        input csn      ;
        input miso     ;
        input mosi     ;
    endclocking
    
    clocking mon_n_cb @(negedge clk);
        input csn      ;
        input miso     ;
        input mosi     ;
    endclocking

endinterface

`endif
