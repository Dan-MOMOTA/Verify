//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : spi_driver.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef SPI_DRIVER_SV
`define SPI_DRIVER_SV

class spi_driver;
    
    string       name         ;
    mailbox      gen2drv_chan ;
    spi_reg_cfg  spi_cfg      ;

    virtual spi_interface  drv_spi_if   ;

    function new (string                    name   = " ", 
                 spi_reg_cfg                spi_cfg     ,
                 virtual spi_interface      drv_spi_if  ,
                 mailbox                    gen2drv_chan
                 ); 
        this.name         = name         ;
        this.spi_cfg      = spi_cfg      ;
        this.drv_spi_if   = drv_spi_if   ;
        this.gen2drv_chan = gen2drv_chan ;
    endfunction:new
    extern virtual task          main_phase   ();
endclass:spi_data_driver

task spi_driver::main_phase();
    spi_transaction tr  ;
    int              num;
    if(spi_cfg.spi_rxfen == 1'b1) begin
        while(1) begin
            this.gen2drv_chan.get(tr);
            wati(this.drv_spi_if.csn == 0);
            foreach(tr.spi_data[i]) begin
                if((i == 0) && (spi_cfg.spi_mode[0] == 0)) begin
                    this.drv_spi_if.miso <= (spi_cfg.spi_lsb1st) ? tr.spi_data[i] : tr.spi_data[spi_cfg.spi_length-1];
                end
                else begin
                    case(spi_cfg.spi_mode)
                        2'b00,2'b11: begin
                            @this.drv_spi_if.drv_n_cb;
                            this.drv_spi_if.drv_n_cb.miso <= (spi_cfg.spi_lsb1st) ? tr.spi_data[i] : tr.spi_data[spi_cfg.spi_length-i-1];
                        end
                        2'b01,2'b10: begin
                            @this.drv_spi_if.drv_p_cb;
                            this.drv_spi_if.drv_p_cb.miso <= (spi_cfg.spi_lsb1st) ? tr.spi_data[i] : tr.spi_data[spi_cfg.spi_length-i-1];
                        end
                    endcase
                end
                num++;
                if(num == plus::plus_data_wr_num) begin
                    break;
                end
            end
        end
    end

endtask:main_phase

`endif
