//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_rm.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_RM_SV
`define SPI_RM_SV

class spi_rm;
    
    string       name         ;
    mailbox      wr_mon2rm_chan  ;
    mailbox      wr_rm2scb_chan  ;
    mailbox      rd_mon2rm_chan  ;
    mailbox      rd_rm2scb_chan  ;
    spi_reg_cfg  spi_cfg      ;

    data_transaction wr_mon_q[$];
    spi_transaction  wr_scb_q[$];
    spi_transaction  rd_mon_q[$];
    data_transaction rd_scb_q[$];

    function new (string                    name   = " "   , 
                 spi_reg_cfg                spi_cfg        ,
                 mailbox                    wr_mon2rm_chan ,
                 mailbox                    wr_rm2scb_chan ,
                 mailbox                    rd_mon2rm_chan ,
                 mailbox                    rd_rm2scb_chan
                 ); 
        this.name            = name            ;
        this.spi_cfg         = spi_cfg         ;
        this.wr_mon2rm_chan  = wr_mon2rm_chan  ;
        this.wr_rm2scb_chan  = wr_rm2scb_chan  ;
        this.rd_mon2rm_chan  = rd_mon2rm_chan  ;
        this.rd_rm2scb_chan  = rd_rm2scb_chan  ;
    endfunction:new
    extern virtual task          main_phase      ();
    extern virtual task          get_wr_mon_data ();
    extern virtual task          wr_mon_data_proc();
    extern virtual task          put_wr_data     ();
    extern virtual task          get_rd_mon_data ();
    extern virtual task          rd_mon_data_proc();
    extern virtual task          put_rd_data     ();
endclass:spi_data_driver


task spi_rm::main_phase();
    fork
        this.get_wr_mon_data();
        this.wr_mon_data_proc();
        this.put_wr_data();
        this.get_rd_mon_data();
        this.rd_mon_data_proc();
        this.put_rd_data();
    join_none
    $display("=== @%t::%s main_phase() DONE! ===",$time,name)
endtask:main_phase

task spi_rm::get_wr_mon_data();
    data_transaction tr;
    while(1) begin
        this.wr_mon2rm_chan.get(tr);
        this.wr_mon_q.push_back(tr);
    end
endtask:get_wr_mon_data

task spi_rm::get_rd_mon_data();
    spi_transaction tr;
    while(1) begin
        this.rd_mon2rm_chan.get(tr);
        this.rd_mon_q.push_back(tr);
    end
endtask:get_rd_mon_data

task spi_rm::wr_mon_data_proc();
    data_transaction data_tr;
    spi_transaction  spi_tr;
    int num;

    while(1) begin
        wait(this.wr_mon_q.size() > 0);
        data_tr = this.wr_mon_q.pop_front();

        spi_tr = new();
        spi_tr.spi_data = new[spi_cfg.spi_length];
        spi_tr.data_len = spi_cfg.spi_length;

        for(int i = 0; i < spi_cfg.spi_length; i++) begin
            spi_tr.spi_data[i] = (spi_cfg.spi_lsb1st == 1) ? data_tr.rw_data[i] : data_tr.rw_data[spi_cfg.spi_length-i-1];
        end 
        num++;
        spi_tr.print(name,num);
        this.wr_scb_q.push_bask(spi_tr);
    end
endtask:wr_mon_data_proc

task spi_rm::rd_mon_data_proc();
    data_transaction data_tr;
    spi_transaction  spi_tr;
    int num;

    while(1) begin
        wait(this.rd_mon_q.size() > 0);
        spi_tr = this.rd_mon_q.pop_front();
        data_tr = new();
        foreach(spi_tr.spi_data[i]) begin
            data_tr.rw_data[i] = (spi_cfg.spi_lsb1st) ? spi_tr.spi_data[i] : spi_tr.spi_data[spi_cfg.spi_length-i-1];
        end
        num++;
        data_tr.print(name,num);
        this.rd_scb_q.push_bask(data_tr);
    end
endtask:rd_mon_data_proc

task spi_rm::put_wr_data();
    spi_transaction  spi_tr;
    while(1) begin
        wait(this.wr_scb_q.size() > 0);
        spi_tr = this.wr_scb_q.pop_front(); 
        this.wr_rm2scb_chan.put(spi_tr);
    end
endtask:put_wr_data

task spi_rm::put_rd_data();
    data_transaction  data_tr;
    while(1) begin
        wait(this.rd_scb_q.size() > 0);
        data_tr = this.rd_scb_q.pop_front(); 
        this.rd_rm2scb_chan.put(data_tr);
    end
endtask:put_rd_data

`endif
