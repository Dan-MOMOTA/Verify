//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : top.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef TOP_SV
`define TOP_SV
module top();
    
    parameter    PERIOD = 20;
    //1.Define Signal
    //system
    reg           clk               ; 
    reg           rst_n             ; 
    //r/w data
    wire          spi_wr_vld        ; 
    wire  [31:0]  spi_wr_data       ; 
    wire          spi_rd_vld        ; 
    wire  [31:0]  spi_rd_data       ; 

    //spi interface
    wire          sclk              ;
    wire          csn               ;
    wire          mosi              ;
    wire          miso              ;

    //spi_reg_cfg
    wire  [1:0]   spi_mode_reg      ;
    wire  [7:0]   spi_baudrate_reg  ;
    wire  [5:0]   spi_length_reg    ;
    wire          spi_lsb1st_reg    ;
    wire          spi_rxfen_reg     ;

    wire          spi_intr_reg      ;

    //instance DUT
    spi_dut u_spi_dut(
            .clk                ( clk               ) ,
            .rst_n              ( rst_n             ) ,
            .spi_wr_vld         ( spi_wr_vld        ) ,
            .spi_wr_data        ( spi_wr_data       ) ,
            .spi_rd_vld         ( spi_rd_vld        ) ,
            .spi_rd_data        ( spi_rd_data       ) ,
            .sclk               ( sclk              ) ,
            .csn                ( csn               ) ,
            .mosi               ( mosi              ) ,
            .miso               ( miso              ) ,
            .spi_mode_reg       ( spi_mode_reg      ) ,
            .spi_baudrate_reg   ( spi_baudrate_reg  ) ,
            .spi_length_reg     ( spi_length_reg    ) ,
            .spi_lsb1st_reg     ( spi_lsb1st_reg    ) ,
            .spi_rxfen_reg      ( spi_rxfen_reg     ) ,
            .spi_intr_reg       ( spi_intr_reg      )
            );

    //gen input and connect signal
    initial begin
        clk = $urandom;
        forever begin
            #(PERIOD/2) clk = ~clk;
        end
    end
    
    initial begin
        rst_n = 1'b1;
        #($urandom_range(20,  200)) rst_n = 1'b0;
        #($urandom_range(200, 500)) rst_n = 1'b1;
    end

    spi_reg_interface     drv_reg_if  (clk, rst_n);
    spi_data_interface    drv_data_if (clk, rst_n);
    spi_data_interface    mon_data_if (clk, rst_n);
    spi_interface         drv_spi_if  (sclk      );
    spi_interface         mon_spi_if  (sclk      );

    //reg drv
    assign spi_mode_reg     = drv_reg_if.spi_mode_reg       ; 
    assign spi_baudrate_reg = drv_reg_if.spi_baudrate_reg   ; 
    assign spi_length_reg   = drv_reg_if.spi_length_reg     ; 
    assign spi_lsb1st_reg   = drv_reg_if.spi_lsb1st_reg     ; 
    assign spi_rxfen_reg    = drv_reg_if.spi_rxfen_reg      ; 
    assign drv_reg_if.spi_intr_reg  = spi_intr_reg          ; 

    //data drv
    assign spi_wr_vld    = drv_data_if.spi_wr_vld        ; 
    assign spi_wr_data   = drv_data_if.spi_wr_data       ; 
    assign drv_data_if.spi_rd_vld    = spi_rd_vld        ; 
    assign drv_data_if.spi_rd_data   = spi_rd_data       ; 
    assign drv_data_if.spi_intr_reg  = spi_intr_reg      ; 

    //data mon
    assign mon_data_if.spi_wr_vld   = spi_wr_vld        ; 
    assign mon_data_if.spi_wr_data  = spi_wr_data       ; 
    assign mon_data_if.spi_rd_vld   = spi_rd_vld        ; 
    assign mon_data_if.spi_rd_data  = spi_rd_data       ; 
    assign drv_data_if.spi_intr_reg = spi_intr_reg      ; 

    //drv_spi_if
    assign miso = drv_spi_if.miso ;
    assign drv_spi_if.mosi = mosi ;
    assign drv_spi_if.csn  = csn  ;

    //mon_spi_if
    assign mon_spi_if.miso = miso ;
    assign mon_spi_if.mosi = mosi ;
    assign mon_spi_if.csn  = csn  ;

    //instance TB
    tb i_tb(drv_reg_if,drv_data_if,mon_data_if,drv_spi_if,mon_spi_if);

    //finish
    initial begin
        $timeformat(-9,3,"ns",8);
    end

endmodule


`endif
