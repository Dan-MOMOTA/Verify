//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :interface.sv
// Creater     :Dan
// Create Date :2025-03-15 22:22:32
// Modification History:
// 
// Description:
// 
//=================================================================





reg reset_n   ; 
reg core_clk  ; 
reg aux_clk   ; 
reg mstr_aclk ; 
reg slv_aclk  ; 

clk_reset_interface u_clk_reset_interface();

powerup_interface u_powerup_interface(.reset_n(reset_n), .core_clk(aux_clk));
serdes_interface u_serdes_interface();
axi_master_interface u_axi_master_interface(.reset_n(reset_n), .axi_clk(mstr_aclk));
axi_slave_interface u_axi_slave_interface(.reset_n(reset_n), .axi_clk(slv_aclk));
dbi_interface u_dpi_interface(.reset_n(reset_n), .core_clk(aux_clk));
elbi_interface u_elbi_interface(.reset_n(reset_n), .core_clk(aux_clk));
flr_interface u_flr_interface(.reset_n(reset_n), .core_clk(core_clk));
msi_interface u_msi_interface(.reset_n(reset_n), .core_clk(core_clk));
vendor_msg_interface u_vendor_msg_interface(.reset_n(reset_n), .core_clk(core_clk));

dma_interface u_dma_interface(.reset_n(reset_n), .core_clk(core_clk));


always_comb begin
    reset_n    = u_clk_reset_interface.reset_n  ;
     core_clk  = u_clk_reset_interface.core_clk ;
     aux_clk   = u_clk_reset_interface.aux_clk  ;
     mstr_aclk = u_clk_reset_interface.mstr_aclk;
     slv_aclk  = u_clk_reset_interface.slv_aclk ;
end
