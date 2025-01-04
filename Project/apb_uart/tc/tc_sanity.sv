//================================================================
// Copyright (C) 2025 Dan. All rights reserved.
// 
// File Name   : tc_sanity.sv
// Creator     : Dan
// Create Date : 2025-01-04- 23:11:22
// Description : 
// 
//================================================================

`ifndef TC_SANITY_SV
`define TC_SANITY_SV

class tc_sanity extends base_test;

    `uvm_component_utils(tc_sanity)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
    extern virtual function void report_phase (uvm_phase phase);
endclass:tc_sanity

function void tc_sanity::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(
                                            this,
                                            "env.apb_agt.apb_sqr.main_phase",
                                            "default_sequence",
                                            seq_sanity::get_type()
                                           );
endfunction:build_phase

function void tc_sanity::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task tc_sanity::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask:main_phase

function void tc_sanity::report_phase(uvm_phase phase);
    super.report_phase(phase);
endfunction:report_phase

`endif
