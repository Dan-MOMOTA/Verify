//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_sequencer.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:38:39
// Description : 
// 
//================================================================

`ifndef GPU_SEQUENCER_SV
`define GPU_SEQUENCER_SV

class gpu_sequencer extends uvm_sequencer #(gpu_transaction);

    `uvm_component_utils(gpu_sequencer)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
endclass:gpu_sequencer

function void gpu_sequencer::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("build_phase() START!"), UVM_MEDIUM)
    super.build_phase(phase);
endfunction:build_phase

function void gpu_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task gpu_sequencer::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask:main_phase

`endif
