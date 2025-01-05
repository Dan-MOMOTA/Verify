//================================================================
// Copyright (C) 2025 Dan. All rights reserved.
// 
// File Name   : seq_sanity.sv
// Creator     : Dan
// Create Date : 2025-01-01- 23:15:22
// Description : 
// 
//================================================================

`ifndef SEQ_SANITY_SV
`define SEQ_SANITY_SV

class seq_sanity extends uvm_sequence #(apb_transaction);
    
    apb_transaction apb_trans;

    string          name;
    uvm_phase       starting_phase ;

    `uvm_object_utils(seq_sanity)

    function new (string name = "");
        super.new(name);
        this.name = name;
        // auto objection: pre_start and post_start
        set_automatic_phase_objection(1);
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:seq_sanity

task seq_sanity::pre_body();
    super.pre_body();
    `uvm_info("seq_sanity",$sformatf("pre_body() Enter..."), UVM_MEDIUM)
    //starting_phase = get_starting_phase();
    //if(starting_phase != null)begin
    //    starting_phase.raise_objection(this);    
    //end
endtask:pre_body

task seq_sanity::body();
    super.body();
    `uvm_info("seq_sanity",$sformatf("body() Enter..."), UVM_MEDIUM)
    //super.body();
    #10000ns;
    repeat(10) begin
        `uvm_do(req);
    end
    `uvm_info("seq_sanity",$sformatf("body() Exit..."), UVM_MEDIUM)
endtask:body

task seq_sanity::post_body();
    super.post_body();
    `uvm_info("seq_sanity",$sformatf("post_body() Enter..."), UVM_MEDIUM)
    //if(starting_phase != null)begin
    //    starting_phase.drop_objection(this);    
    //end
endtask:post_body

`endif
