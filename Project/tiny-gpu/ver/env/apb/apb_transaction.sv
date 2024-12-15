//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : apb_transaction.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV

typedef enum {
               PREAD  = 0,
               PWRITE = 1 
             } apb_wr_op;

class apb_transaction extends uvm_sequence_item;
    
    rand  apb_wr_op    pwrite     ; 
    rand  bit  [31:0 ] paddr      ; 
    rand  bit  [31:0]  pxdata     ;
    rand  bit  [31:0]  op_dly     ;

    `uvm_object_utils_begin(apb_transaction)
        `uvm_field_enum(apb_wr_op,pwrite,UVM_ALL_ON)
        `uvm_field_int(paddr,UVM_ALL_ON)
        `uvm_field_int(pxdata,UVM_ALL_ON)
    `uvm_object_utils_end

    constraint op_dly_c
    {
        op_dly dist >= 0 ;
        op_dly dist <= 20;
    }

    function new (string name = "");
        super.new(name);
    endfunction:new

    extern function void post_randomize();
endclass:apb_transaction

function void apb_transaction::post_randomize();
endfunction:post_randomize
`endif
