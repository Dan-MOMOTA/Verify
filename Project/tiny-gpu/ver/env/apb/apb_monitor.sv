//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : apb_monitor.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor extends uvm_driver #(apb_transaction);
    
    string                     name      ;
    virtual apb_interface      mon_apb_if;

    uvm_analysis_port#(apb_transaction) wr_ap;
    uvm_analysis_port#(apb_transaction) rd_ap;

    `uvm_component_utils(apb_monitor)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase    (uvm_phase phase);
    extern virtual task          wr_collect_data ();
    extern virtual task          rd_collect_data ();
endclass:apb_monitor

function void apb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual apb_interface)::get(this, "", "mon_apb_if", mon_apb_if);
    wr_ap = new("wr_ap",this);
    rd_ap = new("rd_ap",this);
endfunction:build_phase

function void apb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task apb_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name,$sformatf("run_phase() START!"), UVM_MEDIUM)
    fork
        this.wr_collect_data();
        this.rd_collect_data();
    join_none
    `uvm_info(get_full_name(),$sformatf("run_phase() DONE!"), UVM_MEDIUM)
endtask:run_phase

task apb_monitor::wr_collect_data();
    apb_transaction tr;
    int num++;
    while(1) begin
        @this.mon_apb_if.mon_cb;
        if((this.mon_apb_if.mon_cb.penable == 1'b1) && (this.mon_apb_if.mon_cb.pwrite == 1'b1)) begin
            if(this.mon_apb_if.mon_cb.paddr == 'h0c) begin
                tr = apb_transasction::type_id::create("tr");
                tr.paddr = 'h0c;
                tr.pxdata = this.mon_apb_if.mon_cb.pwdata;
                tr.pwrite = PWRITE;
                this.wr_ap.write(tr);
                num++;
                `uvm_info(get_full_name(),$sformatf("APB_WR_MON:%0d \n%s",num,tr.sprint), UVM_MEDIUM)
            end
        end
    end
endtask:wr_collect_data

task apb_monitor::rd_collect_data();
    apb_transaction tr;
    int num++;
    while(1) begin
        @this.mon_apb_if.mon_cb;
        if((this.mon_apb_if.mon_cb.penable == 1'b1) && (this.mon_apb_if.mon_cb.pwrite == 1'b1)) begin
            if(this.mon_apb_if.mon_cb.paddr == 'h10) begin
                tr = apb_transasction::type_id::create("tr");
                tr.paddr = 'h10;
                tr.pxdata = this.mon_apb_if.mon_cb.prdata;
                tr.pwrite = PREAD;
                this.rd_ap.write(tr);
                num++;
                `uvm_info(get_full_name(),$sformatf("APB_RD_MON:%0d \n%s",num,tr.sprint), UVM_MEDIUM)
            end
        end
    end
endtask:rd_collect_data

`endif
