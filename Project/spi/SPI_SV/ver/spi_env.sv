//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_env.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_ENV_SV
`define SPI_ENV_SV

class spi_env;

    string name ;

    mailbox rd_gen2drv_chan ;
    mailbox gen2drv_chan    ;
    mailbox wr_mon2rm_chan  ;
    mailbox wr_rm2scb_chan  ;
    mailbox wr_mon2scb_chan ;
    mailbox rd_rm2scb_chan  ;
    mailbox rd_mon2rm_chan  ;
    mailbox rd_mon2scb_chan ;

    virtual spi_reg_interface  drv_reg_if   ;
    virtual spi_data_interface drv_data_if  ;
    virtual spi_data_interface mon_data_if  ;
    virtual spi_interface      drv_spi_if   ;
    virtual spi_interface      mon_spi_if   ;

    spi_reg_cfg                spi_cfg      ;

    spi_data_driver    spi_data_drv ;
    spi_data_generator spi_data_gen ;
    spi_data_monitor   spi_data_mon ;

    //rd
    spi_generator      spi_gen ;
    spi_driver         spi_drv ;

    spi_rm             rm           ;
    spi_monitor        spi_mon      ;
    spi_scoreboard     scb          ;

    function new (string                     name   = " ", 
                  virtual spi_reg_interface  drv_reg_if  ,
                  virtual spi_data_interface drv_data_if ,
                  virtual spi_data_interface mon_data_if ,
                  virtual spi_interface      drv_spi_if  ,
                  virtual spi_interface      mon_spi_if 
                 );
        spi_cfg          = new()        ;
        this.name        = name         ;
        this.drv_reg_if  = drv_reg_if   ;
        this.drv_data_if = drv_data_if  ;
        this.mon_data_if = mon_data_if  ;
        this.drv_spi_if  = drv_spi_if   ;
        this.mon_spi_if  = mon_spi_if   ;
    endfunction:new
    extern virtual function void build_phase  ();
    extern virtual function void config_phase ();
    extern virtual task          reset_phase  ();
    extern virtual task          main_phase   ();
endclass:spi_env

function void spi_env::build_phase();
    this.rd_gen2drv_chan   = new();
    this.gen2drv_chan      = new();
    this.wr_mon2rm_chan    = new();
    this.wr_rm2scb_chan    = new();
    this.rd_mon2rm_chan    = new();
    this.rd_rm2scb_chan    = new();
    this.rd_mon2scb_chan   = new();
    spi_data_gen = new("spi_data_gen",spi_cfg,gen2drv_chan);
    spi_gen      = new("spi_gen",spi_cfg,rd_gen2drv_chan);
    spi_data_drv = new("spi_data_drv",spi_cfg,drv_reg_if,drv_data_if,gen2drv_chan);
    spi_drv      = new("spi_drv",spi_cfg,drv_spi_if,rd_gen2drv_chan);
    spi_data_mon = new("spi_data_mon",mon_data_if,wr_mon2rm_chan,rd_mon2scb_chan);
    rm           = new("rm",spi_cfg,wr_mon2rm_chan,wr_rm2scb_chan,rd_mon2rm_chan,rd_rm2scb_chan);
    spi_mon      = new("spi_mon",spi_cfg,mon_spi_if,wr_mon2scb_chan);
    scb          = new("spi_mon",wr_rm2scb_chan,wr_mon2scb_chan,rd_rm2scb_chan,rd_mon2scb_chan);
endfunction:build_phase

function void spi_env::config_phase();
    spi_cfg.randmoize();
    spi_cfg.print();
endfunction:config_phase

task spi_env::reset_phase();
    spi_data_drv.reset_phase();
endtask:reset_phase

task spi_env::main_phase();
    fork
        spi_gen.main_phase();
        spi_drv.main_phase();
        spi_data_gen.main_phase();
        spi_data_drv.main_phase();
        spi_data_mon.main_phase();
        rm.main_phase();
        spi_mon.main_phase();
        scb.main_phase();
    join
    this.scb.end_sim_check();
endtask:main_phase

`endif
