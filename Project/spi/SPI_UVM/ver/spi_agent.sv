//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_agent.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_AGENT_SV
`define SPI_AGENT_SV

class spi_agent extends uvm_agent;

    apb_sequencer   spi_sqr;
    apb_driver      spi_drv;
    apb_monitor     spi_mon;

    uvm_analysis_port#(spi_transaction) wr_ap;
    uvm_analysis_port#(spi_transaction) rd_ap;

    `uvm_component_utils(spi_agent)
    
    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
endclass:spi_agent

function void spi_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        spi_sqr = spi_sequencer::type_id::create("spi_sqr",this);
        spi_drv = spi_driver::type_id::create("spi_drv",this);
    end
    spi_mon = spi_monitor::type_id::create("spi_mon",this);
endfunction:build_phase

function void spi_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        spi_drv.seq_item_port.connect(spi_sqr.seq_item_export);    
    end
    wr_ap = spi_mon.wr_ap;
    rd_ap = spi_mon.rd_ap;
endfunction:connect_phase

task spi_agent::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask:main_phase

`endif
