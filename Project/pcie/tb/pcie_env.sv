//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :pcie_env.sv
// Creater     :Dan
// Create Date :2025-03-20 22:54:32
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef PCIE_ENV_SV
`define PCIE_ENV_SV

class pcie_env extends uvm_env;

    `uvm_component_utils(pcie_env)

    // instance pcie_vip, pcie_cfg, pcie_status
    svt_pcie_device_agent         root;
    svt_pcie_device_configuration root_cfg;
    svt_pcie_device_status        root_status;

    svt_pcie_vif vif_0;

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
endclass:pcie_env

function void pcie_env::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)

    super.build_phase(phase);
    root        = svt_pcie_device_agent::type_id::create("root", this);
    root_cfg    = svt_pcie_device_configuration::type_id::create("root_cfg", this);
    root_status = svt_pcie_device_status::type_id::create("root_status", this);

    if(uvm_config_db#(svt_pcie_vif)::get(null, "uvm_test_top", "link_0_vif_0", vif_0)) begin
        `uvm_fatal(get_type_name(),$sformatf("svt_pcie_vif not cfg"))
    end

    // cfg pcie_vip
    root_cfg.set_initial_values_via_unified_vif(1, vif_0); // set vif to root_cfg
    /* Enable Protocol Analyzer i.e. PA XML file generation */
    root_cfg.pcie_cfg.enable_tl_xml_gen = 1'b1;
    root_cfg.pcie_cfg.enable_dl_xml_gen = 1'b1;
    root_cfg.pcie_cfg.enable_pl_xml_gen = 1'b1;
    root_cfg.pcie_cfg.enable_transaction_logging = 1'b1;
    root_cfg.pcie_cfg.transaction_log_filename = {"transaction.log"};
    root_cfg.pcie_cfg.enable_symbol_logging = 1'b1;

    root_cfg.device_is_root = 1;

    // GEN5/4/3/2/1
    root_cfg.pcie_spec_ver = svt_pcie_device_configuration::PCIE_SPEC_VER_4_0;
    root_cfg.pcie_spec_ver = svt_pcie_device_configuration::PCIE_SPEC_VER_4_4;
    root_cfg.pcie_cfg.pl_cfg.set_link_speed_values(`SVT_PCIE_SPEED_16_0G | `SVT_PCIE_SPEED_8_0G | `SVT_PCIE_SPEED_2_5G);
    root_cfg.pcie_cfg.pl_cfg.set_link_width_values(16); // 16 lane

    // pcie_device_agent
    uvm_config_db#(svt_pcie_device_configuration)::set(this, "root", "cfg", this.root_cfg);

    // get pcie_vip_status
    uvm_config_db#(svt_pcie_device_status)::set(this, "root", "share_status", this.root_status);

    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void pcie_env::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

`endif // PCIE_ENV_SV
