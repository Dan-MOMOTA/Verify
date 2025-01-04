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
    
    string        name;
    uvm_phase p = get_starting_phase();

    `uvm_object_utils(seq_sanity)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:seq_sanity

task seq_sanity::pre_body();
    super.pre_body();
    `uvm_info("[seq_sanity]",$sformatf("pre_body() Enter..."), UVM_MEDIUM)
    if(p != null)begin
        p.raise_objection(this);    
    end
endtask:pre_body

task seq_sanity::body();
    `uvm_info("[seq_sanity]",$sformatf("body() Enter..."), UVM_MEDIUM)
    super.body();
    #100000ns;
    `uvm_do(req);
endtask:body

task seq_sanity::post_body();
    super.post_body();
    `uvm_info("[seq_sanity]",$sformatf("post_body() Enter..."), UVM_MEDIUM)
    if(p != null)begin
        p.drop_objection(this);    
    end
endtask:post_body

`endif
