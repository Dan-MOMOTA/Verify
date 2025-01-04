//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :blk_pkg.sv
// Creater     :Dan
// Create Date :2025-01-04 22:19:20
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef BLK_PKG_SV
`define BLK_PKG_SV

package blk_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import tb_pkg::*;
    import apb_pkg::*;
    import uart_pkg::*;

    `include "blk_env.sv"

endpackage

`endif 
