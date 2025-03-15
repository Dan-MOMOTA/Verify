//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :axi_master_interface.sv
// Creater     :Dan
// Create Date :2025-03-15 22:55:04
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef AXI_MASTER_INTERFACE_SV
`define AXI_MASTER_INTERFACE_SV


interface axi_master_interface #(
    parameter MSTR_ID_WD        = `CC_MAX_MSTR_TAG_PW + 1  , // 6
    parameter MSTR_ADDR_WD      = `MASTER_BUS_ADDR_WIDTH   , // 64
    parameter MSTR_BURST_LEN_PW = `CC_MSTR_BURST_LEN_PW    , // 8
    parameter MSTR_DATA_WD      = `MASTER_BUS_DATA_WIDTH   , // 512
    parameter MSTR_WSTRB_WD     = `CC_MSTR_BUS_WSTRB_WIDTH   // 64

)(input reset_n, input axi_clk);
    // AXI msdter write request
    logic [MSTR_ID_WD-1:0]        mstr_awid    ; 
    logic                         mstr_awvalid ; 
    logic [MSTR_ADDR_WD-1:0]      mstr_awaddr  ; 
    logic [MSTR_BURST_LEN_PW-1:0] mstr_awlen   ; 
    logic [2:0]                   mstr_awsize  ; 
    logic [1:0]                   mstr_awburst ; 
    logic                         mstr_awlock  ; 
    logic [3:0]                   mstr_awqos   ; 
    logic [3:0]                   mstr_awcache ; 
    logic [2:0]                   mstr_awprot  ; 
    logic                         mstr_awready ; 

    logic                     mstr_wvalid  ; 
    logic                     mstr_wlast   ; 
    logic [MSTR_DATA_WD-1:0]  mstr_wdata   ; 
    logic [MSTR_WSTRB_WD-1:0] mstr_wstrb   ; 
    logic                     mstr_wready  ; 
    // AXI master write response
    logic [MSTR_ID_WD-1:0] mstr_bid     ; 
    logic                  mstr_bvalid  ; 
    logic [1:0]            mstr_bresp   ; 
    logic                  mstr_bready  ; 

    // AXI master read request
    logic [MSTR_ID_WD-1:0]        mstr_arid    ; 
    logic                         mstr_arvalid ; 
    logic [MSTR_ADDR_WD-1:0]      mstr_araddr  ; 
    logic [MSTR_BURST_LEN_PW-1:0] mstr_arlen   ; 
    logic [2:0]                   mstr_arsize  ; 
    logic [1:0]                   mstr_arburst ; 
    logic [MSTR_LOCK_WD-1:0]      mstr_arlock  ; 
    logic [3:0]                   mstr_arqos   ; 
    logic [3:0]                   mstr_arcache ; 
    logic [2:0]                   mstr_arprot  ; 
    logic                         mstr_arready ; 

    // AXI master read response & read data
    logic [MSTR_ID_WD-1:0]   mstr_rid    ; 
    logic                    mstr_rvalid ; 
    logic                    mstr_rlast  ; 
    logic [MSTR_DATA_WD-1:0] mstr_rdata  ; 
    logic [1:0]              mstr_rresp  ; 
    logic                    mstr_rready ; 

endinterface: axi_master_interface

`endif
