//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :uart_sequencer.sv
// Creater     :Dan
// Create Date :2025-01-19 22:36:31
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef UART_SEQUENCER_SV
`define UART_SEQUENCER_SV

class uart_sequencer extends uvm_sequencer #(uart_transaction);

    `uvm_component_utils(uart_sequencer)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
endclass:uart_sequencer

function void uart_sequencer::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void uart_sequencer::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task uart_sequencer::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

`endif 
