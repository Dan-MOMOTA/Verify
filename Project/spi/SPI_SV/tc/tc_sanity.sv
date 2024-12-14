//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : tc_sanity.sv
// Creator     : ICer
// Create Date : 2023-02-05- 22:01:22
// Description : 
// 
//================================================================

`ifndef TC_SANITY__SV
`define TC_SANITY__SV

class tc_sanity extends uvm_test;

    drink_env    env     ;
    plus         plus_arg;

    `uvm_component_utils(tc_sanity)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        plus_arg = new();
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
    extern virtual function void report_phase (uvm_phase phase);
endclass:tc_sanity

function void tc_sanity::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = drink_env::type_id::create("env",this);
    //1.Method No.1
    //uvm_config_db#(uvm_object_wrapper)::set(
    //                                        this,
    //                                        "env.rx_agt.rx_sqr.main_phase",
    //                                        "default_sequence",
    //                                        drink_rx_sequence::get_type()
    //                                       );
endfunction:build_phase

function void tc_sanity::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase
task tc_sanity::main_phase(uvm_phase phase);
    //Method No.2
    drink_rx_sequence seq;
    super.main_phase(phase);
    seq = drink_rx_sequence::type_id::create("seq");
    seq.starting_phase = phase;
    seq.start(this.env.rx_agt.rx_sqr);
    phase.phase_done.set_drain_time(this,plus::plus_main_phase_drain_time);
endtask:main_phase

function void tc_sanity::report_phase(uvm_phase phase);
    uvm_report_server    server ;
    int                  err_num;
    super.report_phase(phase);
    server  = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if(err_num == 0)begin
        $display("\n");
        $display("+==========================+");
        $display("|Simulation Result:PASSED!!|");
        $display("+==========================+");
        $display("\n");
    end
    else begin
        $display("\n");
        $display("+==========================+");
        $display("|Simulation Result:FAILED!!|");
        $display("+==========================+");
        $display("\n");
    end
endfunction:report_phase
`endif
