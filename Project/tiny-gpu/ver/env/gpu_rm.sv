//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : gpu_rm.sv
// Creator     : Dan
// Create Date : 2024-12-15- 22:45:55
// Description : 
// 
//================================================================

`ifndef GPU_RM_SV
`define GPU_RM_SV

class gpu_rm extends uvm_component;
    
    string           name          ;
    gpu_cfg          cfg           ;

    //apb_transaction  wr_mon_rm_q[$];
    gpu_transaction  wr_rm_scb_q[$];
    gpu_transaction  rd_mon_rm_q[$];
    //apb_transaction  rd_rm_scb_q[$];

    //uvm_blocking_get_port#(apb_transaction) wr_port;
    uvm_analysis_port    #(gpu_transaction) wr_ap  ;

    uvm_blocking_get_port#(gpu_transaction) rd_port;
    //uvm_analysis_port    #(apb_transaction) rd_ap  ;

    `uvm_component_utils(gpu_rm)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase    (uvm_phase phase);
    //extern virtual task          get_mon_wr_tr();
    extern virtual task          wr_data_proc ();
    extern virtual task          put_scb_wr_tr();
    extern virtual task          get_mon_rd_tr();
    extern virtual task          rd_data_proc ();
    //extern virtual task          put_scb_rd_tr();
endclass:gpu_rm

function void gpu_rm::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(gpu_cfg)::set(this, "","cfg",cfg);
    //wr_port = new("wr_port",this);
    wr_ap   = new("wr_ap",  this);
    rd_port = new("rd_port",this);
    //rd_ap   = new("rd_ap",  this);
endfunction:build_phase

function void gpu_rm::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task gpu_rm::run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
        //this.get_mon_wr_tr();
        this.wr_data_proc ();
        this.put_scb_wr_tr();
        this.get_mon_rd_tr();
        this.rd_data_proc ();
        //this.put_scb_rd_tr();
    join_none
endtask:run_phase

//task gpu_rm::get_mon_wr_tr();
//    apb_transaction rx_tr;
//    int             num  ;
//    while(1)begin
//        this.wr_port.get(rx_tr);
//        this.wr_mon_rm_q.push_back(rx_tr);
//        num ++;
//        `uvm_info(this.name,$sformatf("get_mon_wr_tr:No.%0d\n\n %s",num,rx_tr.sprint()),UVM_MEDIUM)
//    end
//endtask:get_mon_wr_tr

task gpu_rm::get_mon_rd_tr();
    gpu_transaction rx_tr;
    int             num  ;
    while(1)begin
        this.rd_port.get(rx_tr);
        this.rd_mon_rm_q.push_back(rx_tr);
        num ++;
        `uvm_info(this.name,$sformatf("get_mon_rd_tr:No.%0d\n\n %s",num,rx_tr.sprint()),UVM_MEDIUM)
    end
endtask:get_mon_rd_tr

task gpu_rm::wr_data_proc();
    //apb_transaction rx_tr;
    gpu_transaction tx_tr;
    int             num  ;
    while(1) begin
        //wait(this.wr_mon_rm_q.size() > 0);
        //rx_tr = this.wr_mon_rm_q.pop_front();
        
        tx_tr = gpu_transaction::type_id::create("tx_tr");

        //tx_tr.gpu_data = new[cfg.gpu_len];
        //tx_tr.data_len = cfg.gpu_len;
        //for(int i=0;i<cfg.gpu_len;i++) begin
        //    if(cfg.gpu_lsb1st_reg == 1) begin
        //        tx_tr.gpu_data[i] =rx_tr.pxdata[i];
        //    end
        //    else begin
        //        tx_tr.gpu_data[i] =rx_tr.pxdata[cfg.gpu_len-1-i];
        //    end
        //end
        this.wr_rm_scb_q.push_back(tx_tr);
    end
endtask:wr_data_proc

task gpu_rm::rd_data_proc();
    gpu_transaction rx_tr;
    //apb_transaction tx_tr;
    int             num  ;
    while(1) begin
        wait(this.rd_mon_rm_q.size() > 0);
        rx_tr = this.rd_mon_rm_q.pop_front();
        
        //tx_tr = apb_transaction::type_id::create("tx_tr");
        //
        //tx_tr.paddr = 'h10;
        //tx_tr.pwrite = PREAD;
        //
        //if(cfg.gpu_lsb1st_reg == 1) begin
        //    for(int i = 0;i < cfg.gpu_len;i++) begin
        //        tx_tr.pxdata[i] = rx_tr.gpu_data[i];
        //    end
        //end
        //else begin
        //    for(int i = 0;i < cfg.gpu_len;i++) begin
        //        tx_tr.pxdata[i] = rx_tr.gpu_data[cfg.gpu_len-1-i];
        //    end
        //end
        //this.rd_rm_scb_q.push_back(tx_tr);
    end
endtask:rd_data_proc

task gpu_rm::put_scb_wr_tr();
    gpu_transaction tx_tr;
    int             num  ;
    while(1)begin
        wait(this.wr_rm_scb_q.size() > 0);
        tx_tr = wr_rm_scb_q.pop_front();
        this.wr_ap.write(tx_tr);
        num ++;
        `uvm_info(this.name,$sformatf("put_scb_wr_tr:No.%0d\n\n %s",num,tx_tr.sprint()),UVM_MEDIUM)
    end
endtask:put_scb_wr_tr

//task gpu_rm::put_scb_rd_tr();
//    apb_transaction tx_tr;
//    int             num  ;
//    while(1)begin
//        wait(this.rd_rm_scb_q.size() > 0);
//        tx_tr = rd_rm_scb_q.pop_front();
//        this.rd_ap.write(tx_tr);
//        num ++;
//        `uvm_info(this.name,$sformatf("put_scb_rd_tr:No.%0d\n\n %s",num,tx_tr.sprint()),UVM_MEDIUM)
//    end
//endtask:put_scb_rd_tr

`endif
