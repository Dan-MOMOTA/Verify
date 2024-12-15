//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : apb_interface.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef APB_INTERFACE_SV
`define APB_INTERFACE_SV

interface apb_interface(
                        input  pclk,
                        input  prst_n
                        );

    logic             psel      ; 
    logic             penable   ; 
    logic      [31:0] paddr     ; 
    logic      [31:0] pwdata    ; 
    logic      [31:0] prdata    ; 
    logic             pwrite    ; 
    logic             pready    ; 

    clocking drv_cb @(posedge pclk);
        default input #1ns output #0;
        output psel     ;
        output penable  ;
        output paddr    ;
        output pwrite   ;
        output pwdata   ;
        input  pradta   ;
        input  pready   ;
    endclocking

    clocking mon_cb @(posedge pclk);
        default input #1ns output #0;
        input  psel     ;
        input  penable  ;
        input  paddr    ;
        input  pwrite   ;
        input  pwdata   ;
        input  pradta   ;
        input  pready   ;
    endclocking
    
endinterface

`endif
