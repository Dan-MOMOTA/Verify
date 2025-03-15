//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :pcie_ep.sv
// Creater     :Dan
// Create Date :2025-03-15 18:29:34
// Modification History:
// 
// Description: 1. instance pcie_iip_device
//              2. app_ltssm_enable, auxclk/reset,
//                 refclkn, txn/p, rxn/p,
//                 axi_master/slave, dbi,
//                 msi, ven_msg, elbi
// 
//=================================================================

module pcie_ep #(
    parameter NL                = `CX_NL                   , 
    parameter MSTR_ID_WD        = `CC_MAX_MSTR_TAG_PW + 1  , // in device/pcie_iip_device.sv: MSTR_ID_WD = `CC_MSTR_BUS_ID_WIDTH
    parameter MSTR_ADDR_WD      = `MASTER_BUS_ADDR_WIDTH   , 
    parameter MSTR_BURST_LEN_PW = `CC_MSTR_BURST_LEN_PW    , 
    parameter MSTR_DATA_WD      = `MASTER_BUS_DATA_WIDTH   , 
    parameter MSTR_WSTRB_WD     = `CC_MSTR_BUS_WSTRB_WIDTH , 
    parameter SLV_ID_WD         = `CC_SLV_ID_WD     , 
    parameter SLV_ADDR_WD       = `SLV_ADDR_WD    , 
    parameter SLV_BURST_LEN_PW  = `CC_SLV_BURST_LEN_PW     , 
    parameter SLV_DATA_WD       = `SLAVE_BUS_DATA_WIDTH    , 
    parameter SLV_WSTRB_WD      = `CC_SLV_BUS_WSTRB_WIDTH  , 
    parameter NVF               = `CX_NVFUNC               , 
    parameter VF_WD             = `CX_LOGBASE2(NVF) + 1    , 
    parameter PF_WD             = `CX_NFUNC_WD             , 
    parameter NF                = `CX_NFUNC                , 
    parameter LBC_NW            = `CX_LBC_NW               , 
    parameter LBC_EXT_AW        = `CX_LBC_EXT_AW           , 
    parameter ATTR_WD           = `FLT_Q_ATTR_WIDTH        , 
    parameter TAG_SIZE          = `CX_TAG_SIZE             , 
    parameter NUM_DMA_WR_CHAN   = `CC_NUM_DMA_WR_CHAN      , 
    parameter NUM_DMA_RD_CHAN   = `CC_NUM_DMA_RD_CHAN       
)(

    input reset_n          , 
    input auxclk           , 
    input app_ltssm_enable , 
    input app_hold_phy_rst , 

    input  [NL-1:0] rxp       , 
    input  [NL-1:0] rxn       , 
    output [NL-1:0] txp       , 
    output [NL-1:0] txn       , 
    input  [NL-1:0] rxpresent , 

    input refclk_p,
    input refclk_n,

    // AXI msdter write request
    output [MSTR_ID_WD-1:0]        mstr_awid    , 
    output                         mstr_awvalid , 
    output [MSTR_ADDR_WD-1:0]      mstr_awaddr  , 
    output [MSTR_BURST_LEN_PW-1:0] mstr_awlen   , 
    output [2:0]                   mstr_awsize  , 
    output [1:0]                   mstr_awburst , 
    output                         mstr_awlock  , 
    output [3:0]                   mstr_awqos   , 
    output [3:0]                   mstr_awcache , 
    output [2:0]                   mstr_awprot  , 
    input                          mstr_awready , 

    output                     mstr_wvalid  , 
    output                     mstr_wlast   , 
    output [MSTR_DATA_WD-1:0]  mstr_wdata   , 
    output [MSTR_WSTRB_WD-1:0] mstr_wstrb   , 
    input                      mstr_wready  , 
    // AXI master write response
    input [MSTR_ID_WD-1:0] mstr_bid     , 
    input                  mstr_bvalid  , 
    input [1:0]            mstr_bresp   , 
    output                 mstr_bready  , 

    // AXI master read request
    output [MSTR_ID_WD-1:0]        mstr_arid    , 
    output                         mstr_arvalid , 
    output [MSTR_ADDR_WD-1:0]      mstr_araddr  , 
    output [MSTR_BURST_LEN_PW-1:0] mstr_arlen   , 
    output [2:0]                   mstr_arsize  , 
    output [1:0]                   mstr_arburst , 
    output [MSTR_LOCK_WD-1:0]      mstr_arlock  , 
    output [3:0]                   mstr_arqos   , 
    output [3:0]                   mstr_arcache , 
    output [2:0]                   mstr_arprot  , 
    input                          mstr_arready , 

    // AXI master read response & read data
    input [MSTR_ID_WD-1:0]   mstr_rid    , 
    input                    mstr_rvalid , 
    input                    mstr_rlast  , 
    input [MSTR_DATA_WD-1:0] mstr_rdata  , 
    input [1:0]              mstr_rresp  , 
    output                   mstr_rready , 

    // AXI slave interface
    // AXI slave Write address channel
    input [SLV_ID_WD-1:0]        slv_awid    , 
    input [SLV_ADDR_WD-1:0]      slv_awaddr  , 
    input [SLV_BURST_LEN_PW-1:0] slv_awlen   , 
    input [2:0]                  slv_awsize  , 
    input [1:0]                  slv_awburst , 
    input                        slv_awlock  , 
    input [3:0]                  slv_awqos   , 
    input [3:0]                  slv_awcache , 
    input [2:0]                  slv_awprot  , 
    input                        slv_awvalid , 
    output                       slv_awready , 

    // AXI slave Write data channel
    input [SLV_DATA_WD-1:0]         slv_wdata  , 
    input [SLV_BUS_WSTRB_WIDTH-1:0] slv_wstrb  , 
    input                           slv_wlast  , 
    input                           slv_wvalid , 
    output                          slv_wready , 

    // AXI slave Write response channel
    output [SLV_ID_WD-1:0] slv_bid    , 
    output [1:0]           slv_bresp  , 
    output                 slv_bvalid , 
    input                  slv_bready , 

    // AXI slave Read address channel
    input [SLV_ID_WD-1:0]        slv_arid    , 
    input [SLV_ADDR_WD-1:0]      slv_araddr  , 
    input [SLV_BURST_LEN_PW-1:0] slv_arlen   , 
    input [2:0]                  slv_arsize  , 
    input [1:0]                  slv_arburst , 
    input                        slv_arlock  , 
    input [3:0]                  slv_arqos   , 
    input [3:0]                  slv_arcache , 
    input [2:0]                  slv_arprot  , 
    input                        slv_arvalid , 
    output                       slv_arready , 

    // AXI slave Read data channel
    output [SLV_ID_WD-1:0]   slv_rid    , 
    output [SLV_DATA_WD-1:0] slv_rdata  , 
    output [1:0]             slv_rresp  , 
    output                   slv_rlast  , 
    output                   slv_rvalid , 
    input                    slv_rready , 

    // clk_and_reset Signal Descriptions for axi side.
    input                              slv_aclk    ,
    output                             slv_aresetn ,

    // clk_and_reset Signal Descriptions for axi side.
    input                              mstr_aclk    ,
    output                             mstr_aresetn ,

    input  [31:0]      dbi_addr         , 
    input  [31:0]      dbi_din          , 
    input              dbi_cs           , 
    input              dbi_cs2          , 
    input  [3:0]       dbi_wr           , 
    input  [VF_WD-2:0] dbi_vfunc_num    , 
    input              dbi_vfunc_active , 
    input  [PF_WD-1:0] dbi_func_num     , 
    input  [2:0]       dbi_bar_num      , 
    input              dbi_rom_access   , 
    input              dbi_io_access    , 
    output             lbc_dbi_ack      , 
    output [31:0]      lbc_dbi_dout     , 

    // START_IO:ELBI Signal Descriptions. EP Mode Only
    input  [NF-1:0]             ext_lbc_ack          , 
    input  [(LBC_NW*32*NF)-1:0] ext_lbc_din          , 
    output [LBC_EXT_AW-1:0]     lbc_ext_addr         , 
    output [(LBC_NW*32)-1:0]    lbc_ext_dout         , 
    output [NF-1:0]             lbc_ext_cs           , 
    output [(4*LBC_NW)-1:0]     lbc_ext_wr           , 
    output                      lbc_ext_dbi_access   , 
    output                      lbc_ext_rom_access   , 
    output                      lbc_ext_io_access    , 
    output [2:0]                lbc_ext_bar_num      , 
    output [VF_WD-2:0]          lbc_ext_vfunc_num    , 
    output                      lbc_ext_vfunc_active , 

    input                ven_msi_req          , 
    input  [PF_WD-1:0]   ven_msi_func_num     , 
    input  [VF_WD-2:0]   ven_msi_vfunc_num    , 
    input                ven_msi_vfunc_active , 
    input  [2:0]         ven_msi_tc           , 
    input  [4:0]         ven_msi_vector       , 
    output               ven_msi_grant        , 
    output [NF-1:0]      cfg_msi_en           , 
    output [(32*NF)-1:0] cfg_msi_mask         , 
    input  [(32*NF)-1:0] cfg_msi_pending      , 
    output [(64*NF)-1:0] cfg_msi_addr         , 
    output [(32*NF)-1:0] cfg_msi_data         , 
    output [NF-1:0]      cfg_msi_64           , 
    output [(3*NF)-1:0]  cfg_multi_msi_en     , 
    output [NF-1:0]      cfg_msi_ext_data_en  , 

    // START_IO:FLR Signal Descriptions.
    output [NF-1:0]  cfg_flr_pf_active , 
    input  [NF-1:0]  app_flr_pf_done   , 
    output [NVF-1:0] cfg_flr_vf_active , 
    input  [NVF-1:0] app_flr_vf_done   , 


    // START_IO:VMI Signal Descriptions.
    input  [1:0]          ven_msg_fmt          , 
    input  [4:0]          ven_msg_type         , 
    input  [2:0]          ven_msg_tc           , 
    input                 ven_msg_td           , 
    input                 ven_msg_ep           , 
    input  [ATTR_WD-1:0]  ven_msg_attr         , 
    input  [9:0]          ven_msg_len          , 
    input  [PF_WD-1:0]    ven_msg_func_num     , 
    input  [VF_WD-2:0]    ven_msg_vfunc_num    , 
    input                 ven_msg_vfunc_active , 
    input  [TAG_SIZE-1:0] ven_msg_tag          , 
    input  [7:0]          ven_msg_code         , 
    input  [63:0]         ven_msg_data         , 
    input                 ven_msg_req          , 
    output                ven_msg_grant        , 
    // END_IO:VMI Signal Descriptions.

    output [(NUM_DMA_RD_CHAN+NUM_DMA_WR_CHAN-1):0] edma_int,

    output core_clk     , 
    output muxd_aux_clk , 
    output core_rst_n
);


    `SNPS_PCIE_IIP_SUBSYS_MODULE u_pcie_iip_device(
        .power_up_rst_n                   (reset_n) , // input 
        .button_rst_n                     (reset_n) , // input 
        .perst_n                          (reset_n) , // input 

        .auxclk                           (auxclk) , // input 
        .app_ltssm_enable                 (app_ltssm_enable) , // input 
        .app_hold_phy_rst                 (app_hold_phy_rst) , // input 

        .muxd_aux_clk                     (muxd_aux_clk) , // output
        .muxd_aux_clk_g                   (muxd_aux_clk_g) , // output

        .sys_aux_pwr_det                  (sys_aux_pwr_det) , // input 
        .app_sris_mode                    (app_sris_mode  ) , // input 
        .app_clk_req_n                    (app_clk_req_n  ) , // input 
        .app_clk_pm_en                    (app_clk_pm_en  ) , // input 

        .app_init_rst                     (app_init_rst                     ) , // input 
        .app_req_entr_l1                  (app_req_entr_l1                  ) , // input 
        .app_ready_entr_l23               (app_ready_entr_l23               ) , // input 
        .app_req_exit_l1                  (app_req_exit_l1                  ) , // input 
        .app_xfer_pending                 (app_xfer_pending                 ) , // input 
        .exp_rom_validation_status_strobe (exp_rom_validation_status_strobe ) , // input 
        .exp_rom_validation_status        (exp_rom_validation_status        ) , // input 
        .exp_rom_validation_details_strobe(exp_rom_validation_details_strobe) , // input 
        .exp_rom_validation_details       (exp_rom_validation_details       ) , // input 
        .app_req_retry_en                 (app_req_retry_en                 ) , // input 
        .app_pf_req_retry_en              (app_pf_req_retry_en              ) , // input 
        .app_vf_req_retry_en              (app_vf_req_retry_en              ) , // input 

        .cfg_hp_slot_ctrl_access    (cfg_hp_slot_ctrl_access    ) , // output
        .cfg_dll_state_chged_en     (cfg_dll_state_chged_en     ) , // output
        .cfg_cmd_cpled_int_en       (cfg_cmd_cpled_int_en       ) , // output
        .cfg_hp_int_en              (cfg_hp_int_en              ) , // output
        .cfg_pre_det_chged_en       (cfg_pre_det_chged_en       ) , // output
        .cfg_mrl_sensor_chged_en    (cfg_mrl_sensor_chged_en    ) , // output
        .cfg_pwr_fault_det_en       (cfg_pwr_fault_det_en       ) , // output
        .cfg_atten_button_pressed_en(cfg_atten_button_pressed_en) , // output

        .rxp(rxp), // input 
        .rxn(rxn), // input 
        .txp(txp), // output
        .txn(txn), // output
        `ifndef SYNTHESIS
            .rxpresent(rxpresent), // input
        `endif // SYNTHESIS

        .refclk_p(refclk_p), // input 
        .refclk_n(refclk_n), // input  

        .local_ref_clk_req_n(local_ref_clk_req_n), // output 

        .cfg_hw_auto_sp_dis(cfg_hw_auto_sp_dis),  // output 


        // AXI master write request
        .mstr_awid                      (mstr_awid                     ) , // output
        .mstr_awvalid                   (mstr_awvalid                  ) , // output
        .mstr_awaddr                    (mstr_awaddr                   ) , // output
        .mstr_awlen                     (mstr_awlen                    ) , // output
        .mstr_awsize                    (mstr_awsize                   ) , // output
        .mstr_awburst                   (mstr_awburst                  ) , // output
        .mstr_awlock                    (mstr_awlock                   ) , // output
        .mstr_awqos                     (mstr_awqos                    ) , // output
        .mstr_awcache                   (mstr_awcache                  ) , // output
        .mstr_awprot                    (mstr_awprot                   ) , // output
        .mstr_awmisc_info               (mstr_awmisc_info              ) , // output
        .mstr_awmisc_info_hdr_34dw      (mstr_awmisc_info_hdr_34dw     ) , // output
        .mstr_awmisc_info_ep            (mstr_awmisc_info_ep           ) , // output
        .mstr_awmisc_info_last_dcmp_tlp (mstr_awmisc_info_last_dcmp_tlp) , // output
        .mstr_awmisc_info_dma           (mstr_awmisc_info_dma          ) , // output
        .mstr_awmisc_info_func_num      (mstr_awmisc_info_func_num     ) , // output
        .mstr_awmisc_info_vfunc_num     (mstr_awmisc_info_vfunc_num    ) , // output
        .mstr_awmisc_info_vfunc_active  (mstr_awmisc_info_vfunc_active ) , // output

        .mstr_awready                   (mstr_awready                  ) , // input

        // AXI master write data
        .mstr_wvalid (mstr_wvalid) , // output
        .mstr_wlast  (mstr_wlast ) , // output
        .mstr_wdata  (mstr_wdata ) , // output
        .mstr_wstrb  (mstr_wstrb ) , // output
        .mstr_wready (mstr_wready) , // input 

        // AXI master write response
        .mstr_bid                 (mstr_bid                ) , // input 
        .mstr_bvalid              (mstr_bvalid             ) , // input 
        .mstr_bresp               (mstr_bresp              ) , // input 
        .mstr_bmisc_info_cpl_stat (mstr_bmisc_info_cpl_stat) , // input 
        .mstr_bready              (mstr_bready             ) , // output

        // AXI master read request
        .mstr_arid                      (mstr_arid                     ) , // output
        .mstr_arvalid                   (mstr_arvalid                  ) , // output
        .mstr_araddr                    (mstr_araddr                   ) , // output
        .mstr_arlen                     (mstr_arlen                    ) , // output
        .mstr_arsize                    (mstr_arsize                   ) , // output
        .mstr_arburst                   (mstr_arburst                  ) , // output
        .mstr_arlock                    (mstr_arlock                   ) , // output
        .mstr_arqos                     (mstr_arqos                    ) , // output
        .mstr_arcache                   (mstr_arcache                  ) , // output
        .mstr_arprot                    (mstr_arprot                   ) , // output
        .mstr_armisc_info               (mstr_armisc_info              ) , // output
        .mstr_armisc_info_last_dcmp_tlp (mstr_armisc_info_last_dcmp_tlp) , // output
        .mstr_armisc_info_dma           (mstr_armisc_info_dma          ) , // output
        .mstr_armisc_info_func_num      (mstr_armisc_info_func_num     ) , // output
        .mstr_armisc_info_vfunc_num     (mstr_armisc_info_vfunc_num    ) , // output
        .mstr_armisc_info_vfunc_active  (mstr_armisc_info_vfunc_active ) , // output
        .mstr_armisc_info_zeroread      (mstr_armisc_info_zeroread     ) , // output
        .mstr_arready                   (mstr_arready                  ) , // input 

        // AXI master read response & read data
        .mstr_rid                 (mstr_rid                ) , // input 
        .mstr_rvalid              (mstr_rvalid             ) , // input 
        .mstr_rlast               (mstr_rlast              ) , // input 
        .mstr_rdata               (mstr_rdata              ) , // input 
        .mstr_rresp               (mstr_rresp              ) , // input 
        .mstr_rmisc_info          (mstr_rmisc_info         ) , // input 
        .mstr_rmisc_info_cpl_stat (mstr_rmisc_info_cpl_stat) , // input 
        .mstr_rready              (mstr_rready             ) , // output

        // AXI master low power
        .mstr_csysreq (mstr_csysreq) , // input 
        .mstr_csysack (mstr_csysack) , // output
        .mstr_cactive (mstr_cactive) , // output
        .mstr_aclk    (mstr_aclk   ) , // input 
        .mstr_aresetn (mstr_aresetn) , // output

        // AXI slave interface
        // AXI slave Write address channel
        .slv_awid                     (slv_awid                    ) , // input 
        .slv_awaddr                   (slv_awaddr                  ) , // input 
        .slv_awlen                    (slv_awlen                   ) , // input 
        .slv_awsize                   (slv_awsize                  ) , // input 
        .slv_awburst                  (slv_awburst                 ) , // input 
        .slv_awlock                   (slv_awlock                  ) , // input 
        .slv_awqos                    (slv_awqos                   ) , // input 
        .slv_awcache                  (slv_awcache                 ) , // input 
        .slv_awprot                   (slv_awprot                  ) , // input 
        .slv_awvalid                  (slv_awvalid                 ) , // input 
        .slv_awmisc_info              (slv_awmisc_info             ) , // input 
        .slv_awmisc_info_hdr_34dw     (slv_awmisc_info_hdr_34dw    ) , // input 
        .slv_awmisc_info_func_num     (slv_awmisc_info_func_num    ) , // input 
        .slv_awmisc_info_vfunc_active (slv_awmisc_info_vfunc_active) , // input 
        .slv_awmisc_info_vfunc_num    (slv_awmisc_info_vfunc_num   ) , // input 
        .slv_awmisc_info_p_tag        (slv_awmisc_info_p_tag       ) , // input 

        .slv_awready                  (slv_awready                 ) , // output

        // AXI slave Write data channel
        .slv_wdata                 (slv_wdata                ) , // input 
        .slv_wstrb                 (slv_wstrb                ) , // input 
        .slv_wlast                 (slv_wlast                ) , // input 
        .slv_wvalid                (slv_wvalid               ) , // input 
        .slv_wmisc_info_ep         (slv_wmisc_info_ep        ) , // input 
        .slv_wmisc_info_silentDrop (slv_wmisc_info_silentDrop) , // input 
        .slv_wready                (slv_wready               ) , // output

        // AXI slave Write response channel
        .slv_bid        (slv_bid       ) , // output
        .slv_bresp      (slv_bresp     ) , // output
        .slv_bvalid     (slv_bvalid    ) , // output
        .slv_bmisc_info (slv_bmisc_info) , // output
        .slv_bready     (slv_bready    ) , // input 
        // AXI slave Read address channel
        .slv_arid                     (slv_arid                    ) , // input
        .slv_araddr                   (slv_araddr                  ) , // input
        .slv_arlen                    (slv_arlen                   ) , // input
        .slv_arsize                   (slv_arsize                  ) , // input
        .slv_arburst                  (slv_arburst                 ) , // input
        .slv_arlock                   (slv_arlock                  ) , // input
        .slv_arqos                    (slv_arqos                   ) , // input
        .slv_arcache                  (slv_arcache                 ) , // input
        .slv_arprot                   (slv_arprot                  ) , // input
        .slv_arvalid                  (slv_arvalid                 ) , // input
        .slv_armisc_info              (slv_armisc_info             ) , // input
        .slv_armisc_info_func_num     (slv_armisc_info_func_num    ) , // input
        .slv_armisc_info_vfunc_active (slv_armisc_info_vfunc_active) , // input
        .slv_armisc_info_vfunc_num    (slv_armisc_info_vfunc_num   ) , // input

        .slv_arready                  (slv_arready                 ) , // output
        // AXI slave Read data channel
        .slv_rid        (slv_rid       ) , // output
        .slv_rdata      (slv_rdata     ) , // output
        .slv_rresp      (slv_rresp     ) , // output
        .slv_rlast      (slv_rlast     ) , // output
        .slv_rvalid     (slv_rvalid    ) , // output
        .slv_rmisc_info (slv_rmisc_info) , // output
        .slv_rready     (slv_rready    ) , // input 
        // AXI slave Low-power Channel
        .slv_csysreq (slv_csysreq) , // input 
        .slv_csysack (slv_csysack) , // output
        .slv_cactive (slv_cactive) , // output

        // clk_and_reset Signal Descriptions for axi side.
        .slv_aclk    (slv_aclk   ) , // input
        .slv_aresetn (slv_aresetn) , // output

        .radm_trgt1_vc (radm_trgt1_vc ) , // output

        .app_dbi_ro_wr_disable (app_dbi_ro_wr_disable ) , // input // Set dbi_ro_wr_en to 0, disable write to DBI_RO_WR_EN bit

        .dbi_addr         ( dbi_addr         ) , // input
        .dbi_din          ( dbi_din          ) , // input
        .dbi_cs           ( dbi_cs           ) , // input
        .dbi_cs2          ( dbi_cs2          ) , // input
        .dbi_wr           ( dbi_wr           ) , // input
        .dbi_vfunc_num    ( dbi_vfunc_num    ) , // input
        .dbi_vfunc_active ( dbi_vfunc_active ) , // input
        .dbi_func_num     ( dbi_func_num     ) , // input
        .dbi_bar_num      ( dbi_bar_num      ) , // input
        .dbi_rom_access   ( dbi_rom_access   ) , // input
        .dbi_io_access    ( dbi_io_access    ) , // input
        .lbc_dbi_ack      ( lbc_dbi_ack      ) , // output
        .lbc_dbi_dout     ( lbc_dbi_dout     ) , // output

        // START_IO:ELBI Signal Descriptions. EP Mode Only
        .ext_lbc_ack          ( ext_lbc_ack          ) , // input
        .ext_lbc_din          ( ext_lbc_din          ) , // input
        .lbc_ext_addr         ( lbc_ext_addr         ) , // output
        .lbc_ext_dout         ( lbc_ext_dout         ) , // output
        .lbc_ext_cs           ( lbc_ext_cs           ) , // output
        .lbc_ext_wr           ( lbc_ext_wr           ) , // output
        .lbc_ext_dbi_access   ( lbc_ext_dbi_access   ) , // output
        .lbc_ext_rom_access   ( lbc_ext_rom_access   ) , // output
        .lbc_ext_io_access    ( lbc_ext_io_access    ) , // output
        .lbc_ext_bar_num      ( lbc_ext_bar_num      ) , // output
        .lbc_ext_vfunc_num    ( lbc_ext_vfunc_num    ) , // output
        .lbc_ext_vfunc_active ( lbc_ext_vfunc_active ) , // output
        // END_IO:ELBI Signal Descriptions.

        // START_IO:CII Signal Descriptions. EP Mode Only
        .lbc_cii_hv               (lbc_cii_hv               ) , // output
        .lbc_cii_hdr_poisoned     (lbc_cii_hdr_poisoned     ) , // output
        .lbc_cii_hdr_type         (lbc_cii_hdr_type         ) , // output
        .lbc_cii_hdr_first_be     (lbc_cii_hdr_first_be     ) , // output
        .lbc_cii_hdr_tag          (lbc_cii_hdr_tag          ) , // output
        .lbc_cii_hdr_req_id       (lbc_cii_hdr_req_id       ) , // output
        .lbc_cii_hdr_addr         (lbc_cii_hdr_addr         ) , // output
        .lbc_cii_hdr_bus_num      (lbc_cii_hdr_bus_num      ) , // output
        .lbc_cii_hdr_dev_num      (lbc_cii_hdr_dev_num      ) , // output
        .lbc_cii_hdr_func_num     (lbc_cii_hdr_func_num     ) , // output
        .lbc_cii_dv               (lbc_cii_dv               ) , // output
        .lbc_cii_data             (lbc_cii_data             ) , // output
        .cii_lbc_halt             (cii_lbc_halt             ) , // input
        .cii_lbc_override_en      (cii_lbc_override_en      ) , // input
        .cii_lbc_override_data    (cii_lbc_override_data    ) , // input
        .cii_lbc_cpl_status       (cii_lbc_cpl_status       ) , // input
        .lbc_cii_hdr_vfunc_num    (lbc_cii_hdr_vfunc_num    ) , // output
        .lbc_cii_hdr_vfunc_active (lbc_cii_hdr_vfunc_active ) , // output
        // END_IO:CII Signal Descriptions.

        .ven_msi_req          ( ven_msi_req          ) , // input
        .ven_msi_func_num     ( ven_msi_func_num     ) , // input
        .ven_msi_vfunc_num    ( ven_msi_vfunc_num    ) , // input
        .ven_msi_vfunc_active ( ven_msi_vfunc_active ) , // input
        .ven_msi_tc           ( ven_msi_tc           ) , // input
        .ven_msi_vector       ( ven_msi_vector       ) , // input
        .ven_msi_grant        ( ven_msi_grant        ) , // output
        .cfg_msi_en           ( cfg_msi_en           ) , // output
        .cfg_msi_mask         ( cfg_msi_mask         ) , // output
        .cfg_msi_pending      ( cfg_msi_pending      ) , // input
        .cfg_msi_addr         ( cfg_msi_addr         ) , // output
        .cfg_msi_data         ( cfg_msi_data         ) , // output
        .cfg_msi_64           ( cfg_msi_64           ) , // output
        .cfg_multi_msi_en     ( cfg_multi_msi_en     ) , // output
        .cfg_msi_ext_data_en  ( cfg_msi_ext_data_en  ) , // output

        .dbg_table     ( dbg_table     ) , // input
        .dbg_pba       ( dbg_pba       ) , // input
        .cfg_vf_bme    ( cfg_vf_bme    ) , // output
        .cfg_vf_en     ( cfg_vf_en     ) , // output
        .cfg_num_vf    ( cfg_num_vf    ) , // output
        .cfg_start_vfi ( cfg_start_vfi ) , // output
        // START_IO:VPD Signal Descriptions.
        // END_IO:VPD Signal Descriptions.

        // START_IO:FLR Signal Descriptions.
        .cfg_flr_pf_active ( cfg_flr_pf_active ) , // output
        .app_flr_pf_done   ( app_flr_pf_done   ) , // input
        .cfg_flr_vf_active ( cfg_flr_vf_active ) , // output
        .app_flr_vf_done   ( app_flr_vf_done   ) , // input
        // END_IO:FLR Signal Descriptions.

        // START_IO:VMI Signal Descriptions.
        .ven_msg_fmt          (ven_msg_fmt          ) , // input
        .ven_msg_type         (ven_msg_type         ) , // input
        .ven_msg_tc           (ven_msg_tc           ) , // input
        .ven_msg_td           (ven_msg_td           ) , // input
        .ven_msg_ep           (ven_msg_ep           ) , // input
        .ven_msg_attr         (ven_msg_attr         ) , // input
        .ven_msg_len          (ven_msg_len          ) , // input
        .ven_msg_func_num     (ven_msg_func_num     ) , // input
        .ven_msg_vfunc_num    (ven_msg_vfunc_num    ) , // input
        .ven_msg_vfunc_active (ven_msg_vfunc_active ) , // input
        .ven_msg_tag          (ven_msg_tag          ) , // input
        .ven_msg_code         (ven_msg_code         ) , // input
        .ven_msg_data         (ven_msg_data         ) , // input
        .ven_msg_req          (ven_msg_req          ) , // input
        .ven_msg_grant        (ven_msg_grant        ) , // output
        // END_IO:VMI Signal Descriptions.

        // START_IO:SII Signal Descriptions.
        .rx_lane_flip_en (rx_lane_flip_en ) , // input
        .tx_lane_flip_en (tx_lane_flip_en ) , // input

        .sys_int         (sys_int         ) , // input
        .apps_pm_xmt_pme (apps_pm_xmt_pme ) , // input

        .radm_q_not_empty (radm_q_not_empty ) , // output
        .radm_qoverflow   (radm_qoverflow   ) , // output

        .pm_xtlh_block_tlp (pm_xtlh_block_tlp ) , // output
        .cfg_bar0_start    (cfg_bar0_start    ) , // output
        .cfg_bar0_limit    (cfg_bar0_limit    ) , // output
        .cfg_bar1_start    (cfg_bar1_start    ) , // output
        .cfg_bar1_limit    (cfg_bar1_limit    ) , // output
        .cfg_bar2_start    (cfg_bar2_start    ) , // output
        .cfg_bar2_limit    (cfg_bar2_limit    ) , // output
        .cfg_bar3_start    (cfg_bar3_start    ) , // output
        .cfg_bar3_limit    (cfg_bar3_limit    ) , // output
        .cfg_bar4_start    (cfg_bar4_start    ) , // output
        .cfg_bar4_limit    (cfg_bar4_limit    ) , // output
        .cfg_bar5_start    (cfg_bar5_start    ) , // output
        .cfg_bar5_limit    (cfg_bar5_limit    ) , // output
        .cfg_exp_rom_start (cfg_exp_rom_start ) , // output
        .cfg_exp_rom_limit (cfg_exp_rom_limit ) , // output

        .cfg_bus_master_en    (cfg_bus_master_en    ) , // output

        .cfg_max_payload_size (cfg_max_payload_size ) , // output
        .cfg_rcb              (cfg_rcb              ) , // output

        .cfg_mem_space_en          (cfg_mem_space_en    ) , // output
        .cfg_max_rd_req_size       (cfg_max_rd_req_size ) , // output

        .cfg_ext_tag_en            (cfg_ext_tag_en      ) , // output

        .rdlh_link_up              (rdlh_link_up        ) , // output
        .smlh_ltssm_state          (smlh_ltssm_state    ) , // output
        .pm_curnt_state            (pm_curnt_state      ) , // output

        .smlh_ltssm_state_rcvry_eq (smlh_ltssm_state_rcvry_eq ) , // output
        .smlh_link_up              (smlh_link_up              ) , // output
        .smlh_req_rst_not          (smlh_req_rst_not          ) , // output
        .link_req_rst_not          (link_req_rst_not          ) , // output
        .brdg_slv_xfer_pending     (brdg_slv_xfer_pending     ) , // output
        .brdg_dbi_xfer_pending     (brdg_dbi_xfer_pending     ) , // output
        .edma_xfer_pending         (edma_xfer_pending         ) , // output
        .radm_xfer_pending         (radm_xfer_pending         ) , // output

        .cfg_reg_serren     (cfg_reg_serren     ) , // output
        .cfg_cor_err_rpt_en (cfg_cor_err_rpt_en ) , // output
        .cfg_nf_err_rpt_en  (cfg_nf_err_rpt_en  ) , // output
        .cfg_f_err_rpt_en   (cfg_f_err_rpt_en   ) , // output

        .cxpl_debug_info    (cxpl_debug_info    ) , // output
        .cxpl_debug_info_ei (cxpl_debug_info_ei ) , // output

        .training_rst_n      (training_rst_n      ) , // output
        .radm_pm_turnoff     (radm_pm_turnoff     ) , // output
        .radm_msg_unlock     (radm_msg_unlock     ) , // output
        .outband_pwrup_cmd   (outband_pwrup_cmd   ) , // input

        .pm_dstate           (pm_dstate           ) , // output
        .aux_pm_en           (aux_pm_en           ) , // output
        .pm_pme_en           (pm_pme_en           ) , // output
        .pm_linkst_in_l0s    (pm_linkst_in_l0s    ) , // output
        .pm_linkst_in_l1     (pm_linkst_in_l1     ) , // output
        .pm_l1_entry_started (pm_l1_entry_started ) , // output
        .pm_linkst_in_l2     (pm_linkst_in_l2     ) , // output
        .pm_linkst_l2_exit   (pm_linkst_l2_exit   ) , // output

        .pm_status        (pm_status        ) , // output
        .cfg_pbus_num     (cfg_pbus_num     ) , // output
        .cfg_pbus_dev_num (cfg_pbus_dev_num ) , // output

        .radm_vendor_msg  (radm_vendor_msg  ) , // output

        .radm_msg_payload (radm_msg_payload ) , // output
        .wake             (wake             ) , // output
        .radm_msg_req_id  (radm_msg_req_id  ) , // output
        // END_IO:SII Signal Descriptions.

        .trgt_cpl_timeout              (trgt_cpl_timeout              ) , // output
        .trgt_timeout_cpl_func_num     (trgt_timeout_cpl_func_num     ) , // output
        .trgt_timeout_cpl_vfunc_num    (trgt_timeout_cpl_vfunc_num    ) , // output
        .trgt_timeout_cpl_vfunc_active (trgt_timeout_cpl_vfunc_active ) , // output
        .trgt_timeout_cpl_tc           (trgt_timeout_cpl_tc           ) , // output
        .trgt_timeout_cpl_attr         (trgt_timeout_cpl_attr         ) , // output
        .trgt_timeout_cpl_len          (trgt_timeout_cpl_len          ) , // output
        .trgt_timeout_lookup_id        (trgt_timeout_lookup_id        ) , // output
        .trgt_lookup_id                (trgt_lookup_id                ) , // output
        .trgt_lookup_empty             (trgt_lookup_empty             ) , // output

        // completion timeout interface
        .radm_cpl_timeout          ( radm_cpl_timeout          ) , // output
        .radm_timeout_func_num     ( radm_timeout_func_num     ) , // output
        .radm_timeout_vfunc_num    ( radm_timeout_vfunc_num    ) , // output
        .radm_timeout_vfunc_active ( radm_timeout_vfunc_active ) , // output
        .radm_timeout_cpl_tc       ( radm_timeout_cpl_tc       ) , // output
        .radm_timeout_cpl_attr     ( radm_timeout_cpl_attr     ) , // output
        .radm_timeout_cpl_len      ( radm_timeout_cpl_len      ) , // output
        .radm_timeout_cpl_tag      ( radm_timeout_cpl_tag      ) , // output

        .edma_int          ( edma_int          ) , // output
        .assert_inta_grt   ( assert_inta_grt   ) , // output
        .assert_intb_grt   ( assert_intb_grt   ) , // output
        .assert_intc_grt   ( assert_intc_grt   ) , // output
        .assert_intd_grt   ( assert_intd_grt   ) , // output
        .deassert_inta_grt ( deassert_inta_grt ) , // output
        .deassert_intb_grt ( deassert_intb_grt ) , // output
        .deassert_intc_grt ( deassert_intc_grt ) , // output
        .deassert_intd_grt ( deassert_intd_grt ) , // output
        .cfg_int_pin       ( cfg_int_pin       ) , // output

        .cfg_send_cor_err   ( cfg_send_cor_err   ) , // output
        .cfg_send_nf_err    ( cfg_send_nf_err    ) , // output
        .cfg_send_f_err     ( cfg_send_f_err     ) , // output
        .cfg_int_disable    ( cfg_int_disable    ) , // output
        .cfg_no_snoop_en    ( cfg_no_snoop_en    ) , // output
        .cfg_relax_order_en ( cfg_relax_order_en ) , // output

        .cfg_link_eq_req_int      ( cfg_link_eq_req_int      ) , // output
        .usp_eq_redo_executed_int ( usp_eq_redo_executed_int ) , // output

        .app_margining_ready          ( app_margining_ready          ) , // input
        .app_margining_software_ready ( app_margining_software_ready ) , // input

        .core_clk   ( core_clk  ) , // output
        .core_rst_n (core_rst_n ) , // output

        .pm_master_state ( pm_master_state ), // output
        .pm_slave_state  ( pm_slave_state  ), // output

        .cfg_neg_link_width     ( cfg_neg_link_width     ) , // output
        .pm_aspm_l1_enter_ready ( pm_aspm_l1_enter_ready ) , // output

        .radm_slot_pwr_limit    ( radm_slot_pwr_limit    ) , // output
        .radm_slot_pwr_payload  ( radm_slot_pwr_payload  ) , // output
    );

endmodule: pcie_ep
