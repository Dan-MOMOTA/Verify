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

class spi_transaction;
    
    rand  bit        spi_data[]      ;
    rand  bit  [5:0] data_len        ;    //8/16/24/32

    constraint data_len_c {
        spi.data.size() == data_len;
    }

    function new (string    name   = "");
        super.new(name);
    endfunction:new

    extern virtual function void print(string name,int num);
    extern virtual function bit  compare(spi_transaction tr);
endclass:spi_transaction

function void spi_transaction::print(string name,int num);
    $display("==================================");
    $display("@%s:No.%0d:",name,num);
    $display(spi_data);
endfunction:print

function bit spi_transaction::compare(spi_transaction tr);
    bit result = 1;
    if(data_len != tr.data_len) begin
        result = 1'b0;
    end

    foreach(spi_data[i]) begin
        if(spi_data[i] != tr.spi_data[i]) begin
            result = 1'b0;
        end
    end

    return (result);
endfunction:compare

`endif
