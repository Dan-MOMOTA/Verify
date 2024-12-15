//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : apb_agent.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent extends uvm_agent;

    apb_sequencer   apb_sqr;
    apb_driver      apb_drv;
    apb_monitor     apb_mon;
    uvm_analysis_port#(apb_transaction) wr_ap;
    uvm_analysis_port#(apb_transaction) rd_ap;
    `uvm_component_utils(apb_agent)
    
    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase    (uvm_phase phase);
endclass:apb_agent

function void apb_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        apb_sqr = apb_sequencer::type_id::create("apb_sqr",this);
        abp_drv = drink_rx_driver::type_id::create("apb_drv",this);
    end
    apb_mon = drink_rx_monitor::type_id::create("apb_mon",this);
endfunction:build_phase

function void apb_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);    
    end
    wr_ap = apb_mon.wr_ap;
    rd_ap = apb_mon.rd_ap;
endfunction:connect_phase

task apb_agent::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask:run_phase

`endif
