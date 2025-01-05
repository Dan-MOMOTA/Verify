//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :base_test.sv
// Creater     :Dan
// Create Date :2025-01-04 20:10:57
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;

    blk_env   env     ;
    plus      plus_arg;

    `uvm_component_utils(base_test)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
        plus_arg = new();
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
    extern virtual function void report_phase  (uvm_phase phase);
endclass:base_test

function void base_test::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    env = blk_env::type_id::create("env",this);
    // Method No.1
    //uvm_config_db#(uvm_object_wrapper)::set(
    //                                        this,
    //                                        "env.apb_agt.apb_sqr.main_phase",
    //                                        "default_sequence",
    //                                        seq_sanity::get_type()
    //                                       );
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void base_test::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    uvm_top.print_topology();
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task base_test::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    // Method No.1
    //seq_sanity seq;
    super.main_phase(phase);
    //seq = seq_sanity::type_id::create("seq");
    //seq.starting_phase = phase;
    //seq.start(this.env.apb_agt.apb_sqr);
    phase.phase_done.set_drain_time(this,plus::plus_main_phase_drain_time);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

function void base_test::report_phase(uvm_phase phase);
    uvm_report_server    server ;
    int                  err_num;
    super.report_phase(phase);
    server  = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if(err_num == 0)begin
        $display("\n");
        $display("+===============================+");
        $display("| Simulation Result: PASSED !!! |");
        $display("+===============================+");
        $display("._______      ___           _______.    _______.");
        $display("|   _   \\    /   \\         /       |   /       |");
        $display("|  |_)   |  /  ^  \\       |   (----`  |   (----`");
        $display("|   ____/  /  /_\\  \\       \\   \\       \\   \\    ");
        $display("|  |      /  _____  \\  .----)   |  .----)   |   ");
        $display("| _|     /__/     \\__\\ |_______/   |_______/    ");
        $display("\n");
    end
    else begin
        $display("\n");
        $display("+===============================+");
        $display("| Simulation Result: FAILED !!! |");
        $display("+===============================+");
        $display(" ________     ___       __   __      ");
        $display("|   _____|   /   \\     |  | |  |     ");
        $display("|  |____    /  ^  \\    |  | |  |     ");
        $display("|   ____|  /  /_\\  \\   |  | |  |     ");
        $display("|  |      /  _____  \\  |  | |  `----.");
        $display("|__|     /__/     \\__\\ |__| |_______|");
        $display("\n");
    end
endfunction:report_phase

`endif 
