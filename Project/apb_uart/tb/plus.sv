//================================================================
// Copyright (C) 2025 Dan. All rights reserved.
// 
// File Name   : plus.sv
// Creator     : Dan
// Create Date : 2025-01-04- 22:16:39
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
    `PLUS_ARGS_DEFINE(plus_main_phase_drain_time,int,10000)
    extern function new();
endclass:plus
        
function plus::new();
    `PLUS_ARGS_DECLARE(plus_main_phase_drain_time,%0d)
endfunction:new

`endif
