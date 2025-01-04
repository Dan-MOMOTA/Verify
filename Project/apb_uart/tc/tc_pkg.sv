//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :tc_pkg.sv
// Creater     :Dan
// Create Date :2025-01-04 22:29:08
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef TC_PKG_SV
`define TC_PKG_SV

package tc_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import tb_pkg::*;
    import apb_pkg::*;
    import uart_pkg::*;
    import blk_pkg::*;
    import seq_pkg::*;

    `include "base_test.sv"
    `include "tc_sanity.sv"
endpackage

`endif 
