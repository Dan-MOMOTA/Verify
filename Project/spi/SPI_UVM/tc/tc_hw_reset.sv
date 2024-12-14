//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : tc_hw_reset.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef TC_HW_RESET_SV
`define TC_HW_RESET_SV

class tc_hw_reset extends uvm_test;

    spi_env       env     ;
    plus          plus_arg;

    ral_block_SPI   ral_model;
    reg_apb_adapter reg_adpt ; 

    `uvm_component_utils(tc_hw_reset)

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
endclass:tc_hw_reset

function void tc_hw_reset::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = spi_env::type_id::create("env",this);
    ral_model = ral_block_SPI::type_id::create("ral_model",this);
    ral_model.configure(null,"");
    ral_model.build();
    ral_model.lock_model();
    ral_model.reset();
    ral_model.set_hdl_path_root("BACK_DOOR");//set 后门路径---从Verdi中copy到寄存器的model

    reg_adpt = reg_apb_adapter::type_id::create("reg_adpt",this);
    //reg_adpt = new("reg_adpt");

    uvm_config_db#(ral_block_SPI)::set(null, "uvm_test_top.*","ral_model",ral_model);
    //1.Method No.1
    //uvm_config_db#(uvm_object_wrapper)::set(
    //                                        this,
    //                                        "env.apb_agt.apb_sqr.main_phase",
    //                                        "default_sequence",
    //                                        hw_reset_sequence::get_type()
    //                                       );
endfunction:build_phase

function void tc_hw_reset::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ral_model.default_map.set_sequencer(env.apb_agt.apb_sqr,reg_adpt);
    ral_model.default_map.set_auto_predict(1);
endfunction:connect_phase

task tc_hw_reset::main_phase(uvm_phase phase);
    //Method No.2
    hw_reset_sequence seq;
    super.main_phase(phase);
    seq = hw_reset_sequence::type_id::create("seq");
    seq.starting_phase = phase;
    seq.start(this.env.apb_agt.apb_sqr);
    phase.phase_done.set_drain_time(this,plus::plus_main_phase_drain_time);
endtask:main_phase

function void tc_hw_reset::report_phase(uvm_phase phase);
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
