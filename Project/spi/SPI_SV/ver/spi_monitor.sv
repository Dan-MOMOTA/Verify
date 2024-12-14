//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_monitor.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_MONITOR_SV
`define SPI_MONITOR_SV

class spi_monitor;
    
    string       name             ;
    mailbox      wr_mon2scb_chan  ;
    mailbox      rd_mon2rm_chan   ;
    spi_reg_cfg  spi_cfg          ;

    virtual spi_interface mon_spi_if  ;

    function new (string               name   = " "   , 
                 spi_reg_cfg           spi_cfg        ,
                 virtual spi_interface mon_spi_if     ,
                 mailbox               wr_mon2scb_chan,
                 mailbox               rd_mon2rm_chan
                 ); 
        this.name            = name            ;
        this.spi_cfg         = spi_cfg         ;
        this.mon_data_if     = mon_data_if     ;
        this.wr_mon2scb_chan = wr_mon2scb_chan ;
        this.rd_mon2rm_chan  = rd_mon2rm_chan  ;
    endfunction:new
    extern virtual task          wr_data_sample ();
    extern virtual task          rd_data_sample ();
    extern virtual task          main_phase     ();
endclass:spi_data_driver

task spi_data_monitor::wr_data_sample();
    spi_transaction  tr ;
    int              num;

    while(1) begin
        wait(this.mon_spi_if.csn == 0);
        tr = new();
        tr.spi_data = new[this.spi_cfg.spi_length];
        foreach (tr.spi_data[i]) begin
            case(spi_cfg.spi_mode)
                2'b00,2'b11: begin
                    @this.mon_spi_if.mon_p_cb;
                    tr.spi_data[i] = this.mon_spi_if.mon_p_cb.mosi;
                end
                2'b01,2'b10: begin
                    @this.mon_spi_if.mon_n_cb;
                    tr.spi_data[i] = this.mon_spi_if.mon_n_cb.mosi;
                end
            endcase
        end
        tr.data_len = this.spi_cfg.spi_length;
        num++;
        tr.print(name,num);
        this.wr_mon2scb_chan.put(tr);
    end
endtask

task spi_data_monitor::rd_data_sample();
    spi_transaction  tr ;
    int              num;

    if(spi_cfg.spi_rxfen == 1'b1) begin
        while(1) begin
            wait(this.mon_spi_if.csn == 0);
            tr = new();
            tr.spi_data = new[this.spi_cfg.spi_length];
            foreach (tr.spi_data[i]) begin
                case(spi_cfg.spi_mode)
                    2'b00,2'b11: begin           
                        @this.mon_spi_if.mon_p_cb;
                        tr.spi_data[i] = this.mon_spi_if.mon_p_cb.miso;
                    end
                    2'b01,2'b10: begin
                        @this.mon_spi_if.mon_n_cb;
                        tr.spi_data[i] = this.mon_spi_if.mon_n_cb.miso;
                    end
                endcase
            end
            tr.data_len = this.spi_cfg.spi_length;
            num++;
            tr.print(name,num);
            this.rd_mon2rm_chan.put(tr);
        end
    end
endtask

task spi_monitor::main_phase();
    fork
        this.wr_data_sample();
        this.rd_data_sample();
    join_none
    $display("=== @%t::%s main_phase() DONE! ===",$time,name)
endtask:main_phase

`endif
