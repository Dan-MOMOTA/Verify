//================================================================
// Copyright (C) 2025 Dan. All rights reserved.
// 
// File Name   : test_top.sv
// Creator     : Dan
// Create Date : 2025-01-01- 16:17:39
// Description : 
// 
//================================================================

`ifndef TOP_SV
`define TOP_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

module test_top();
    //import tc_pkg::*;
    
    parameter    PERIOD = 20;
    //1.Define Signal
    reg clk  ;
    reg rst_n;

    // APB Signals
    wire                       PCLK    ; // input
    wire                       PRESETn ; // input
    wire [`APB_ADDR_WIDTH-1:0] PADDR   ; // input
    wire [`APB_DATA_WIDTH-1:0] PWDATA  ; // input
    wire [`APB_DATA_WIDTH-1:0] PRDATA  ; // output
    wire                       PWRITE  ; // input
    wire                       PENABLE ; // input
    wire                       PSEL    ; // input
    wire                       PREADY  ; // output
    wire                       PSLVERR ; // output

    // UART interrupt request line
    wire        IRQ     ; // output

    // UART signals
    // serial input/output
    wire        TXD     ; // output
    wire        RXD     ; // input 

    // Baud rate generator output - needed for checking
    wire        baud_o  ; // output

    //instance DUT
    uart u_uart(
        .PCLK    (PCLK    ),
        .PRESETn (PRESETn ),
        .PADDR   (PADDR   ),
        .PWDATA  (PWDATA  ),
        .PRDATA  (PRDATA  ),
        .PWRITE  (PWRITE  ),
        .PENABLE (PENABLE ),
        .PSEL    (PSEL    ),
        .PREADY  (PREADY  ),
        .PSLVERR (PSLVERR ),
        .IRQ     (IRQ     ),
        .TXD     (TXD     ),
        .RXD     (RXD     ),
        .baud_o  (baud_o  )
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
        #($urandom_range(5000, 9000)) rst_n = 1'b0;
        #($urandom_range(5000, 9000)) rst_n = 1'b1;
    end

    apb_interface  drv_apb_if  (clk, rst_n);
    apb_interface  mon_apb_if  (clk, rst_n);
    uart_interface drv_uart_if (clk, rst_n);
    uart_interface mon_uart_if (clk, rst_n);
    `include "interface_connect.sv"

    initial begin
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.env.apb_agt.apb_drv", "drv_apb_if", drv_apb_if);
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.env.apb_agt.apb_mon", "mon_apb_if", mon_apb_if);
        uvm_config_db#(virtual uart_interface)::set(null, "uvm_test_top.env.uart_agt.uart_drv", "drv_uart_if", drv_uart_if);
        uvm_config_db#(virtual uart_interface)::set(null, "uvm_test_top.env.uart_agt.uart_mon", "mon_uart_if", mon_uart_if);
    end

    //finish
    initial begin
        $timeformat(-9,3,"ns",8);
    end

    initial begin
        run_test();
    end
    
    //initial begin
    //    string name;
    //    if($test$plusargs("WAV_DUMP")) begin
    //        if($value$plusargs("tc_name=%s",name)) begin
    //            $fsdbDumpfile({name,"fsdb"});
    //            $fsdbDumpvars(0,test_top);
    //            $fsdbDumpMDA();
    //            $fsdbDumpSVA();
    //        end
    //    end
    //end
endmodule

`endif
