//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :apb_pkg.sv
// Creater     :Dan
// Create Date :2025-01-01 23:29:20
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef APB_PKG_SV
`define APB_PKG_SV

// interface in package is not allowed
`include "apb_interface.sv"

package apb_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import tb_pkg::*;

    `include "apb_transaction.sv"
    //`include "apb_agent_configuration.svh"
    `include "apb_driver.sv"
    `include "apb_monitor.sv"
    //`include "apb_subscriber.svh"
    `include "apb_sequencer.sv"
    `include "apb_agent.sv"
    
    //// Utility Sequences
    //`include "apb_seq.svh"
    ////`include "apb_read_seq.svh"
    ////`include "apb_write_seq.svh"
endpackage

`endif 
