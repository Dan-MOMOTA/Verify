//=================================================================
//Copyright (C) 2025 MOMOTA Micro-electronics. All rights reserved.
// 
// File Name   :dpi_interface.sv
// Creater     :Dan
// Create Date :2025-03-15 22:55:38
// Modification History:
// 
// Description:
// 
//=================================================================

`ifndef DPI_INTERFACE_SV
`define DPI_INTERFACE_SV

class dpi_interface extends uvm_;

    `uvm_component_utils(dpi_interface)

    function new (string        name   = " ",
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          main_phase    (uvm_phase phase);
    extern virtual task          run_phase     (uvm_phase phase);
endclass:dpi_interface

function void dpi_interface::build_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"build_phase Enter...",UVM_MEDIUM)
    super.build_phase(phase);
    `uvm_info(get_type_name(),"build_phase Exit ...",UVM_MEDIUM)
endfunction:build_phase

function void dpi_interface::connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"connect_phase Enter...",UVM_MEDIUM)
    super.connect_phase(phase);
    `uvm_info(get_type_name(),"connect_phase Exit ...",UVM_MEDIUM)
endfunction:connect_phase

task dpi_interface::main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"main_phase Enter...",UVM_MEDIUM)
    super.main_phase(phase);
    `uvm_info(get_type_name(),"main_phase Exit ...",UVM_MEDIUM)
endtask:main_phase

task dpi_interface::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"run_phase Enter...",UVM_MEDIUM)
    super.run_phase(phase);
    `uvm_info(get_type_name(),"run_phase Exit ...",UVM_MEDIUM)
endtask:run_phase

`endif 
