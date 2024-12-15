//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_transaction.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_TRANSACTION_SV
`define SPI_TRANSACTION_SV

class spi_transaction extends uvm_sequence_item;
    
    rand  bit        spi_data[]      ;
    rand  bit  [5:0] data_len        ;    //8/16/24/32

    `uvm_object_utils_begin(spi_transaction)
        `uvm_field_array_int(spi_data,UVM_ALL_ON)
        `uvm_field_int(data_len,UVM_ALL_ON)
    `uvm_object_utils_end

    constraint data_len_c {
        spi_data.size() == data_len;
    }

    function new (string name = "");
        super.new(name);
    endfunction:new
endclass:spi_transaction

`endif
