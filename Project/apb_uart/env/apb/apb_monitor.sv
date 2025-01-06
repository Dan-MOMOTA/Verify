//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_monitor.sv
// Creater     :Dan
// Create Date :2025-01-02 23:57:13
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor extends uvm_monitor;

    virtual apb_interface mon_if ;

    uvm_analysis_port#(apb_transaction) ap;

    `uvm_component_utils(apb_monitor)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
    extern virtual task          collect_data  ();
endclass:apb_monitor

function void apb_monitor::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "mon_apb_if", mon_if)) begin
        `uvm_fatal(get_type_name(),$sformatf("Interface get fail, please check the path."))
    end
    ap = new("ap", this);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

task apb_monitor::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    fork
        this.collect_data();
    join_none
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

task apb_monitor::collect_data();
    int num;
    apb_transaction tr;
    //byte unsigned data_q[];

    forever begin
        tr = apb_transaction::type_id::create("tr");
        //if(mon_if.mon_cb.PREADY  && mon_if.mon_cb.PSLVERR && mon_if.mon_cb.PSEL[0]) begin
        if(mon_if.mon_cb.PREADY  && mon_if.mon_cb.PSEL[0]) begin
            tr.paddr  = mon_if.mon_cb.PADDR ;
            tr.pwrite = mon_if.mon_cb.PWRITE;
            if(mon_if.mon_cb.PWRITE) begin
                tr.data = mon_if.mon_cb.PWDATA;
            end
            else begin
                tr.data = mon_if.mon_cb.PRDATA;
            end
            //if((tr.paddr[7:0] == 0) && (tr.pwrite == 1))
            //    tr.print();
            //Send to subscribers
            `uvm_info(get_type_name(),$sformatf("=== No.%0d === \n%s", ++num, tr.sprint()),UVM_HIGH)
            ap.write(tr);
            //tr.pack_bytes(data_q);
            //`uvm_info(get_type_name(),$sformatf("=== No.%0p === ", data_q),UVM_HIGH)
            //tr.unpack_bytes(data_q);
            //`uvm_info(get_type_name(),$sformatf("=== No.%0p === ", data_q),UVM_HIGH)
        end
        @mon_if.mon_cb;
    end
endtask:collect_data

`endif 
