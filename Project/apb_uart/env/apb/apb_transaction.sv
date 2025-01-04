//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_transaction.sv
// Creater     :Dan
// Create Date :2025-01-04 19:05:28
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

class apb_transaction extends uvm_sequence_item;

    rand bit [31:0] paddr ;
    rand bit [31:0] data  ; // pwdata or prdata
    rand bit        pwrite;

    `uvm_object_utils_begin(apb_transaction)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(pwrite, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = " ");
        super.new(name);
    endfunction:new

    // constraint

endclass:apb_transaction

`endif 
