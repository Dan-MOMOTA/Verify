//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_scoreboard.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:48:14
// Description : 
// 
//================================================================

`ifndef GPU_SCOREBOARD_SV
`define GPU_SCOREBOARD_SV

class gpu_scoreboard extends uvm_scoreboard;

    string    name         ;
    
    uvm_blocking_get_port#(gpu_transaction) wr_act_port;
    uvm_blocking_get_port#(gpu_transaction) wr_exp_port;
    //uvm_blocking_get_port#(apb_transaction) rd_act_port;
    //uvm_blocking_get_port#(apb_transaction) rd_exp_port;

    gpu_transaction    wr_act_tr_q[$];
    gpu_transaction    wr_exp_tr_q[$];
    //apb_transaction    rd_act_tr_q[$];
    //apb_transaction    rd_exp_tr_q[$];

    `uvm_component_utils(gpu_scoreboard)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase    (uvm_phase phase);
    extern virtual function void check_phase  (uvm_phase phase);
    extern virtual task          get_wr_mon_tr();
    extern virtual task          get_wr_rm_tr ();
    extern virtual task          compare_wr_tr();
    //extern virtual task          get_rd_mon_tr();
    //extern virtual task          get_rd_rm_tr ();
    //extern virtual task          compare_rd_tr();
endclass:gpu_scoreboard

function void gpu_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_act_port = new("wr_act_port",this);
    wr_exp_port = new("wr_exp_port",this);
    //rd_act_port = new("rd_act_port",this);
    //rd_exp_port = new("rd_exp_port",this);
endfunction:build_phase

function void gpu_scoreboard::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task gpu_scoreboard::run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
        this.get_wr_mon_tr();
        this.get_wr_rm_tr();
        this.compare_wr_tr();
        //this.get_rd_mon_tr();
        //this.get_rd_rm_tr();
        //this.compare_rd_tr();
    join_none
endtask:run_phase

task gpu_scoreboard::get_wr_mon_tr();
    gpu_transaction act_tr;
    int             num   ;
    while(1)begin
        this.wr_act_port.get(act_tr);
        this.wr_act_tr_q.push_back(act_tr);
        num ++;
        `uvm_info(this.name,$sformatf("get_wr_act_tr:No.%0d\n\n %s",num,act_tr.sprint()),UVM_MEDIUM)
    end
endtask:get_wr_mon_tr

//task gpu_scoreboard::get_rd_mon_tr();
//    apb_transaction act_tr;
//    int             num   ;
//    while(1)begin
//        this.rd_act_port.get(act_tr);
//        this.rd_act_tr_q.push_back(act_tr);
//        num ++;
//        `uvm_info(this.name,$sformatf("get_rd_act_tr:No.%0d\n\n %s",num,act_tr.sprint()),UVM_MEDIUM)
//    end
//endtask:get_rd_mon_tr

task gpu_scoreboard::get_wr_rm_tr();
    gpu_transaction exp_tr;
    int             num   ;
    while(1)begin
        this.wr_exp_port.get(exp_tr);
        this.wr_exp_tr_q.push_back(exp_tr);
        num ++;
        `uvm_info(this.name,$sformatf("get_wr_exp_tr:No.%0d\n\n %s",num,exp_tr.sprint()),UVM_MEDIUM)
    end    
endtask:get_wr_rm_tr

//task gpu_scoreboard::get_rd_rm_tr();
//    apb_transaction exp_tr;
//    int             num   ;
//    while(1)begin
//        this.rd_exp_port.get(exp_tr);
//        this.rd_exp_tr_q.push_back(exp_tr);
//        num ++;
//        `uvm_info(this.name,$sformatf("get_rd_exp_tr:No.%0d\n\n %s",num,exp_tr.sprint()),UVM_MEDIUM)
//    end    
//endtask:get_rd_rm_tr

task gpu_scoreboard::compare_wr_tr();
    gpu_transaction exp_tr;
    gpu_transaction act_tr;
    int             num   ;
    bit             result;
    while(1)begin
        wait(this.wr_act_tr_q.size() > 0);    
        wait(this.wr_exp_tr_q.size() > 0);
        exp_tr = this.wr_exp_tr_q.pop_front();
        act_tr = this.wr_act_tr_q.pop_front();
        result = act_tr.compare(exp_tr);
        num ++;
        if(result == 1)begin
            `uvm_info(get_full_name(),$sformatf("SCB:No.%0d:compare result:PASSED!!\n",num),UVM_MEDIUM)
        end
        else begin
            `uvm_error(get_full_name(),$sformatf("SCB:No.%0d:compare result:FAILED!!\n",num))
        end
        `uvm_info(get_full_name(),$sformatf("WR_EXP:No.%0d\n\n %s",num,exp_tr.sprint()),UVM_MEDIUM)
        `uvm_info(get_full_name(),$sformatf("WR_ACT:No.%0d\n\n %s",num,act_tr.sprint()),UVM_MEDIUM)
    end
endtask:compare_wr_tr

//task gpu_scoreboard::compare_rd_tr();
//    apb_transaction exp_tr;
//    apb_transaction act_tr;
//    int             num   ;
//    bit             result;
//    while(1)begin
//        wait(this.rd_act_tr_q.size() > 0);    
//        wait(this.rd_exp_tr_q.size() > 0);
//        exp_tr = this.rd_exp_tr_q.pop_front();
//        act_tr = this.rd_act_tr_q.pop_front();
//        result = act_tr.compare(exp_tr);
//        num ++;
//        if(result == 1)begin
//            `uvm_info(get_full_name(),$sformatf("SCB:No.%0d:compare result:PASSED!!\n",num),UVM_MEDIUM)
//        end
//        else begin
//            `uvm_error(get_full_name(),$sformatf("SCB:No.%0d:compare result:FAILED!!\n",num))
//        end
//        `uvm_info(get_full_name(),$sformatf("RD_EXP:No.%0d\n\n %s",num,exp_tr.sprint()),UVM_MEDIUM)
//        `uvm_info(get_full_name(),$sformatf("RD_ACT:No.%0d\n\n %s",num,act_tr.sprint()),UVM_MEDIUM)
//    end
//endtask:compare_rd_tr

function void gpu_scoreboard::check_phase(uvm_phase phase);
    super.check_phase(phase);
    if(wr_exp_tr_q.size() != 0) begin
        `uvm_error(get_full_name(),$sformatf("WR_EXP_TR_Q.SIZE()::%0d != 0 !!",wr_exp_tr_q.size))
    end
    if(wr_act_tr_q.size() != 0) begin
        `uvm_error(get_full_name(),$sformatf("WR_ACT_TR_Q.SIZE()::%0d != 0 !!",wr_act_tr_q.size))
    end

    //if(rd_exp_tr_q.size() != 0) begin
    //    `uvm_error(get_full_name(),$sformatf("RD_EXP_TR_Q.SIZE()::%0d != 0 !!",rd_exp_tr_q.size))
    //end
    //if(rd_act_tr_q.size() != 0) begin
    //    `uvm_error(get_full_name(),$sformatf("RD_ACT_TR_Q.SIZE()::%0d != 0 !!",rd_act_tr_q.size))
    //end
endfunction:check_phase

`endif
