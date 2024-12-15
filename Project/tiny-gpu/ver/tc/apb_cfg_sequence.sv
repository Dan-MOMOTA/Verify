//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : apb_cfg_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef APB_CFG_SEQUENCE_SV
`define APB_CFG_SEQUENCE_SV

class apb_cfg_sequence extends uvm_sequence #(apb_transaction);
    
    string        name;
    ral_block_SPI ral_model;

    spi_cfg       cfg;

    `uvm_object_utils(apb_cfg_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:apb_cfg_sequence

task apb_cfg_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task apb_cfg_sequence::body();
    //int num;
    //`uvm_do_with(req,{paddr == 32'h0;pxdata == 32'h55;pwrite == PWRITE;})
    //`uvm_info(get_full_name,$sformatf("in seq:No.%0d\n\n %s",num++,req.sprint()),UVM_MEDIUM)
    //`uvm_do_with(req,{paddr == 32'h0;pxdata == 32'h66;pwrite == PWRITE;})
    //`uvm_info(get_full_name,$sformatf("in seq:No.%0d\n\n %s",num++,req.sprint()),UVM_MEDIUM)
    uvm_status_e status;
    bit [31:0] rdata;
    uvm_config_db#(ral_block_SPI)::get(null, get_full_name(),"ral_model",ral_model);
    uvm_config_db#(spi_cfg)::get(null, get_full_name(),"cfg",cfg);
    ral_model.CTRL_REG.write(status,cfg.ctrl_reg);
    ral_model.CTRL_REG.write(status,cfg.baud_reg);
    ral_model.CTRL_REG.write(status,cfg.intr_ena_reg);
    ral_model.CTRL_REG.write(status,cfg.spi_rxf_timeout_reg);

    //ral_model.CTRL_REG.write(status,32'h55);
    //ral_model.CTRL_REG.read(status,rdata);
    //`uvm_info(get_full_name,$sformatf("rdata = 'h%0h",rdata),UVM_MEDIUM)
    //ral_model.CTRL_REG.write(status,32'h66);
    //ral_model.CTRL_REG.read(status,rdata);
    //`uvm_info(get_full_name,$sformatf("rdata = 'h%0h",rdata),UVM_MEDIUM)
    //ral_model.CTRL_REG.write(status,32'h77,UVM_BACKDOOR);
endtask:body

task apb_cfg_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
