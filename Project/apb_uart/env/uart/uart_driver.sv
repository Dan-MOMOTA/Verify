//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :uart_driver.sv
// Creater     :Dan
// Create Date :2025-01-19 22:23:47
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef UART_DRIVER_SV
`define UART_DRIVER_SV

class uart_driver extends uvm_driver #(uart_transaction);

    virtual uart_interface drv_if ;

    `uvm_component_utils(uart_driver)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual task          reset_phase  (uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
    extern virtual task          send_data    ();
endclass:uart_driver

function void uart_driver::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    if(!uvm_config_db#(virtual uart_interface)::get(this, "", "drv_uart_if", drv_if)) begin
        `uvm_fatal(get_type_name(),$sformatf("Interface get fail, please check the path."))
    end
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

task uart_driver::reset_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"reset_phase Enter...",UVM_MEDIUM)
    super.reset_phase(phase);
    phase.raise_objection(this);
    wait(this.drv_if.rst_n == 0);
    this.drv_if.reset(get_type_name());
    wait(this.drv_if.rst_n == 0);
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"reset_phase Exit ...",UVM_MEDIUM)
endtask:reset_phase

task uart_driver::main_phase(uvm_phase phase);
    int num;

    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    while(1) begin
        this.seq_item_port.get_next_item(req);
        `uvm_info(get_type_name(),$sformatf("=== No.%0d === \n%s", ++num, req.sprint()),UVM_HIGH)
        send_data();
        this.seq_item_port.item_done;
    end
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

task uart_driver::send_data();
    #100ns;
endtask:send_data

`endif 
