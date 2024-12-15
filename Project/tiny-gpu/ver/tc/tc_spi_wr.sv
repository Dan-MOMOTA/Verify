//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : tc_spi_wr.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef TC_SPI_WR_SV
`define TC_SPI_WR_SV

class tc_spi_wr extends uvm_test;

    spi_env       env     ;
    plus          plus_arg;
    spi_cfg       cfg     ;

    ral_block_SPI   ral_model;
    reg_apb_adapter reg_adpt ; 

    `uvm_component_utils(tc_spi_wr)

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
endclass:tc_spi_wr

function void tc_spi_wr::build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = spi_cfg::type_id::create("cfg");
    cfg.randomize();
    `uvm_info(get_full_name(),$sformatf("CFG FOLLOW:\n%s",cfg.sprint), UVM_MEDIUM)

    env = spi_env::type_id::create("env",this);

    ral_model = ral_block_SPI::type_id::create("ral_model",this);
    ral_model.configure(null,"");
    ral_model.build();
    ral_model.lock_model();
    ral_model.reset();
    ral_model.set_hdl_path_root("BACK_DOOR");//set 后门路径---从Verdi中copy到寄存器的model

    reg_adpt = new("reg_adpt");

    uvm_config_db#(ral_block_SPI)::set(null, "uvm_test_top.*","ral_model",ral_model);
    uvm_config_db#(spi_cfg)::set(null, "uvm_test_top.*","cfg",cfg);
    uvm_config_db#(spi_cfg)::set(null, "uvm_test_top.env.rm","cfg",cfg);
    uvm_config_db#(spi_cfg)::set(null, "uvm_test_top.env.spi_agt.spi_mon","cfg",cfg);
    uvm_config_db#(spi_cfg)::set(null, "uvm_test_top.env.spi_agt.spi_drv","cfg",cfg);
    //1.Method No.1
    //uvm_config_db#(uvm_object_wrapper)::set(
    //                                        this,
    //                                        "env.apb_agt.apb_sqr.main_phase",
    //                                        "default_sequence",
    //                                        spi_wr_sequence::get_type()
    //                                       );
endfunction:build_phase

function void tc_spi_wr::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ral_model.default_map.set_sequencer(env.apb_agt.apb_sqr,reg_adpt);
    ral_model.default_map.set_auto_predict(1);
endfunction:connect_phase

task tc_spi_wr::main_phase(uvm_phase phase);
    //Method No.2
    spi_wr_sequence seq;
    super.main_phase(phase);
    seq = spi_wr_sequence::type_id::create("seq");
    seq.starting_phase = phase;
    seq.start(this.env.apb_agt.apb_sqr);
    phase.phase_done.set_drain_time(this,plus::plus_main_phase_drain_time);
endtask:main_phase

function void tc_spi_wr::report_phase(uvm_phase phase);
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
