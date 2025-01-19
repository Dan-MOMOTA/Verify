//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :uart_agent.sv
// Creater     :Dan
// Create Date :2025-01-19 22:59:10
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef UART_AGENT_SV
`define UART_AGENT_SV

class uart_agent extends uvm_agent;

    uart_driver     uart_drv;
    uart_sequencer  uart_sqr;
    uart_rx_monitor uart_rx_mon;
    uart_tx_monitor uart_tx_mon;

    uvm_analysis_port#(uart_transaction) rx_ap;
    uvm_analysis_port#(uart_transaction) tx_ap;

    `uvm_component_utils(uart_agent)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
endclass:uart_agent

function void uart_agent::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        uart_drv    = uart_driver::type_id::create("uart_drv",this);
        uart_sqr    = uart_sequencer::type_id::create("uart_sqr",this);
        uart_rx_mon = uart_rx_monitor::type_id::create("uart_rx_mon",this);
    end
    if(is_active == UVM_PASSIVE)begin
        uart_tx_mon = uart_tx_monitor::type_id::create("uart_tx_mon",this);
    end
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void uart_agent::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        uart_drv.seq_item_port.connect(uart_sqr.seq_item_export);    
        rx_ap = uart_rx_mon.ap;
    end
    if(is_active == UVM_PASSIVE)begin
        tx_ap = uart_tx_mon.ap;
    end
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task uart_agent::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

`endif 
