//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_env.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:31:39
// Description : 
// 
//================================================================

`ifndef GPU_ENV_SV
`define GPU_ENV_SV

class gpu_env extends uvm_env;

    string              name   ;
    //apb_agent           apb_agt;
    gpu_agent           gpu_agt;

    gpu_rm              rm     ;
    gpu_scoreboard      scb    ;

    //WR
    //uvm_tlm_analysis_fifo#(apb_transaction)  apb_agt_rm_fifo ;
    uvm_tlm_analysis_fifo#(gpu_transaction)  wr_rm_scb_fifo  ;
    uvm_tlm_analysis_fifo#(gpu_transaction)  gpu_agt_scb_fifo;

    //RD
    uvm_tlm_analysis_fifo#(gpu_transaction)  gpu_agt_rm_fifo ;
    //uvm_tlm_analysis_fifo#(apb_transaction)  rd_rm_scb_fifo  ;
    //uvm_tlm_analysis_fifo#(apb_transaction)  apb_agt_scb_fifo;

    `uvm_component_utils(gpu_env)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase   (uvm_phase phase);
    extern virtual function void report_phase (uvm_phase phase);
endclass:gpu_env

function void gpu_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //apb_agt = apb_agent::type_id::create("apb_agt",this);
    //apb_agt.is_active = UVM_ACTIVE ;

    gpu_agt = gpu_agent::type_id::create("gpu_agt",this);
    gpu_agt.is_active = UVM_ACTIVE ;//default: ACTIVE

    rm      = gpu_rm::type_id::create("rm",this)          ;
    scb     = gpu_scoreboard::type_id::create("scb",this) ;

    //apb_agt_rm_fifo  = new("apb_agt_rm_fifo",this) ;
    wr_rm_scb_fifo   = new("wr_rm_scb_fifo",this)  ;
    gpu_agt_scb_fifo = new("gpu_agt_scb_fifo",this);

    gpu_agt_rm_fifo  = new("gpu_agt_rm_fifo",this) ;
    //rd_rm_scb_fifo   = new("rd_rm_scb_fifo",this)  ;
    //apb_agt_scb_fifo = new("apb_agt_scb_fifo",this);

endfunction:build_phase

function void gpu_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //WR
    //apb_agt.wr_ap.connect(apb_agt_rm_fifo.analysis_export);
    //rm.wr_port.connect(apb_agt_rm_fifo.blocking_get_export);

    rm.wr_ap.connect(wr_rm_scb_fifo.analysis_export);
    scb.wr_exp_port.connect(wr_rm_scb_fifo.blocking_get_export);

    gpu_agt.wr_ap.connect(gpu_agt_scb_fifo.analysis_export);
    scb.wr_act_port.connect(gpu_agt_scb_fifo.blocking_get_export);

    //RD
    gpu_agt.rd_ap.connect(gpu_agt_rm_fifo.analysis_export);
    rm.rd_port.connect(gpu_agt_rm_fifo.blocking_get_export);

    //rm.rd_ap.connect(rd_rm_scb_fifo.analysis_export);
    //scb.rd_exp_port.connect(rd_rm_scb_fifo.blocking_get_export);
    
    //apb_agt.rd_ap.connect(apb_agt_scb_fifo.analysis_export);
    //scb.rd_act_port.connect(apb_agt_scb_fifo.blocking_get_export);   
endfunction:connect_phase

task gpu_env::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask:run_phase

function void gpu_env::report_phase(uvm_phase phase);
endfunction:report_phase

`endif
