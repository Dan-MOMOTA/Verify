//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : apb_wr_data_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef APB_WR_DATA_SEQUENCE_SV
`define APB_WR_DATA_SEQUENCE_SV

class apb_wr_data_sequence extends uvm_sequence #(apb_transaction);
    
    string        name;
    ral_block_SPI ral_model;

    spi_cfg       cfg;

    `uvm_object_utils(apb_wr_data_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:apb_wr_data_sequence

task apb_wr_data_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task apb_wr_data_sequence::body();
    uvm_status_e status;
    bit [31:0] rdata;
    bit [31:0] wdata;
    uvm_config_db#(ral_block_SPI)::get(null, get_full_name(),"ral_model",ral_model);
    uvm_config_db#(spi_cfg)::get(null, get_full_name(),"cfg",cfg);

    while(1) begin
        wait(top.spi_interrupt == 1);
        ral_model.INTR_RAWSTUS_REG.read(status, rdata);
        intr_txfifo = rdata[1];
        if(intr_txfifo == 1) begin
            int wr_num;
            wr_num = $urandom_range(1,16-cfg.spi_txfthres_reg);
            if(plus::plus_spi_wr_data_num - num < wr_num) begin
                wr_num = plus::plus_spi_wr_data_num - num;
            end
            repeat(wr_num) begin
                wdata = $urandom;
                ral_model.TXFIFO_REG.write(status, wdata);
                num++;
            end
        end
        if(num == plus::plus_spi_wr_data_num) begin
            break;
        end
    end
endtask:body

task apb_wr_data_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
