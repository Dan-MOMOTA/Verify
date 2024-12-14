//================================================================
// Copyright (C) 2024 ICer. All rights reserved.
// 
// File Name   : virtual_sequence.sv
// Creator     : Dan
// Create Date : 2024-06-03 20:01:22
// Description : 
// 
//================================================================

`ifndef VIRTUAL_SEQUENCE_SV
`define VIRTUAL_SEQUENCE_SV

class virtual_sequence extends uvm_sequence #(apb_transaction);
    
    uvm_phase starting_phase ;

    apb_cfg_sequence      cfg_seq;
    apb_wr_data_sequence  wr_seq;
    // sequence ......

    aaa_sequencer a_sqr;
    bbb_sequencer b_sqr;

    string        name;

    `uvm_object_utils(virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    function new (string name = "");
        super.new(name);
        this.name = name;
        //auto objection
        //set_automatic_phase_objection(1);
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:virtual_sequence

task virtual_sequence::pre_body();
    starting_phase = get_starting_phase();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
    a_sqr = p_sequencer.a_sqr;
    b_sqr = p_sequencer.b_sqr;
endtask:pre_body

task virtual_sequenceE::body();
endtask:body

task virtual_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
