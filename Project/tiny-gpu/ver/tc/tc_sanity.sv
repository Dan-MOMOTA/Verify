//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : tc_sanity.sv
// Creator     : Dan
// Create Date : 2024-12-15- 23:01:22
// Description : 
// 
//================================================================

`ifndef TC_SANITY_SV
`define TC_SANITY_SV

class tc_sanity extends uvm_test;

    gpu_env       env     ;
    plus          plus_arg;

    //ral_block_SPI   ral_model;
    //reg_apb_adapter reg_adpt ; 

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
    env = gpu_env::type_id::create("env",this);
    //ral_model = ral_block_SPI::type_id::create("ral_model",this);
    //ral_model.configure(null,"");
    //ral_model.build();
    //ral_model.lock_model();
    //ral_model.reset();
    //ral_model.set_hdl_path_root("BACK_DOOR");//set 后门路径---从Verdi中copy到寄存器的model

    //reg_adpt = new("reg_adpt");

    //uvm_config_db#(ral_block_SPI)::set(null, "uvm_test_top.*","ral_model",ral_model);
    //1.Method No.1
    //uvm_config_db#(uvm_object_wrapper)::set(
    //                                        this,
    //                                        "env.apb_agt.apb_sqr.main_phase",
    //                                        "default_sequence",
    //                                        apb_cfg_sequence::get_type()
    //                                       );
endfunction:build_phase

function void tc_sanity::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //ral_model.default_map.set_sequencer(env.apb_agt.apb_sqr,reg_adpt);
    //ral_model.default_map.set_auto_predict(1);
endfunction:connect_phase

task tc_sanity::main_phase(uvm_phase phase);
    //Method No.2
    sanity_sequence seq;
    super.main_phase(phase);
    seq = sanity_sequence::type_id::create("seq");
    seq.starting_phase = phase;
    seq.start(this.env.gpu_agt.gpu_sqr);
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
