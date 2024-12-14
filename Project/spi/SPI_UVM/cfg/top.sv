//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : top.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef TOP_SV
`define TOP_SV
module top();
    
    parameter    PERIOD = 20;
    //1.Define Signal
    //system
    reg           pclk              ; 
    reg           prst_n            ; 
    //apb interface
    wire          psel              ; 
    wire          penable           ; 
    wire          pwrite            ; 
    wire  [31:0]  paddr             ; 
    wire  [31:0]  pwdata            ; 
    wire  [31:0]  prdata            ; 
    wire          pready            ; 

    //spi interface
    wire          sclk              ;
    wire          csn               ;
    wire          mosi              ;
    wire          miso              ;

    wire          spi_intr_reg      ;

    //instance DUT
    apb_spi u_apb_spi(
            .pclk               ( pclk              ) ,
            .prst_n             ( prst_n            ) ,
            .psel               ( psel              ) ,
            .penable            ( penable           ) ,
            .pwrite             ( pwrite            ) ,
            .paddr              ( paddr             ) ,
            .pwdata             ( pwdata            ) ,
            .prdata             ( prdata            ) ,
            .pready             ( pready            ) ,
            .sclk               ( sclk              ) ,
            .csn                ( csn               ) ,
            .mosi               ( mosi              ) ,
            .miso               ( miso              ) ,
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

    apb_interface         drv_apb_if  (pclk, prst_n);
    apb_interface         mon_apb_if  (pclk, prst_n);
    spi_interface         drv_spi_if  (sclk        );
    spi_interface         mon_spi_if  (sclk        );

    //apb drv
    assign psel     = drv_apb_if.psel       ; 
    assign penable  = drv_apb_if.penable    ; 
    assign pwrite   = drv_apb_if.pwrite     ; 
    assign paddr    = drv_apb_if.paddr      ; 
    assign pwdata   = drv_apb_if.pwdata     ; 
    assign drv_apb_if.prdata  = prdata      ; 
    assign drv_apb_if.pready  = pready      ; 

    //apb mon
    assign drv_apb_if.psel     = psel       ; 
    assign drv_apb_if.penable  = penable    ; 
    assign drv_apb_if.pwrite   = pwrite     ; 
    assign drv_apb_if.paddr    = paddr      ; 
    assign drv_apb_if.pwdata   = pwdata     ; 
    assign drv_apb_if.prdata   = prdata     ; 
    assign drv_apb_if.pready   = pready     ; 

    //drv_spi_if
    assign miso = drv_spi_if.miso ;
    assign drv_spi_if.mosi = mosi ;
    assign drv_spi_if.csn  = csn  ;

    //mon_spi_if
    assign mon_spi_if.miso = miso ;
    assign mon_spi_if.mosi = mosi ;
    assign mon_spi_if.csn  = csn  ;

    //instance TB
    //tb i_tb(drv_reg_if,drv_data_if,mon_data_if,drv_spi_if,mon_spi_if);

    initial begin
        run_test();
    end
    
    initial begin
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.env.apb_agt.apb_drv", "drv_apb_if", drv_apb_if);
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.env.apb_agt.apb_mon", "mon_apb_if", mon_apb_if);
        uvm_config_db#(virtual spi_interface)::set(null, "uvm_test_top.env.spi_agt.spi_drv", "drv_spi_if", drv_spi_if);
        uvm_config_db#(virtual spi_interface)::set(null, "uvm_test_top.env.spi_agt.spi_mon", "mon_spi_if", mon_spi_if);
    end

    //finish
    initial begin
        $timeformat(-9,3,"ns",8);
    end

    initial begin
        string name;
        if($test$plusargs("WAV_DUMP")) begin
            if($value$plusargs("tc_name=%s",name)) begin
                $fsdbDumpfile({name,"fsdb"});
                $fsdbDumpvars(0,top);
                $fsdbDumpMDA();
                $fsdbDumpSVA();
            end
        end
    end
endmodule

`endif
