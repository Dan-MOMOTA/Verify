//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :tb_include.sv
// Creater     :Dan
// Create Date :2025-03-15 23:15:15
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef TB_INCLUDE_SV
`define TB_INCLUDE_SV

`include "./interface/axi_master_interface.sv"
`include "./interface/axi_slave_interface.sv"
`include "./interface/axi_clk_reset_interface.sv"
`include "./interface/axi_dbi_interface.sv"
`include "./interface/axi_dma_interface.sv"
`include "./interface/axi_elbi_interface.sv"
`include "./interface/axi_flr_interface.sv"
`include "./interface/axi_msi_interface.sv"
`include "./interface/axi_powerup_interface.sv"
`include "./interface/axi_serdes_interface.sv"
`include "./interface/axi_vendor_msg_interface.sv"

`endif 
