//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :tb_top.sv
// Creater     :Dan
// Create Date :2025-03-15 23:10:53
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef TB_TOP_SV
`define TB_TOP_SV

`timescale 1ns/1ps
`include "tb_include.sv"

module tb_top;
    bit reset;

    `include "dut_instance/interface.sv"
    `include "dut_instance/pcie_dut.sv"

    initial begin
        #1000;
    end

    initial begin
        $fsdbDumpfile("pcie.fsdb");
        $fsdbDumpvars(0, tb_top);
        $fsdbDumpMDA(0, tb_top);
    end

endmodule

`endif 
