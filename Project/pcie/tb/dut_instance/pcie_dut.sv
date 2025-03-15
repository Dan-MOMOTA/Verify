//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :pcie_dut.sv
// Creater     :Dan
// Create Date :2025-03-15 22:22:57
// Modification History:
// 
// Description:
// 
//=================================================================






pcie_ep u_pcie_ep(

    .reset_n          (u_clk_reset_interface.reset_n         ),
    .auxclk           (u_clk_reset_interface.auxclk          ),
    .app_ltssm_enable (u_clk_reset_interface.app_ltssm_enable),
    .app_hold_phy_rst (u_clk_reset_interface.app_hold_phy_rst),

    .rxp       (u_serdes_interface.rxp      ),
    .rxn       (u_serdes_interface.rxn      ),
    .txp       (u_serdes_interface.txp      ),
    .txn       (u_serdes_interface.txn      ),
    .rxpresent (u_serdes_interface.rxpresent),

    .refclk_p (u_clk_reset_interface.refclk_p),
    .refclk_n (u_clk_reset_interface.refclk_n),

    // AXI msdter write request
    .mstr_awid    (u_axi_master_interface.mstr_awid   ),
    .mstr_awvalid (u_axi_master_interface.mstr_awvalid),
    .mstr_awaddr  (u_axi_master_interface.mstr_awaddr ),
    .mstr_awlen   (u_axi_master_interface.mstr_awlen  ),
    .mstr_awsize  (u_axi_master_interface.mstr_awsize ),
    .mstr_awburst (u_axi_master_interface.mstr_awburst),
    .mstr_awlock  (u_axi_master_interface.mstr_awlock ),
    .mstr_awqos   (u_axi_master_interface.mstr_awqos  ),
    .mstr_awcache (u_axi_master_interface.mstr_awcache),
    .mstr_awprot  (u_axi_master_interface.mstr_awprot ),
    .mstr_awready (u_axi_master_interface.mstr_awready),

    .mstr_wvalid (u_axi_master_interface.mstr_wvalid),
    .mstr_wlast  (u_axi_master_interface.mstr_wlast ),
    .mstr_wdata  (u_axi_master_interface.mstr_wdata ),
    .mstr_wstrb  (u_axi_master_interface.mstr_wstrb ),
    .mstr_wready (u_axi_master_interface.mstr_wready),
    // AXI master write response
    .mstr_bid    (u_axi_master_interface.mstr_bid   ),
    .mstr_bvalid (u_axi_master_interface.mstr_bvalid),
    .mstr_bresp  (u_axi_master_interface.mstr_bresp ),
    .mstr_bready (u_axi_master_interface.mstr_bready),

    // AXI master read request
    .mstr_arid    (u_axi_master_interface.mstr_arid   ),
    .mstr_arvalid (u_axi_master_interface.mstr_arvalid),
    .mstr_araddr  (u_axi_master_interface.mstr_araddr ),
    .mstr_arlen   (u_axi_master_interface.mstr_arlen  ),
    .mstr_arsize  (u_axi_master_interface.mstr_arsize ),
    .mstr_arburst (u_axi_master_interface.mstr_arburst),
    .mstr_arlock  (u_axi_master_interface.mstr_arlock ),
    .mstr_arqos   (u_axi_master_interface.mstr_arqos  ),
    .mstr_arcache (u_axi_master_interface.mstr_arcache),
    .mstr_arprot  (u_axi_master_interface.mstr_arprot ),
    .mstr_arready (u_axi_master_interface.mstr_arready),

    // AXI master read response & read data
    .mstr_rid    (u_axi_master_interface.mstr_rid   ),
    .mstr_rvalid (u_axi_master_interface.mstr_rvalid),
    .mstr_rlast  (u_axi_master_interface.mstr_rlast ),
    .mstr_rdata  (u_axi_master_interface.mstr_rdata ),
    .mstr_rresp  (u_axi_master_interface.mstr_rresp ),
    .mstr_rready (u_axi_master_interface.mstr_rready),

    // AXI slave interface
    // AXI slave Write address channel
    .slv_awid    (u_axi_slave_interface.slv_awid   ),
    .slv_awaddr  (u_axi_slave_interface.slv_awaddr ),
    .slv_awlen   (u_axi_slave_interface.slv_awlen  ),
    .slv_awsize  (u_axi_slave_interface.slv_awsize ),
    .slv_awburst (u_axi_slave_interface.slv_awburst),
    .slv_awlock  (u_axi_slave_interface.slv_awlock ),
    .slv_awqos   (u_axi_slave_interface.slv_awqos  ),
    .slv_awcache (u_axi_slave_interface.slv_awcache),
    .slv_awprot  (u_axi_slave_interface.slv_awprot ),
    .slv_awvalid (u_axi_slave_interface.slv_awvalid),
    .slv_awready (u_axi_slave_interface.slv_awready),

    // AXI slave Write data channel
    .slv_wdata  (u_axi_slave_interface.slv_wdata ),
    .slv_wstrb  (u_axi_slave_interface.slv_wstrb ),
    .slv_wlast  (u_axi_slave_interface.slv_wlast ),
    .slv_wvalid (u_axi_slave_interface.slv_wvalid),
    .slv_wready (u_axi_slave_interface.slv_wready),

    // AXI slave Write response channel
    .slv_bid    (u_axi_slave_interface.slv_bid   ),
    .slv_bresp  (u_axi_slave_interface.slv_bresp ),
    .slv_bvalid (u_axi_slave_interface.slv_bvalid),
    .slv_bready (u_axi_slave_interface.slv_bready),

    // AXI slave Read address channel
    .slv_arid    (u_axi_slave_interface.slv_arid   ),
    .slv_araddr  (u_axi_slave_interface.slv_araddr ),
    .slv_arlen   (u_axi_slave_interface.slv_arlen  ),
    .slv_arsize  (u_axi_slave_interface.slv_arsize ),
    .slv_arburst (u_axi_slave_interface.slv_arburst),
    .slv_arlock  (u_axi_slave_interface.slv_arlock ),
    .slv_arqos   (u_axi_slave_interface.slv_arqos  ),
    .slv_arcache (u_axi_slave_interface.slv_arcache),
    .slv_arprot  (u_axi_slave_interface.slv_arprot ),
    .slv_arvalid (u_axi_slave_interface.slv_arvalid),
    .slv_arready (u_axi_slave_interface.slv_arready),

    // AXI slave Read data channel
    .slv_rid    (u_axi_slave_interface.slv_rid   ),
    .slv_rdata  (u_axi_slave_interface.slv_rdata ),
    .slv_rresp  (u_axi_slave_interface.slv_rresp ),
    .slv_rlast  (u_axi_slave_interface.slv_rlast ),
    .slv_rvalid (u_axi_slave_interface.slv_rvalid),
    .slv_rready (u_axi_slave_interface.slv_rready),

    // clk_and_reset Signal Descriptions for axi side.
    .slv_aclk    (u_clk_reset_interface.slv_aclk   ),
    .slv_aresetn (u_clk_reset_interface.slv_aresetn),

    // clk_and_reset Signal Descriptions for axi side.
    .mstr_aclk    (u_clk_reset_interface.mstr_aclk   ),
    .mstr_aresetn (u_clk_reset_interface.mstr_aresetn),

    .dbi_addr         (u_dpi_interface.dbi_addr        ),
    .dbi_din          (u_dpi_interface.dbi_din         ),
    .dbi_cs           (u_dpi_interface.dbi_cs          ),
    .dbi_cs2          (u_dpi_interface.dbi_cs2         ),
    .dbi_wr           (u_dpi_interface.dbi_wr          ),
    .dbi_vfunc_num    (u_dpi_interface.dbi_vfunc_num   ),
    .dbi_vfunc_active (u_dpi_interface.dbi_vfunc_active),
    .dbi_func_num     (u_dpi_interface.dbi_func_num    ),
    .dbi_bar_num      (u_dpi_interface.dbi_bar_num     ),
    .dbi_rom_access   (u_dpi_interface.dbi_rom_access  ),
    .dbi_io_access    (u_dpi_interface.dbi_io_access   ),
    .lbc_dbi_ack      (u_dpi_interface.lbc_dbi_ack     ),
    .lbc_dbi_dout     (u_dpi_interface.lbc_dbi_dout    ),

    // START_IO:ELBI Signal Descriptions. EP Mode Only
    .ext_lbc_ack          (u_elbi_interface.ext_lbc_ack         ),
    .ext_lbc_din          (u_elbi_interface.ext_lbc_din         ),
    .lbc_ext_addr         (u_elbi_interface.lbc_ext_addr        ),
    .lbc_ext_dout         (u_elbi_interface.lbc_ext_dout        ),
    .lbc_ext_cs           (u_elbi_interface.lbc_ext_cs          ),
    .lbc_ext_wr           (u_elbi_interface.lbc_ext_wr          ),
    .lbc_ext_dbi_access   (u_elbi_interface.lbc_ext_dbi_access  ),
    .lbc_ext_rom_access   (u_elbi_interface.lbc_ext_rom_access  ),
    .lbc_ext_io_access    (u_elbi_interface.lbc_ext_io_access   ),
    .lbc_ext_bar_num      (u_elbi_interface.lbc_ext_bar_num     ),
    .lbc_ext_vfunc_num    (u_elbi_interface.lbc_ext_vfunc_num   ),
    .lbc_ext_vfunc_active (u_elbi_interface.lbc_ext_vfunc_active),

    .ven_msi_req         (u_msi_interface.ven_msi_req        ),
    .ven_msi_func_num    (u_msi_interface.ven_msi_func_num   ),
    .ven_msi_vfunc_num   (u_msi_interface.ven_msi_vfunc_num  ),
    .ven_msi_vfunc_activ (u_msi_interface.ven_msi_vfunc_activ),
    .ven_msi_tc          (u_msi_interface.ven_msi_tc         ),
    .ven_msi_vector      (u_msi_interface.ven_msi_vector     ),
    .ven_msi_grant       (u_msi_interface.ven_msi_grant      ),
    .cfg_msi_en          (u_msi_interface.cfg_msi_en         ),
    .cfg_msi_mask        (u_msi_interface.cfg_msi_mask       ),
    .cfg_msi_pending     (u_msi_interface.cfg_msi_pending    ),
    .cfg_msi_addr        (u_msi_interface.cfg_msi_addr       ),
    .cfg_msi_data        (u_msi_interface.cfg_msi_data       ),
    .cfg_msi_64          (u_msi_interface.cfg_msi_64         ),
    .cfg_multi_msi_en    (u_msi_interface.cfg_multi_msi_en   ),
    .cfg_msi_ext_data_en (u_msi_interface.cfg_msi_ext_data_en),

    // START_IO:FLR Signal Descriptions.
    .cfg_flr_pf_active (u_flr_interface.cfg_flr_pf_active),
    .app_flr_pf_done   (u_flr_interface.app_flr_pf_done  ),
    .cfg_flr_vf_active (u_flr_interface.cfg_flr_vf_active),
    .app_flr_vf_done   (u_flr_interface.app_flr_vf_done  ),

    // START_IO:VMI Signal Descriptions.
    .ven_msg_fmt          (u_vendor_msg_interface.ven_msg_fmt         ),
    .ven_msg_type         (u_vendor_msg_interface.ven_msg_type        ),
    .ven_msg_tc           (u_vendor_msg_interface.ven_msg_tc          ),
    .ven_msg_td           (u_vendor_msg_interface.ven_msg_td          ),
    .ven_msg_ep           (u_vendor_msg_interface.ven_msg_ep          ),
    .ven_msg_attr         (u_vendor_msg_interface.ven_msg_attr        ),
    .ven_msg_len          (u_vendor_msg_interface.ven_msg_len         ),
    .ven_msg_func_num     (u_vendor_msg_interface.ven_msg_func_num    ),
    .ven_msg_vfunc_num    (u_vendor_msg_interface.ven_msg_vfunc_num   ),
    .ven_msg_vfunc_active (u_vendor_msg_interface.ven_msg_vfunc_active),
    .ven_msg_tag          (u_vendor_msg_interface.ven_msg_tag         ),
    .ven_msg_code         (u_vendor_msg_interface.ven_msg_code        ),
    .ven_msg_data         (u_vendor_msg_interface.ven_msg_data        ),
    .ven_msg_req          (u_vendor_msg_interface.ven_msg_req         ),
    .ven_msg_grant        (u_vendor_msg_interface.ven_msg_grant       ),

    .edma_int (u_dma_interface.edma_int),

    .core_clk     (u_clk_reset_interface.core_clk    ),
    .muxd_aux_clk (u_clk_reset_interface.muxd_aux_clk),
    .core_rst_n   (u_clk_reset_interface.core_rst_n  )
);
