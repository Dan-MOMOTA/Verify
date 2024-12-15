//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : plus.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:56:39
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
    `PLUS_ARGS_DEFINE(plus_gpu_en,int,1)
    `PLUS_ARGS_DEFINE(plus_gpu_mode_00_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_mode_01_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_mode_10_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_mode_11_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_lsb1st_en_wt,int,50)
    `PLUS_ARGS_DEFINE(plus_gpu_length_8_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_length_16_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_length_24_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_gpu_length_32_wt,int,25)
    `PLUS_ARGS_DEFINE(plus_rxfen_en,int,1)
    `PLUS_ARGS_DEFINE(plus_gpu_txfthres_min_wt,int,20)
    `PLUS_ARGS_DEFINE(plus_gpu_txfthres_mid_wt,int,70)
    `PLUS_ARGS_DEFINE(plus_gpu_txfthres_max_wt,int,10)
    `PLUS_ARGS_DEFINE(plus_gpu_rxfthres_min_wt,int,20)
    `PLUS_ARGS_DEFINE(plus_gpu_rxfthres_mid_wt,int,70)
    `PLUS_ARGS_DEFINE(plus_gpu_rxfthres_max_wt,int,10)
    `PLUS_ARGS_DEFINE(plus_gpu_baudrate_min_wt,int,10)
    `PLUS_ARGS_DEFINE(plus_gpu_baudrate_mid_wt,int,80)
    `PLUS_ARGS_DEFINE(plus_gpu_baudrate_max_wt,int,10)
    `PLUS_ARGS_DEFINE(plus_gpu_endintr_ena_en,int,1)
    `PLUS_ARGS_DEFINE(plus_gpu_txfintr_ena_en,int,1)
    `PLUS_ARGS_DEFINE(plus_gpu_rxfintr_ena_en,int,1)
    `PLUS_ARGS_DEFINE(plus_gpu_rxftointr_ena_en,int,1)
    `PLUS_ARGS_DEFINE(plus_gpu_rxf_timeout_min_wt,int,10)
    `PLUS_ARGS_DEFINE(plus_gpu_rxf_timeout_mid_wt,int,80)
    `PLUS_ARGS_DEFINE(plus_gpu_rxf_timeout_max_wt,int,10)
    `PLUS_ARGS_DEFINE(plus_gpu_wr_data_num,int,100)
    `PLUS_ARGS_DEFINE(plus_main_phase_drain_time,int,5000000)
    extern function new();
endclass:plus
        
function plus::new();
    `PLUS_ARGS_DECLARE(plus_gpu_en,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_mode_00_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_mode_01_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_mode_10_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_mode_11_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_lsb1st_en_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_length_8_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_length_16_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_length_24_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_length_32_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_rxfen_en,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_txfthres_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_txfthres_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_txfthres_max_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxfthres_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxfthres_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxfthres_max_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_baudrate_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_baudrate_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_baudrate_max_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_endintr_ena_en,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_txfintr_ena_en,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxfintr_ena_en,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxftointr_ena_en,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxf_timeout_min_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxf_timeout_mid_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_rxf_timeout_max_wt,%0d)
    `PLUS_ARGS_DECLARE(plus_gpu_wr_data_num,%0d)    
    `PLUS_ARGS_DECLARE(plus_main_phase_drain_time,%0d)
endfunction:new

`endif
