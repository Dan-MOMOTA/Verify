//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_data_driver.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_DATA_DRIVER_SV
`define SPI_DATA_DRIVER_SV

class spi_data_driver;
    
    string       name         ;
    mailbox      gen2drv_chan ;
    spi_reg_cfg  spi_cfg      ;

    virtual spi_reg_interface  drv_reg_if   ;
    virtual spi_data_interface drv_data_if  ;

    function new (string                    name   = " ", 
                 spi_reg_cfg                spi_cfg     ,
                 virtual spi_reg_interface  drv_reg_if  ,
                 virtual spi_data_interface drv_data_if ,
                 mailbox                    gen2drv_chan
                 ); 
        this.name         = name         ;
        this.spi_cfg      = spi_cfg      ;
        this.drv_reg_if   = drv_reg_if   ;
        this.drv_data_if  = drv_data_if  ;
        this.gen2drv_chan = gen2drv_chan ;
    endfunction:new
    extern virtual function void build_phase  ();
    extern virtual function void connect_phase();
    extern virtual task          reset_phase  ();
    extern virtual task          cfg_phase    ();
    extern virtual task          main_phase   ();
endclass:spi_data_driver

function void spi_data_driver::build_phase();
endfunction:build_phase

function void spi_data_driver::connect_phase();
endfunction:connect_phase

task spi_data_driver::reset_phase();
    $display("=== @%t::%s reset_phase() START! ===",$time,name)
    wait(top.rst_n == 0);
    this.drv_reg_if.spi_mode_reg     <= 'b0;
    this.drv_reg_if.spi_baudrate_reg <= 'b0;
    this.drv_reg_if.spi_length_reg   <= 'b0;
    this.drv_reg_if.spi_lsb1st_reg   <= 'b0;
    this.drv_reg_if.spi_rxfen_reg    <= 'b0;

    this.drv_data_if.spi_wr_vld      <= 'b0;
    this.drv_data_if.spi_wr_data     <= 'b0;
    wait(top.rst_n == 1);
    repeat(10) @this.drv_reg_if.drv_cb;
    $display("=== @%t::%s reset_phase() DONE! ===",$time,name)
endtask:reset_phase

task spi_data_driver::cfg_phase();
    $display("=== @%t::%s cfg_phase() START! ===",$time,name)
    this.drv_reg_if.spi_mode_reg     <= this.spi_cfg.spi_mode_reg       ;
    this.drv_reg_if.spi_baudrate_reg <= this.spi_cfg.spi_baudrate_reg   ;
    this.drv_reg_if.spi_length_reg   <= this.spi_cfg.spi_length_reg     ;
    this.drv_reg_if.spi_lsb1st_reg   <= this.spi_cfg.spi_lsb1st_reg     ;
    this.drv_reg_if.spi_rxfen_reg    <= this.spi_cfg.spi_rxfen_reg      ;
    repeat(10) @this.drv_reg_if.drv_cb;
    $display("=== @%t::%s cfg_phase() DONE! ===",$time,name)
endtask:cfg_phase

task spi_data_driver::main_phase();
    data_transaction tr ;
    int              num;

    this.cfg_phase();
    @this.drv_data_if.drv_cb;
    while(1) begin
        this.gen2drv_chan.get(tr);
        while(this.drv_data_if.drv_cb.spi_intr_reg == 0) begin
            @this.drv_data_if.drv_cb;
        end
        this.drv_data_if.drv_cb.spi_wr_vld  <= 1'b1;
        this.drv_data_if.drv_cb.spi_wr_data <= tr.rw_data;
        @this.drv_data_if.drv_cb;
        this.drv_data_if.drv_cb.spi_wr_vld  <= 1'b0;
        @this.drv_data_if.drv_cb;
        repeat(tr.wr_dely) @this.drv_data_if.drv_cb;
        num++;
        if(num == plus::plus_data_wr_num) begin
            break;
        end
    end
    repeat(100*2*spi_cfg.spi_baudrate) @this.drv_data_if.drv_cb;
    $display("=== @%t::%s main_phase() DONE! ===",$time,name)
endtask:main_phase

`endif
