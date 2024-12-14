//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_data_monitor.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_DATA_MONITOR_SV
`define SPI_DATA_MONITOR_SV

class spi_data_monitor;
    
    string       name         ;
    mailbox      wr_mon2rm_chan   ;
    mailbox      rd_mon2scb_chan  ;

    virtual spi_data_interface mon_data_if  ;

    function new (string                    name   = " "   , 
                 virtual spi_data_interface mon_data_if    ,
                 mailbox                    wr_mon2rm_chan ,
                 mailbox                    rd_mon2scb_chan
                 ); 
        this.name            = name            ;
        this.mon_data_if     = mon_data_if     ;
        this.wr_mon2rm_chan  = wr_mon2rm_chan  ;
        this.rd_mon2scb_chan = rd_mon2scb_chan ;
    endfunction:new
    extern virtual task          wr_data_sample  ();
    extern virtual task          rd_data_sample  ();
    extern virtual task          main_phase      ();
endclass:spi_data_driver

task spi_data_monitor::main_phase();
    fork
        this.wr_data_sample();
        this.rd_data_sample();
    join_none
    $display("=== @%t::%s main_phase() DONE! ===",$time,name)
endtask:main_phase

task spi_data_monitor::wr_data_sample();
    data_transaction tr ;
    int              num;

    while(1) begin
        @this.mon_data_if.mon_cb;
        if(this.mon_data_if.mon_cb.spi_wr_vld) begin
            tr = new();
            tr.rw_data = this.mon_data_if.mon_cb.spi_wr_data;
            this.wr_mon2rm_chan.put(tr);
            tr.print(name,32,num);
        end
    end
endtask

task spi_data_monitor::rd_data_sample();
    data_transaction tr ;
    int              num;

    while(1) begin
        @this.mon_data_if.mon_cb;
        if(this.mon_data_if.mon_cb.spi_rd_vld) begin
            tr = new();
            tr.rw_data = this.mon_data_if.mon_cb.spi_rd_data;
            this.rd_mon2scb_chan.put(tr);
            tr.print("rd_data_mon",32,num);
        end
    end
endtask

`endif
