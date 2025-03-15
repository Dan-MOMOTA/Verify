//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :vendor_msg_interface.sv
// Creater     :Dan
// Create Date :2025-03-15 22:56:55
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef VENDOR_MSG_INTERFACE_SV
`define VENDOR_MSG_INTERFACE_SV

class vendor_msg_interface extends uvm_;

    `uvm_component_utils(vendor_msg_interface)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
    extern virtual task          run_phase     (uvm_phase phase);
endclass:vendor_msg_interface

function void vendor_msg_interface::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void vendor_msg_interface::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task vendor_msg_interface::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

task vendor_msg_interface::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"run_phase Enter...",UVM_MEDIUM)
    super.run_phase(phase);
    `uvm_info(get_type_name(),"run_phase Exit ...",UVM_MEDIUM)
endtask:run_phase

`endif 
