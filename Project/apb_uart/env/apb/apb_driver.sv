//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_driver.sv
// Creater     :Dan
// Create Date :2025-01-02 23:49:06
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(apb_transaction);

    virtual apb_interface drv_if ;

    `uvm_component_utils(apb_driver)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual task          reset_phase  (uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
    extern virtual task          send_data    ();
endclass:apb_driver

function void apb_driver::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "drv_apb_if", drv_if)) begin
        `uvm_fatal(get_type_name(),$sformatf("Interface get fail, please check the path."))
    end
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

task apb_driver::reset_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"reset_phase Enter...",UVM_MEDIUM)
    super.reset_phase(phase);
    phase.raise_objection(this);
    wait(this.drv_if.PRESETn == 0);
    this.drv_if.reset(get_type_name());
    wait(this.drv_if.PRESETn == 0);
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"reset_phase Exit ...",UVM_MEDIUM)
endtask:reset_phase

task apb_driver::main_phase(uvm_phase phase);
    int num;

    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    while(1)begin
        this.seq_item_port.get_next_item(req);
        `uvm_info(get_type_name(),$sformatf("=== No.%0d === \n%s", ++num, req.sprint()),UVM_HIGH)
        send_data();
        this.seq_item_port.item_done;
    end
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

task apb_driver::send_data();
    //@drv_if.drv_cb;
    drv_if.drv_cb.PSEL[0] <= 1;
    drv_if.drv_cb.PADDR   <= req.paddr;
    drv_if.drv_cb.PWDATA  <= req.data;
    drv_if.drv_cb.PWRITE  <= req.pwrite;

    fork
        begin
            @drv_if.drv_cb;
            drv_if.drv_cb.PENABLE <= 1;
        end
        begin
            do
                @drv_if.drv_cb;
            //while(drv_if.PREADY == 1'b0 && drv_if.PSLVERR == 1'b0);
            while(drv_if.PREADY == 1'b0);
            if(req.pwrite == 0) begin // read
                req.data = drv_if.drv_cb.PRDATA;
            end
        end
    join

    @drv_if.drv_cb;
    drv_if.drv_cb.PSEL[0] <= 0;
    drv_if.drv_cb.PENABLE <= 0;
    drv_if.drv_cb.PADDR   <= 0;		
endtask:send_data

`endif 
