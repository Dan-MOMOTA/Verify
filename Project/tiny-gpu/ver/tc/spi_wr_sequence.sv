//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : spi_wr_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef SPI_WR_SEQUENCE_SV
`define SPI_WR_SEQUENCE_SV

class spi_wr_sequence extends uvm_sequence #(apb_transaction);
    
    apb_cfg_sequence      cfg_seq;
    apb_wr_data_sequence  wr_seq;

    string        name;

    `uvm_object_utils(spi_wr_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:spi_wr_sequence

task spi_wr_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task spi_wr_sequence::body();
    `uvm_do(cfg_seq)
    `uvm_do(wr_seq)
endtask:body

task spi_wr_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
