//================================================================
// Copyright (C) 2023 ICer. All rights reserved.
// 
// File Name   : apb_rd_data_sequence.sv
// Creator     : Dan
// Create Date : 2023-09-03- 22:01:22
// Description : 
// 
//================================================================

`ifndef APB_RD_DATA_SEQUENCE_SV
`define APB_RD_DATA_SEQUENCE_SV

class apb_rd_data_sequence extends uvm_sequence #(apb_transaction);
    
    string        name;
    ral_block_SPI ral_model;

    spi_cfg       cfg;

    `uvm_object_utils(apb_rd_data_sequence)

    function new (string name = "");
        super.new(name);
        this.name = name;
    endfunction:new
    extern virtual task pre_body ();
    extern virtual task body     ();
    extern virtual task post_body();
endclass:apb_rd_data_sequence

task apb_rd_data_sequence::pre_body();
    if(starting_phase != null)begin
        starting_phase.raise_objection(this);    
    end
endtask:pre_body

task apb_rd_data_sequence::body();
    uvm_status_e status;
    bit [31:0] rdata;
    bit        intr_rxfifo;
    bit        intr_rxfifo_timeout;
    bit [5:0]  rx_fifo_num;
    int        num;

    uvm_config_db#(ral_block_SPI)::get(null, get_full_name(),"ral_model",ral_model);
    uvm_config_db#(spi_cfg)::get(null, get_full_name(),"cfg",cfg);

    while(1) begin
        wait(top.spi_interrupt == 1);
        intr_rxfifo         = rdata[2];
        intr_rxfifo_timeout = rdata[3];
        if(intr_rxfifo == 1) begin
            int rd_num;
            rd_num = $urandom_range(1,cfg.spi_txfthres_reg);
            repeat(rd_num) begin
                ral_model.RXFIFO_REG.read(status,rdata);
                num++;
                `uvm_fifo(get_full_name(),$sformatf("apb_rd_%0d:rdata = `h%0h",num,rdata),UVM_MEDIUM)
            end
        end
        else if(intr_rxfifo_timeout == 1'b0) begin
            ral_model.STUS_REG.read(status,rdata);
            rx_fifo_num = rdata[21:16];
            repeat(rx_fifo_num) begin
                ral_model.RXFIFO_REG.read(status,rdata);
                num++;
            end
            `uvm_fifo(get_full_name(),$sformatf("apb_rd_%0d:rdata = `h%0h",num,rdata),UVM_MEDIUM)
        end
        if(num == plus::plus_spi_wr_data_num) begin
            break;
        end
    end
endtask:body

task apb_rd_data_sequence::post_body();
    if(starting_phase != null)begin
        starting_phase.drop_objection(this);    
    end
endtask:post_body

`endif
