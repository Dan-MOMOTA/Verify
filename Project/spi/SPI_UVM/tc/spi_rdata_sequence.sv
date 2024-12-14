//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : spi_rdata_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef SPI_RDATA_SEQUENCE_SV
`define SPI_RDATA_SEQUENCE_SV

class spi_rdata_sequence extends uvm_sequence #(spi_transaction);
    
    string        name;
    ral_block_SPI ral_model;

    spi_cfg       cfg;

    `uvm_object_utils(spi_rdata_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:spi_rdata_sequence

task spi_rdata_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task spi_rdata_sequence::body();
    int num;
    uvm_config_db#(spi_cfg)::get(null, get_full_name(),"cfg",cfg);
    if(cfg.spi_rxfen_reg == 1) begin
        repeat(plus::plus_spi_wr_data_num) begin
            `uvm_do_with(req,{req.data_len== cfg.spi_len;})
            num++;
            `uvm_info(get_full_name(),$sformatf("SPI_RD%0d = %s",num,req.sprint),UVM_MEDIUM)
        end
    end
endtask:body

task spi_rdata_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
