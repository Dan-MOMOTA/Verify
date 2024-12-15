//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : apb_driver.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(apb_transaction);
    
    string                     name     ;
    virtual apb_interface      drv_apb_if;

    `uvm_component_utils(apb_driver)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          reset_phase  (uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
endclass:apb_driver

function void apb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual apb_interface)::get(this, "", "drv_apb_if", drv_apb_if);
    //`uvm_info(get_full_name(),$sformatf("build_phase() DONE!"), UVM_MEDIUM)
    //`uvm_info(get_full_name(),$sformatf("build_phase() DONE!"), UVM_LOW)
    //`uvm_info(get_full_name(),$sformatf("build_phase() DONE!"), UVM_HIGH)
endfunction:build_phase

function void apb_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //`uvm_info(get_full_name(),$sformatf("connect_phase() DONE!"), UVM_MEDIUM)
endfunction:connect_phase

task apb_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(get_full_name,$sformatf("reset_phase() START!"), UVM_MEDIUM)
    phase.raise_objection(this);
    wait(top.prst_n == 0);
    this.drv_apb_if.psel     <= 'b0;
    this.drv_apb_if.penable  <= 'b0;
    this.drv_apb_if.paddr    <= 'b0;
    this.drv_apb_if.pwrite   <= 'b0;
    this.drv_apb_if.pwdata   <= 'b0;
    wait(top.prst_n == 1);
    repeat(10) @this.drv_apb_if.drv_cb;
    phase.drop_objection(this);
    `uvm_info(get_full_name,$sformatf("reset_phase() DONE!"), UVM_MEDIUM)
endtask:reset_phase

task apb_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_full_name,$sformatf("main_phase() START!"), UVM_MEDIUM)
    while(1)begin
        this.seq_item_port.get_next_item(req);
        repeat(req.op_dly) @this.drv_apb_if.drv_cb;
        this.drv_apb_if.paddr  <= req.paddr ;
        this.drv_apb_if.psel   <= 'b1       ;
        drv_apb_if.pwrite = (req.pwrite == PWRITE) ? 1'b1 : 1'b0;
        if(req.pwrite == PWRITE) begin
            this.drv_apb_if.pwdata   <= req.pxdata ;
        end
        
        @this.drv_apb_if.drv_cb;
        this.drv_apb_if.penable <= 'b1 ;

        @this.drv_apb_if.drv_cb;
        this.drv_apb_if.psel    <= 'b0 ;
        this.drv_apb_if.penable <= 'b0 ;
        if(req.pwrite == PREAD) begin
            req.pxdata = this.drv_apb_if.prdata;
        end
        else begin
            this.drv_apb_if.pwdata   <= 'h0 ;
        end

        this.seq_item_port.item_done;
    end
    `uvm_info(get_full_name(),$sformatf("main_phase() DONE!"), UVM_MEDIUM)
endtask:main_phase


`endif
