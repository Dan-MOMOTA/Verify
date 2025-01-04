//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :seq_pkg.sv
// Creater     :Dan
// Create Date :2025-01-04 22:29:08
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef SEQ_PKG_SV
`define SEQ_PKG_SV

package seq_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import tb_pkg::*;
    import apb_pkg::*;
    import uart_pkg::*;
    import blk_pkg::*;

    `include "seq_sanity.sv"
endpackage

`endif 
