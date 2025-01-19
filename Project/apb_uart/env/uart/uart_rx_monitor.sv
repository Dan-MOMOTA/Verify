//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :uart_rx_monitor.sv
// Creater     :Dan
// Create Date :2025-01-19 22:52:37
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef UART_RX_MONITOR_SV
`define UART_RX_MONITOR_SV

class uart_rx_monitor extends uvm_monitor;

    virtual uart_interface mon_if ;

    uvm_analysis_port#(uart_transaction) ap;

    `uvm_component_utils(uart_rx_monitor)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
    extern virtual task          collect_data  ();
endclass:uart_rx_monitor

function void uart_rx_monitor::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    if(!uvm_config_db#(virtual uart_interface)::get(this, "", "mon_uart_if", mon_if)) begin
        `uvm_fatal(get_type_name(),$sformatf("Interface get fail, please check the path."))
    end
    ap = new("ap", this);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

task uart_rx_monitor::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    //fork
    //    this.collect_data();
    //join_none
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

task uart_rx_monitor::collect_data();
    int num;
    uart_transaction tr;

    while(1) begin

        @(posedge mon_if.clk);
    end
endtask:collect_data

`endif 
