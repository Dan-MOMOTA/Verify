//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :blk_env.sv
// Creater     :Dan
// Create Date :2025-01-04 19:17:48
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef BLK_ENV_SV
`define BLK_ENV_SV

class blk_env extends uvm_env;

    apb_agent apb_agt;

    `uvm_component_utils(blk_env)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
endclass:blk_env

function void blk_env::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    apb_agt = apb_agent::type_id::create("apb_agt", this);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void blk_env::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    // FIFO
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

`endif 
