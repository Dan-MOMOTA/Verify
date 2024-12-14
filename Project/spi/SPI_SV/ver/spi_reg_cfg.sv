//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_reg_cfg.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_REG_CFG_SV
`define SPI_REG_CFG_SV

class spi_reg_cfg;
    
    rand  bit  [1:0]   spi_mode     ; 
    rand  bit  [7:0]   spi_baudrate ; 
    rand  bit  [5:0]   spi_length   ; 
    rand  bit          spi_lsb1st   ; 
    rand  bit          spi_rxfen    ;  


    constraint spi_mode_c
    {
        spi_mode dist {
            2'b00:/plus::plus_mode_00_wt,
            2'b01:/plus::plus_mode_01_wt,
            2'b10:/plus::plus_mode_10_wt,
            2'b11:/plus::plus_mode_11_wt
        };
    }

    constraint spi_baudrate_c
    {
        spi_baudrate dist {
            1       :/plus::plus_baudrate_1_wt,
            [2:50]  :/plus::plus_baudrate_min_wt,
            [51:127]:/plus::plus_baudrate_mid_wt,
            128     :/plus::plus_baudrate_max_wt
        };
    }

    constraint spi_length_c
    {
        spi_length dist {
            6'd8 :/plus::plus_length_8_wt,
            6'd16:/plus::plus_length_16_wt,
            6'd24:/plus::plus_lenget_24_wt,
            6'd32:/plus::plus_length_32_wt
        };
    }

    constraint spi_lsb1st_c
    {
        spi_lsb1st dist {
            0:/plus::plus_lsb1st_1_wt,
            1:/100-plus::plus_lsb1st_1_wt
        };
    }

    constraint spi_rxfen_c
    {
        spi_rxfen == plus::plus_rxfen_en;
    }

    function new (string name = "");
        super.new(name);
    endfunction:new
    extern virtual function void print();
endclass:spi_reg_cfg

function void spi_reg_cfg::print();
    $display("===== SPI REG CFG AS FOLLOW: =====");
    $display("      spi_mode     = 2'b%0b ",spi_mode);
    $display("      spi_baudrate = %0d    ",spi_baudrate);
    $display("      spi_lengeth  = %0d    ",spi_length);
    $display("      spi_lsb1st   = %0d    ",spi_lsb1st);
    $display("      spi_rxfen    = %0d    ",spi_rxfen);
    $display("==================================");
endfunction:print

`endif
