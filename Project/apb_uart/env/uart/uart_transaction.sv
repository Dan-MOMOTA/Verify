//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :uart_transaction.sv
// Creater     :Dan
// Create Date :2025-01-19 23:09:56
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef UART_TRANSACTION_SV
`define UART_TRANSACTION_SV

class uart_transaction extends uvm_sequence_item;

    rand bit data;
    rand bit irq;
    rand bit baud_o;

    `uvm_object_utils_begin(uart_transaction)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(irq, UVM_ALL_ON)
        `uvm_field_int(baud_o, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = " ");
        super.new(name);
    endfunction:new

    // constraint

endclass:uart_transaction

`endif 
