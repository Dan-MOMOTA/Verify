//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_driver.sv
// Creator     : Dan
// Create Date : 2023-09-03- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_DRIVER_SV
`define SPI_DRIVER_SV

class spi_driver extends uvm_driver #(spi_transaction);
    
    string                     name     ;
    virtual spi_interface      drv_spi_if;
    spi_cfg                    cfg      ;

    `uvm_component_utils(spi_driver)

    function new (string        name   = " ", 
                  uvm_component parent = null
                 );
        super.new(name,parent);
        this.name = name;
    endfunction:new
    extern virtual function void build_phase  (uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task          reset_phase  (uvm_phase phase);
    extern virtual task          main_phase   (uvm_phase phase);
endclass:spi_driver

function void spi_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual spi_interface)::get(this, "", "drv_spi_if", drv_spi_if);
    uvm_config_db#(spi_cfg)::get(this, "", "cfg", cfg);
endfunction:build_phase

function void spi_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction:connect_phase

task spi_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(get_full_name,$sformatf("reset_phase() START!"), UVM_MEDIUM)
endtask:reset_phase

task spi_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_full_name,$sformatf("main_phase() START!"), UVM_MEDIUM)
    while(1)begin
        this.seq_item_port.get_next_item(req);
        wait(this.drv_spi_if.csn == 0);
        foreach (req.spi_data[i]) begin
            if((i == 1'b0) && (cfg.spi_mode_reg[0] == 0)) begin
                this.drv_spi_if.miso <= (cfg.spi_lsb1st_reg) ? req.spi_data[i] : req.spi_data[cfg.spi_len-1];
            end
            else begin
                case(cfg.spi_mode_reg)
                    2'b00,2'b11:begin
                        @this.drv_spi_if.drv_n_cb;
                        this.drv_spi_if.drv_n_cb.miso <= (cfg.spi_lsb1st_reg) ? req.spi_data[i] : req.spi_data[cfg.spi_len-1];
                    end
                    2'b01,2'b10:begin
                        @this.drv_spi_if.drv_p_cb;
                        this.drv_spi_if.drv_p_cb.miso <= (cfg.spi_lsb1st_reg) ? req.spi_data[i] : req.spi_data[cfg.spi_len-1];
                    end
                endcase
            end
        end
        wait(this.drv_spi_if.csn == 1);
        num++;
        this.seq_item_port.item_done;
        if(num == plus::plus_spi_wr_data_num) begin
            break;
        end
    end
    `uvm_info(get_full_name(),$sformatf("main_phase() DONE!"), UVM_MEDIUM)
endtask:main_phase

`endif
