//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : hw_reset_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef HW_RESET_SEQUENCE_SV
`define HW_RESET_SEQUENCE_SV

class hw_reset_sequence extends uvm_reg_hw_reset_seq;
    
    string        name;
    ral_block_SPI ral_model;

    `uvm_object_utils(hw_reset_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:hw_reset_sequence

task hw_reset_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task hw_reset_sequence::body();
    uvm_config_db#(ral_block_SPI)::get(null, get_full_name(),"ral_model",ral_model);
    model = ral_model;
    super.body();
endtask:body

task hw_reset_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
