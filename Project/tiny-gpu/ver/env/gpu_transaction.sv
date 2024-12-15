//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : gpu_transaction.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:29:39
// Description : 
// 
//================================================================

`ifndef GPU_TRANSACTION_SV
`define GPU_TRANSACTION_SV

class gpu_transaction extends uvm_sequence_item;
    
    rand  bit        gpu_data[]      ;
    rand  bit  [5:0] data_len        ;    //8/16/24/32

    `uvm_object_utils_begin(gpu_transaction)
        `uvm_field_array_int(gpu_data,UVM_ALL_ON)
        `uvm_field_int(data_len,UVM_ALL_ON)
    `uvm_object_utils_end

    constraint data_len_c {
        gpu_data.size() == data_len;
    }

    function new (string name = "");
        super.new(name);
    endfunction:new

endclass:gpu_transaction

`endif
