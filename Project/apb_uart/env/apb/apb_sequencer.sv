//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_sequencer.sv
// Creater     :Dan
// Create Date :2025-01-02 23:48:32
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_SEQUENCER_SV
`define APB_SEQUENCER_SV

class apb_sequencer extends uvm_sequencer #(apb_transaction);

    `uvm_component_utils(apb_sequencer)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
endclass:apb_sequencer

function void apb_sequencer::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void apb_sequencer::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task apb_sequencer::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

`endif 
