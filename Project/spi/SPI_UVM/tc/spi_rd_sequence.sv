//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : spi_rd_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef SPI_RD_SEQUENCE_SV
`define SPI_RD_SEQUENCE_SV

class spi_rd_sequence extends uvm_sequence;
    
    apb_cfg_sequence      apb_cfg_seq;
    apb_wr_data_sequence  apb_wr_seq ;
    spi_rd_sequence       spi_rd_seq ;
    apb_rd_data_sequence  apb_rd_seq ;

    string        name;

    `uvm_declare_p_sequencer(virtual_sequencer)

    `uvm_object_utils(spi_rd_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:spi_rd_sequence

task spi_rd_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task spi_rd_sequence::body();
    `uvm_do_on(apb_cfg_seq,p_sequencer.apb_sqr)
    fork
        `uvm_do_on(apb_wr_seq,p_sequencer.apb_sqr)
        `uvm_do_on(spi_rd_seq,p_sequencer.spi_sqr)
        `uvm_do_on(apb_rd_seq,p_sequencer.apb_sqr)
    join
endtask:body

task spi_rd_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
