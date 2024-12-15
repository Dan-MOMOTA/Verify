//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_driver.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:22:39
// Description : 
// 
//================================================================

`ifndef GPU_DRIVER_SV
`define GPU_DRIVER_SV

class gpu_driver extends uvm_driver #(gpu_transaction);
    
    string                     name   ;
    virtual gpu_interface      drv_if ;
    gpu_cfg                    cfg    ;

    `uvm_component_utils(gpu_driver)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          reset_phase  (uvm_phase phase);
    extern virtual task          run_phase   (uvm_phase phase);
    extern virtual task          send_data    ();
endclass:gpu_driver

function void gpu_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual gpu_interface)::get(this, "", "drv_gpu_if", drv_if);
    uvm_config_db#(gpu_cfg)::get(this, "", "cfg", cfg);
endfunction:build_phase

function void gpu_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task gpu_driver::reset_phase(uvm_phase phase);
    `uvm_info(get_full_name,$sformatf("reset_phase() START!"), UVM_MEDIUM)
    super.reset_phase(phase);
    phase.raise_objection(this);
    wait(this.drv_if.reset == 1);
    this.drv_if.drv_cb.start                       <= 0;
    this.drv_if.drv_cb.device_control_write_enable <= 0;
    this.drv_if.drv_cb.device_control_data         <= 0;
    this.drv_if.drv_cb.program_mem_read_ready      <= 0;
    this.drv_if.drv_cb.program_mem_read_data       <= '{default:0};
    this.drv_if.drv_cb.data_mem_read_ready         <= 0;
    this.drv_if.drv_cb.data_mem_read_data          <= '{default:0};
    this.drv_if.drv_cb.data_mem_write_ready        <= 0;
    wait(this.drv_if.reset == 0);
    phase.drop_objection(this);
    `uvm_info(get_full_name,$sformatf("reset_phase() DONE !"), UVM_MEDIUM)
endtask:reset_phase

task gpu_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name,$sformatf("run_phase() START!"), UVM_MEDIUM)
    while(1)begin
        this.seq_item_port.get_next_item(req);
        send_data();
        this.seq_item_port.item_done;
    end
    `uvm_info(get_full_name(),$sformatf("run_phase() DONE!"), UVM_MEDIUM)
endtask:run_phase

task gpu_driver::send_data();
    //TODO
    `uvm_info("SEND_DATA",$sformatf("Here need to be completed."),UVM_MEDIUM)
endtask:send_data

`endif
