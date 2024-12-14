//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : apb_seuqencer.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef APB_SEQUENCER_SV
`define APB_SEQUENCER_SV

class apb_sequencer extends uvm_sequencer #(apb_transaction);

    `uvm_component_utils(apb_sequencer)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
endclass:apb_sequencer

function void apb_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

function void apb_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task apb_sequencer::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask:main_phase

`endif
