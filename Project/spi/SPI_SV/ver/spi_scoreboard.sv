//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_scoreboard.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_SCOREBOARD_SV
`define SPI_SCOREBOARD_SV

class spi_scoreboard;

    string name ;

    mailbox wr_rm2scb_chan ;
    mailbox wr_mon2scb_chan;
    mailbox rd_rm2scb_chan ;
    mailbox rd_mon2scb_chan;

    spi_transaction  wr_exp_tr_q[$];
    spi_transaction  wr_act_tr_q[$];
    data_transaction rd_exp_tr_q[$];
    data_transaction rd_act_tr_q[$];

    bit             compare_error ;

    function new (string                     name   = " "  , 
                  mailbox                   wr_rm2scb_chan ,
                  mailbox                   wr_mon2scb_chan,
                  mailbox                   rd_rm2scb_chan ,
                  mailbox                   rd_mon2scb_chan
                 );
        this.name            = name            ;
        this.wr_rm2scb_chan  = wr_rm2scb_chan  ;
        this.wr_mon2scb_chan = wr_mon2scb_chan ;
        this.rd_rm2scb_chan  = rd_rm2scb_chan  ;
        this.rd_mon2scb_chan = rd_mon2scb_chan ;
    endfunction:new
    extern virtual task          main_phase    ();
    extern virtual task          get_wr_rm_tr  ();
    extern virtual task          get_wr_mon_tr ();
    extern virtual task          compare_wr_tr ();
    extern virtual task          get_rd_rm_tr  ();
    extern virtual task          get_rd_mon_tr ();
    extern virtual task          compare_rd_tr ();
    extern virtual task          end_sim_check ();
endclass:spi_scoreboard

task spi_scoreboard::main_phase();
    fork
        this.get_wr_rm_tr();
        this.get_wr_mon_tr();
        this.comepare_wr_tr();
        this.get_rd_rm_tr();
        this.get_rd_mon_tr();
        this.comepare_rd_tr();
    join
endtask:main_phase

task spi_scoreboard::get_wr_rm_tr();
    spi_transaction exp_tr;
    while(1) begin
        this.wr_rm2scb_chan.get(exp_tr);
        this.wr_exp_tr_q.push_back(exp_tr);
    end
endtask:get_wr_rm_tr

task spi_scoreboard::get_rd_rm_tr();
    data_transaction exp_tr;
    while(1) begin
        this.rd_rm2scb_chan.get(exp_tr);
        this.rd_exp_tr_q.push_back(exp_tr);
    end
endtask:get_rd_rm_tr

task spi_scoreboard::get_wr_mon_tr();
    spi_transaction act_tr;
    while(1) begin
        this.wr_mon2scb_chan.get(act_tr);
        this.wr_act_tr_q.push_back(act_tr);
    end
endtask:get_wr_mon_tr

task spi_scoreboard::get_rd_mon_tr();
    data_transaction act_tr;
    while(1) begin
        this.rd_mon2scb_chan.get(act_tr);
        this.rd_act_tr_q.push_back(act_tr);
    end
endtask:get_rd_mon_tr

task spi_scoreboard::compare_wr_tr();
    spi_transaction exp_tr;
    spi_transaction act_tr;
    int num;
    while(1) begin
        wait(this.wr_exp_tr_q.size() > 0);
        wait(this.wr_act_tr_q.size() > 0);
        exp_tr = this.wr_exp_tr_q.pop_front();
        act_tr = this.wr_act_tr_q.pop_front();
        result = exp_tr.compare(act_tr);
        num++;
        if(result == 1'b1) begin
            $display("No.%0d:WR_PASSED!!",num);
        end
        else begin
            $error("No.%0d:WR_FAILED!!",num);
            compare_error = 1;
        end
        exp_tr.print($sformatf("%0s:WR_EXP",naem),num);
        act_tr.print($sformatf("%0s:WR_ACT",naem),num);
    end
endtask:compare_wr_tr

task spi_scoreboard::compare_rd_tr();
    data_transaction exp_tr;
    data_transaction act_tr;
    int num;
    while(1) begin
        wait(this.rd_exp_tr_q.size() > 0);
        wait(this.rd_act_tr_q.size() > 0);
        exp_tr = this.rd_exp_tr_q.pop_front();
        act_tr = this.rd_act_tr_q.pop_front();
        result = exp_tr.compare(act_tr);
        num++;
        if(result == 1'b1) begin
            $display("No.%0d:RD_PASSED!!",num);
        end
        else begin
            $error("No.%0d:RD_FAILED!!",num);
            compare_error = 1;
        end
        exp_tr.print($sformatf("%0s:RD_EXP",naem),32,num);
        act_tr.print($sformatf("%0s:RD_ACT",naem),32,num);
    end
endtask:compare_rd_tr

task spi_scoreboard::end_sim_check();
    if(compare_error == 1) begin
        $display("\n");
        $display("+---------------------------------+");
        $display("| Simulation Result:FAILED |");
        $display("+---------------------------------+");
        $display("\n");
    end
    else begin
        $display("\n");
        $display("+---------------------------------+");
        $display("| Simulation Result:PASSED |");
        $display("+---------------------------------+");
        $display("\n");
    end
endtask:end_sim_check

`endif
