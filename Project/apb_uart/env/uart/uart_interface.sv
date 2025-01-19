//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :uart_interface.sv
// Creater     :Dan
// Create Date :2025-01-01 17:26:11
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef UART_INTERFACE_SV
`define UART_INTERFACE_SV

interface uart_interface(input clk  ,
                         input rst_n
                        );
    logic RXD    ; 
    logic TXD    ; 
    logic IRQ    ; 
    logic baud_o ; 

    task reset(string name);
        `uvm_info("[UART_INTF]",$sformatf("%s call reset",name),UVM_MEDIUM)
        RXD <= 0;
    endtask:reset

endinterface

`endif 
