//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_generator.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_GENERATOR_SV
`define SPI_GENERATOR_SV

class spi_generator;
    
    string      name         ;
    mailbox     gen2drv_chan ;
    spi_reg_cfg spi_cfg      ;

    function new (string   name   = " ", 
                 spi_cfg   spi_cfg     ,
                 mailbox   gen2drv_chan
                 );
        this.name         = name         ;
        this.spi_cfg     = spi_cfg       ;
        this.gen2drv_chan = gen2drv_chan ;
    endfunction:new
    extern virtual function void build_phase  ();
    extern virtual function void connect_phase();
    extern virtual task          main_phase   ();
endclass:spi_data_driver

function void spi_generator::build_phase();
endfunction:build_phase

function void spi_generator::connect_phase();
endfunction:connect_phase

task spi_generator::main_phase();
    data_transaction tr;
    int num;
    if(this.spi_cfg.spi_rxfen == 1'b1) begin
        repeat(plus::plus_data_wr_num) begin
            tr = new();
            tr.randomize();
            num++;
            tr.spi_data = new[this.spi_cfg.spi_lengeth](tr.spi_data);
            tr.print(name,this.spi_cfg.spi_lengeth,num);
            this.gen2drv_channel.put(tr);
        end
    end
    $display("=== @%t::%s main_phase() DONE! ===",$time,name)
endtask:main_phase

`endif
