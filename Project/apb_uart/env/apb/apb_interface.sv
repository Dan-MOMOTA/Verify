//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_interface.sv
// Creater     :Dan
// Create Date :2025-01-01 17:18:11
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_INTERFACE_SV
`define APB_INTERFACE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

interface apb_interface #(type ADDR = logic [`APB_ADDR_WIDTH-1:0],
                          type DATA = logic [`APB_DATA_WIDTH-1:0],
                          type SEL  = logic [`APB_SEL_WIDTH-1:0]
                         )
	                     (input PCLK,
                          input PRESETn
                         );
    ADDR         PADDR   ; 
    DATA         PRDATA  ; 
    DATA         PWDATA  ; 
    SEL          PSEL    ; // Only connect the ones that are needed
    logic        PENABLE ; 
    logic        PWRITE  ; 
    logic        PREADY  ; 
    logic        PSLVERR ; 
    
    clocking drv_cb @(posedge PCLK);
        default input #1ns output #0ns;
        output PADDR   ; 
        output PWDATA  ; 
        output PSEL    ; 
        output PENABLE ; 
        output PWRITE  ; 
        input  PRESETn ; 
        input  PRDATA  ; 
        input  PREADY  ; 
        input  PSLVERR ; 
    endclocking
    
    clocking mon_cb @(posedge PCLK);
        input PADDR   ; 
        input PWDATA  ; 
        input PSEL    ; 
        input PENABLE ; 
        input PWRITE  ; 
        input PRESETn ; 
        input PRDATA  ; 
        input PREADY  ; 
        input PSLVERR ; 
    endclocking

    task reset(string name);
        `uvm_info("[APB_INTF]",$sformatf("%s call reset",name),UVM_MEDIUM)
        drv_cb.PADDR   <= 0;
        drv_cb.PWDATA  <= 0;
        drv_cb.PSEL    <= 0;
        drv_cb.PENABLE <= 0;
        drv_cb.PWRITE  <= 0;
    endtask:reset

    property psel_valid;
        @(posedge PCLK)
            !$isunknown(PSEL);
    endproperty

    CHK_PSEL: assert property(psel_valid);
    COVER_PSEL: cover property(psel_valid);

    // TODO
    // complete assertion
endinterface

`endif
