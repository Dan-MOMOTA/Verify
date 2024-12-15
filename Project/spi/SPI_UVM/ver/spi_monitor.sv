//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_monitor.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_MONITOR_SV
`define SPI_MONITOR_SV

class spi_monitor extends uvm_driver #(spi_transaction);
    
    string                     name      ;
    virtual spi_interface      mon_spi_if;
    spi_cfg                    cfg       ;

    uvm_analysis_port#(spi_transaction) wr_ap;
    uvm_analysis_port#(spi_transaction) rd_ap;

    `uvm_component_utils(spi_monitor)

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
endclass:spi_monitor

function void spi_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual spi_interface)::get(this, "", "mon_spi_if", mon_spi_if);
    uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg);//直线获取
    //uvm_config_db#(spi_cfg)::get(uvm_root::get(), "uvm_test_top.env.rm", "cfg", cfg);非直线获取
    wr_ap = new("wr_ap",this);
    rd_ap = new("rd_ap",this);
endfunction:build_phase

function void spi_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task spi_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name,$sformatf("run_phase() START!"), UVM_MEDIUM)
    fork
        this.wr_collect_data();
        this.rd_collect_data();
    join_none
    `uvm_info(get_full_name(),$sformatf("run_phase() DONE!"), UVM_MEDIUM)
endtask:run_phase

task spi_monitor::wr_collect_data();
    spi_transaction tr;
    int num;
    while(1) begin
        wait(this.mon_spi_if.csn == 0);
        tr = new();
        tr.spi_data = new[this.cfg.spi_len];
        foreach (tr.spi_data[i]) begin
            case(cfg.spi_mode_reg)
                2'b00,2'b11: begin
                    @this.mon_spi_if.mon_p_cb;
                    tr.spi_data[i] = this.mon_spi_if.mon_p_cb.mosi;
                end
                2'b01,2'b10: begin
                    @this.mon_spi_if.mon_n_cb;
                    tr.spi_data[i] = this.mon_spi_if.mon_n_cb.mosi;
                end
            endcase
        end
        tr.data_len = this.cfg.spi_len;
        this.wr_ap.write(tr);
        num++;
        `uvm_info(get_full_name(),$sformatf("WR_SPI_MON:%0d \n%s",num,tr.sprint), UVM_MEDIUM)
        wait(this.mon_spi_if.csn == 1);
    end
endtask:wr_collect_data

task spi_monitor::rd_collect_data();
    spi_transaction tr;
    int num;
    if(cfg.spi_rxfen_reg == 1) begin
        while(1) begin
            wait(this.mon_spi_if.csn == 0);
            tr = new();
            tr.spi_data = new[this.cfg.spi_len];
            foreach (tr.spi_data[i]) begin
                case(cfg.spi_mode_reg)
                    2'b00,2'b11: begin
                        @this.mon_spi_if.mon_p_cb;
                        tr.spi_data[i] = this.mon_spi_if.mon_p_cb.miso;
                    end
                    2'b01,2'b10: begin
                        @this.mon_spi_if.mon_n_cb;
                        tr.spi_data[i] = this.mon_spi_if.mon_n_cb.miso;
                    end
                endcase
            end
            tr.data_len = this.cfg.spi_len;
            this.rd_ap.write(tr);
            num++;
            `uvm_info(get_full_name(),$sformatf("RD_SPI_MON:%0d \n%s",num,tr.sprint), UVM_MEDIUM)
            wait(this.mon_spi_if.csn == 1);
        end
    end
endtask:rd_collect_data

`endif
