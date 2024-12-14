//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : plus.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef PLUS_SV
`define PLUS_SV

`define PLUS_ARGS_DEFINE(name,typ,val)\
        static typ name=val;

`define PLUS_ARGS_DECLARE(name,format)\
        $value$plusargs("name=format",name);\
        $display("+name=format",name);

class plus;
    `PLUS_ARGS_DEFINE(plus_mode_00_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_mode_01_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_mode_10_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_mode_11_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_baudrate_1_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_baudrate_min_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_baudrate_mid_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_baudrate_max_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_length_8_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_length_16_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_length_24_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_length_32_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_lsb1st_1_wt,int,50)
    `PLUS_ARGS_DEFINE(plus_rxfen_en_wt,int,0)
    `PLUS_ARGS_DEFINE(plus_data_length_1_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_data_length_min_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_data_length_mid_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_data_length_max_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_data_wr_num,int,10)
    `PLUS_ARGS_DEFINE(plus_wr_dely_0_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_wr_dely_min_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_wr_dely_mid_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_wr_dely_max_wt,int,25)
    extern function new();
endclass:plus
        
function plus::new();
    `PLUS_ARGS_DECLARE(plus_mode_00_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_mode_01_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_mode_10_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_mode_11_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_baudrate_1_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_baudrate_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_baudrate_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_baudrate_max_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_length_8_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_length_16_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_length_24_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_length_32_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_lsb1st_1_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_rxfen_en_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_data_length_1_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_data_length_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_data_length_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_data_length_max_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_data_wr_num,%0d)
    `PLUS_ARGS_DECLARE(plus_wr_dely_0_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_wr_dely_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_wr_dely_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_wr_dely_max_wt,%0d)
endfunction:new

`endif
