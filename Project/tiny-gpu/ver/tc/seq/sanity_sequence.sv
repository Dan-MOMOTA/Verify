//================================================================
// Copyright (C) 2024 Dan. All rights reserved.
// 
// File Name   : sanity_sequence.sv
// Creator     : Dan
// Create Date : 2024-12-15- 23:05:22
// Description : 
// 
//================================================================

`ifndef SANITY_SEQUENCE_SV
`define SANITY_SEQUENCE_SV

class sanity_sequence extends uvm_sequence #(gpu_transaction);
    
    string        name;
    //ral_block_SPI ral_model;

    gpu_cfg       cfg;

    `uvm_object_utils(sanity_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:sanity_sequence

task sanity_sequence::pre_body();
    `uvm_info(get_full_name,$sformatf("pre_body() START!"), UVM_MEDIUM)
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task sanity_sequence::body();
    //int num;
    //`uvm_do_with(req,{paddr == 32'h0;pxdata == 32'h55;pwrite == PWRITE;})
    //`uvm_info(get_full_name,$sformatf("in seq:No.%0d\n\n %s",num++,req.sprint()),UVM_MEDIUM)
    //`uvm_do_with(req,{paddr == 32'h0;pxdata == 32'h66;pwrite == PWRITE;})
    //`uvm_info(get_full_name,$sformatf("in seq:No.%0d\n\n %s",num++,req.sprint()),UVM_MEDIUM)

    uvm_status_e status;
    bit [31:0] rdata;

    uvm_config_db#(gpu_cfg)::get(null, get_full_name(),"cfg",cfg);
    #100000ns;
    `uvm_do(req);
    //uvm_config_db#(ral_block_SPI)::get(null, get_full_name(),"ral_model",ral_model);
    //ral_model.CTRL_REG.write(status,cfg.ctrl_reg);
    //ral_model.CTRL_REG.write(status,cfg.baud_reg);
    //ral_model.CTRL_REG.write(status,cfg.intr_ena_reg);
    //ral_model.CTRL_REG.write(status,cfg.gpu_rxf_timeout_reg);

    //ral_model.CTRL_REG.write(status,32'h55);
    //ral_model.CTRL_REG.read(status,rdata);
    //`uvm_info(get_full_name,$sformatf("rdata = 'h%0h",rdata),UVM_MEDIUM)
    //ral_model.CTRL_REG.write(status,32'h66);
    //ral_model.CTRL_REG.read(status,rdata);
    //`uvm_info(get_full_name,$sformatf("rdata = 'h%0h",rdata),UVM_MEDIUM)
    //ral_model.CTRL_REG.write(status,32'h77,UVM_BACKDOOR);
endtask:body

task sanity_sequence::post_body();
    `uvm_info(get_full_name,$sformatf("post_body() START!"), UVM_MEDIUM)
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
