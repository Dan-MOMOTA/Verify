//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_sequencer.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_SEQUENCER_SV
`define SPI_SEQUENCER_SV

class spi_sequencer extends uvm_sequencer #(spi_transaction);

    `uvm_component_utils(spi_sequencer)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
endclass:spi_sequencer

function void spi_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

function void spi_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task spi_sequencer::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask:main_phase

`endif
