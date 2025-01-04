//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :interface_connect.sv
// Creater     :Dan
// Create Date :2025-01-01 17:05:42
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef INTERFACE_CONNECT_SV
`define INTERFACE_CONNECT_SV

    // apb drv
    assign PCLK    = drv_apb_if.PCLK    ; 
    assign PRESETn = drv_apb_if.PRESETn ; 
    assign PADDR   = drv_apb_if.PADDR   ; 
    assign PWDATA  = drv_apb_if.PWDATA  ; 
    assign PWRITE  = drv_apb_if.PWRITE  ; 
    assign PENABLE = drv_apb_if.PENABLE ; 
    assign PSEL    = drv_apb_if.PSEL[0] ; 
    assign drv_apb_if.PRDATA  = PRDATA  ; 
    assign drv_apb_if.PREADY  = PREADY  ; 
    assign drv_apb_if.PSLVERR = PSLVERR ; 

    // apb mon
    assign mon_apb_if.PCLK    = PCLK    ; 
    assign mon_apb_if.PRESETn = PRESETn ; 
    assign mon_apb_if.PADDR   = PADDR   ; 
    assign mon_apb_if.PWDATA  = PWDATA  ; 
    assign mon_apb_if.PWRITE  = PWRITE  ; 
    assign mon_apb_if.PENABLE = PENABLE ; 
    assign mon_apb_if.PSEL[0] = PSEL    ; 
    assign mon_apb_if.PRDATA  = PRDATA  ; 
    assign mon_apb_if.PREADY  = PREADY  ; 
    assign mon_apb_if.PSLVERR = PSLVERR ; 

    // uart drv
    assign RXD = drv_uart_if.RXD       ; 
    assign drv_uart_if.IRQ    = IRQ    ; 
    assign drv_uart_if.TXD    = TXD    ; 
    assign drv_uart_if.baud_o = baud_o ; 

    // uart mon
    assign mon_uart_if.RXD    = RXD    ; 
    assign mon_uart_if.IRQ    = IRQ    ; 
    assign mon_uart_if.TXD    = TXD    ; 
    assign mon_uart_if.baud_o = baud_o ; 

`endif 
