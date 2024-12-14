//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : tb.sv
// Creator     : Dan
// Create Date : 2023-08-23- 20:48:39
// Description : 
// 
//================================================================

`ifndef TB_SV
`define TB_SV

program automatic tb(
                    spi_reg_interface  drv_reg_if  ,
                    spi_data_interface drv_data_if ,
                    spi_data_interface mon_data_if ,
                    spi_interface      drv_spi_if  ,
                    spi_interface      mon_spi_if  
                    );
    
    plus    plus_arg;
    spi_env env;

    initial begin
        plus_arg = new();
        env = new("spi_env",drv_reg_if,drv_data_if,mon_data_if,drv_spi_if,mon_spi_if);
        env.build_phase ();
        env.config_phase();
        env.reset_phase ();
        env.main_phase  ();
    end
endprogram

`endif