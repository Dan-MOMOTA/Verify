//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : spi_rm.sv
// Creator     : Dan
// Create Date : 2023-09-07- 09:30:55
// Description : 
// 
//================================================================

`ifndef SPI_RM_SV
`define SPI_RM_SV

class spi_rm extends uvm_component;
    
    string           name          ;
    spi_cfg          cfg           ;

    apb_transaction  wr_mon_rm_q[$];
    spi_transaction  wr_rm_scb_q[$];
    spi_transaction  rd_mon_rm_q[$];
    apb_transaction  rd_rm_scb_q[$];

    uvm_blocking_get_port#(apb_transaction) wr_port;
    uvm_analysis_port    #(spi_transaction) wr_ap  ;

    uvm_blocking_get_port#(spi_transaction) rd_port;
    uvm_analysis_port    #(apb_transaction) rd_ap  ;

    `uvm_component_utils(spi_rm)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          run_phase    (uvm_phase phase);
    extern virtual task          get_mon_wr_tr();
    extern virtual task          wr_data_proc ();
    extern virtual task          put_scb_wr_tr();
    extern virtual task          get_mon_rd_tr();
    extern virtual task          rd_data_proc ();
    extern virtual task          put_scb_rd_tr();
endclass:spi_rm

function void spi_rm::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(spi_cfg)::set(this, "","cfg",cfg);
    wr_port = new("wr_port",this);
    wr_ap   = new("wr_ap",  this);
    rd_port = new("rd_port",this);
    rd_ap   = new("rd_ap",  this);
endfunction:build_phase

function void spi_rm::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task spi_rm::run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
        this.get_mon_wr_tr();
        this.wr_data_proc ();
        this.put_scb_wr_tr();
        this.get_mon_rd_tr();
        this.rd_data_proc ();
        this.put_scb_rd_tr();
    join_none
endtask:run_phase

task spi_rm::get_mon_wr_tr();
    apb_transaction rx_tr;
    int             num  ;
    while(1)begin
        this.wr_port.get(rx_tr);
        this.wr_mon_rm_q.push_back(rx_tr);
        num ++;
        `uvm_info(this.name,$sformatf("get_mon_wr_tr:No.%0d\n\n %s",num,rx_tr.sprint()),UVM_MEDIUM)
    end
endtask:get_mon_wr_tr

task spi_rm::get_mon_rd_tr();
    spi_transaction rx_tr;
    int             num  ;
    while(1)begin
        this.rd_port.get(rx_tr);
        this.rd_mon_rm_q.push_back(rx_tr);
        num ++;
        `uvm_info(this.name,$sformatf("get_mon_rd_tr:No.%0d\n\n %s",num,rx_tr.sprint()),UVM_MEDIUM)
    end
endtask:get_mon_rd_tr

task spi_rm::wr_data_proc();
    apb_transaction rx_tr;
    spi_transaction tx_tr;
    int             num  ;
    while(1) begin
        wait(this.wr_mon_rm_q.size() > 0);
        rx_tr = this.wr_mon_rm_q.pop_front();
        
        tx_tr = spi_transaction::type_id::create("tx_tr");

        tx_tr.spi_data = new[cfg.spi_len];
        tx_tr.data_len = cfg.spi_len;
        for(int i=0;i<cfg.spi_len;i++) begin
            if(cfg.spi_lsb1st_reg == 1) begin
                tx_tr.spi_data[i] =rx_tr.pxdata[i];
            end
            else begin
                tx_tr.spi_data[i] =rx_tr.pxdata[cfg.spi_len-1-i];
            end
        end
        this.wr_rm_scb_q.push_back(tx_tr);
    end
endtask:wr_data_proc

task spi_rm::rd_data_proc();
    spi_transaction rx_tr;
    apb_transaction tx_tr;
    int             num  ;
    while(1) begin
        wait(this.rd_mon_rm_q.size() > 0);
        rx_tr = this.rd_mon_rm_q.pop_front();
        
        tx_tr = apb_transaction::type_id::create("tx_tr");

        tx_tr.paddr = 'h10;
        tx_tr.pwrite = PREAD;

        if(cfg.spi_lsb1st_reg == 1) begin
            for(int i = 0;i < cfg.spi_len;i++) begin
                tx_tr.pxdata[i] = rx_tr.spi_data[i];
            end
        end
        else begin
            for(int i = 0;i < cfg.spi_len;i++) begin
                tx_tr.pxdata[i] = rx_tr.spi_data[cfg.spi_len-1-i];
            end
        end
        this.rd_rm_scb_q.push_back(tx_tr);
    end
endtask:rd_data_proc

task spi_rm::put_scb_wr_tr();
    spi_transaction tx_tr;
    int             num  ;
    while(1)begin
        wait(this.wr_rm_scb_q.size() > 0);
        tx_tr = wr_rm_scb_q.pop_front();
        this.wr_ap.write(tx_tr);
        num ++;
        `uvm_info(this.name,$sformatf("put_scb_wr_tr:No.%0d\n\n %s",num,tx_tr.sprint()),UVM_MEDIUM)
    end
endtask:put_scb_wr_tr

task spi_rm::put_scb_rd_tr();
    apb_transaction tx_tr;
    int             num  ;
    while(1)begin
        wait(this.rd_rm_scb_q.size() > 0);
        tx_tr = rd_rm_scb_q.pop_front();
        this.rd_ap.write(tx_tr);
        num ++;
        `uvm_info(this.name,$sformatf("put_scb_rd_tr:No.%0d\n\n %s",num,tx_tr.sprint()),UVM_MEDIUM)
    end
endtask:put_scb_rd_tr

`endif
