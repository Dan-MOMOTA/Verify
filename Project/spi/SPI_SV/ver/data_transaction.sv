//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : data_transaction.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef DATA_TRANSACTION_SV
`define DATA_TRANSACTION_SV

class data_transaction;
    
    rand  bit [31:0]  rw_data      ;
    rand  int         wr_dely      ;

    constraint wr_dely_c {
        wr_dely dist {
            0      :/plus::plus_wr_dely_0_wt,
            [2:10] :/plus::plus_wr_dely_min_wt,
            [11:15]:/plus::plus_wr_dely_mid_wt,
            [16:20]:/plus::plus_wr_dely_max_wt
        }
    }

    function new (string    name   = "");
        super.new(name);
    endfunction:new

    extern virtual function void print(string name,bit[5:0] len = 8,int num);
    extern virtual function bit  compare(data_transaction tr);
endclass:data_transaction

function void data_transaction::print(string name,bit[5:0] len = 8,int num);
    $display("==================================");
    $display("@%s:No.%0d:",name,num);
    case(len)
        8 :$display("rw_data = 'h%0h",i,rw_data[7:0]);
        16:$display("rw_data = 'h%0h",i,rw_data[15:0]);
        24:$display("rw_data = 'h%0h",i,rw_data[23:0]);
        32:$display("rw_data = 'h%0h",i,rw_data[31:0]);
    endcase
endfunction:print

function bit data_transaction::compare(data_transaction tr);
    bit result = 1;
    if(rw_data != tr.rw_data) begin
        result = 1'b0;
    end

    return (result);
endfunction:compare

`endif
