//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_agent.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:35:39
// Description : 
// 
//================================================================

`ifndef GPU_AGENT_SV
`define GPU_AGENT_SV

class gpu_agent extends uvm_agent;

    gpu_sequencer   gpu_sqr;
    gpu_driver      gpu_drv;
    gpu_monitor     gpu_mon;

    uvm_analysis_port#(gpu_transaction) wr_ap;
    uvm_analysis_port#(gpu_transaction) rd_ap;

    `uvm_component_utils(gpu_agent)
    
    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase   (uvm_phase phase);
endclass:gpu_agent

function void gpu_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        gpu_sqr = gpu_sequencer::type_id::create("gpu_sqr",this);
        gpu_drv = gpu_driver::type_id::create("gpu_drv",this);
    end
    gpu_mon = gpu_monitor::type_id::create("gpu_mon",this);
endfunction:build_phase

function void gpu_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        gpu_drv.seq_item_port.connect(gpu_sqr.seq_item_export);    
    end
    wr_ap = gpu_mon.wr_ap;
    rd_ap = gpu_mon.rd_ap;
endfunction:connect_phase

task gpu_agent::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask:run_phase

`endif
