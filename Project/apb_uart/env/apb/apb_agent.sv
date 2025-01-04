//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_agent.sv
// Creater     :Dan
// Create Date :2025-01-02 23:42:00
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent extends uvm_agent;

    apb_sequencer apb_sqr;
    apb_driver    apb_drv;
    apb_monitor   apb_mon;

    uvm_analysis_port#(apb_transaction) ap;

    `uvm_component_utils(apb_agent)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
endclass:apb_agent

function void apb_agent::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        apb_sqr = apb_sequencer::type_id::create("apb_sqr",this);
        apb_drv = apb_driver::type_id::create("apb_drv",this);
    end
    apb_mon = apb_monitor::type_id::create("apb_mon",this);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void apb_agent::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);    
    end
    //wr_ap = apb_mon.wr_ap;
    ap = apb_mon.ap;
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task apb_agent::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

`endif 
