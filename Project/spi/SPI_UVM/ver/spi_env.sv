//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_env.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_ENV_SV
`define SPI_ENV_SV

class spi_env extends uvm_env;

    string              name   ;
    apb_agent           apb_agt;
    spi_agent           spi_agt;

    spi_rm              rm     ;
    spi_scoreboard      scb    ;

    //WR
    uvm_tlm_analysis_fifo#(apb_transaction)  apb_agt_rm_fifo ;
    uvm_tlm_analysis_fifo#(spi_transaction)  wr_rm_scb_fifo  ;
    uvm_tlm_analysis_fifo#(spi_transaction)  spi_agt_scb_fifo;

    //RD
    uvm_tlm_analysis_fifo#(spi_transaction)  spi_agt_rm_fifo ;
    uvm_tlm_analysis_fifo#(apb_transaction)  rd_rm_scb_fifo  ;
    uvm_tlm_analysis_fifo#(apb_transaction)  apb_agt_scb_fifo;

    `uvm_component_utils(spi_env)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
    extern virtual function void report_phase (uvm_phase phase);
endclass:spi_env

function void spi_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_agt = apb_agent::type_id::create("apb_agt",this);
    apb_agt.is_active = UVM_ACTIVE ;

    spi_agt = spi_agent::type_id::create("spi_agt",this);
    if(plus::plus_rxfen_en == 0) begin
        spi_agt.is_active = UVM_PASSIVE ;//默认为ACTIVE
    end

    rm      = spi_rm::type_id::create("rm",this)          ;
    scb     = spi_scoreboard::type_id::create("scb",this) ;

    apb_agt_rm_fifo  = new("apb_agt_rm_fifo",this) ;
    wr_rm_scb_fifo   = new("wr_rm_scb_fifo",this)  ;
    spi_agt_scb_fifo = new("spi_agt_scb_fifo",this);

    spi_agt_rm_fifo  = new("spi_agt_rm_fifo",this) ;
    rd_rm_scb_fifo   = new("rd_rm_scb_fifo",this)  ;
    apb_agt_scb_fifo = new("apb_agt_scb_fifo",this);

    apb_agt.is_active = UVM_ACTIVE ;

endfunction:build_phase

function void spi_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //WR
    apb_agt.wr_ap.connect(apb_agt_rm_fifo.analysis_export);
    rm.wr_port.connect(apb_agt_rm_fifo.blocking_get_export);

    rm.wr_ap.connect(wr_rm_scb_fifo.analysis_export);
    scb.wr_exp_port.connect(wr_rm_scb_fifo.blocking_get_export);

    spi_agt.wr_ap.connect(spi_agt_scb_fifo.analysis_export);
    scb.wr_act_port.connect(spi_agt_scb_fifo.blocking_get_export);

    //RD
    spi_agt.rd_ap.connect(spi_agt_rm_fifo.analysis_export);
    rm.rd_port.connect(spi_agt_rm_fifo.blocking_get_export);

    rm.rd_ap.connect(rd_rm_scb_fifo.analysis_export);
    scb.rd_exp_port.connect(rd_rm_scb_fifo.blocking_get_export);

    apb_agt.rd_ap.connect(apb_agt_scb_fifo.analysis_export);
    scb.rd_act_port.connect(apb_agt_scb_fifo.blocking_get_export);   
endfunction:connect_phase

task spi_env::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask:main_phase

function void spi_env::report_phase(uvm_phase phase);
endfunction:report_phase

`endif
