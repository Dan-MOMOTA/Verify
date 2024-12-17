//================================================================
// Copyright (C) 2023 Dan. All rights reserved.
// 
// File Name   : top.sv
// Creator     : Dan
// Create Date : 2024-12-15- 15:17:39
// Description : 
// 
//================================================================

`ifndef TOP_SV
`define TOP_SV
module test_top();
    
    parameter    PERIOD = 20;
    //1.Define Signal
    //system
    reg clk   ; 
    reg rst ; 

    //gpu interface
    wire                                start                                                   ; // input 
    wire                                done                                                    ; // output
    wire                                device_control_write_enable                             ; // input
    wire [7:0]                          device_control_data                                     ; // input
    // Program Memory
    wire [PROGRAM_MEM_NUM_CHANNELS-1:0] program_mem_read_valid                                  ; // output
    wire [PROGRAM_MEM_ADDR_BITS-1:0]    program_mem_read_address [PROGRAM_MEM_NUM_CHANNELS-1:0] ; // output
    wire [PROGRAM_MEM_NUM_CHANNELS-1:0] program_mem_read_ready                                  ; // input
    wire [PROGRAM_MEM_DATA_BITS-1:0]    program_mem_read_data [PROGRAM_MEM_NUM_CHANNELS-1:0]    ; // input
    // Data Memory
    wire [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_read_valid                                     ; // output
    wire [DATA_MEM_ADDR_BITS-1:0]       data_mem_read_address [DATA_MEM_NUM_CHANNELS-1:0]       ; // output
    wire [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_read_ready                                     ; // input
    wire [DATA_MEM_DATA_BITS-1:0]       data_mem_read_data [DATA_MEM_NUM_CHANNELS-1:0]          ; // input
    wire [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_write_valid                                    ; // output
    wire [DATA_MEM_ADDR_BITS-1:0]       data_mem_write_address [DATA_MEM_NUM_CHANNELS-1:0]      ; // output
    wire [DATA_MEM_DATA_BITS-1:0]       data_mem_write_data [DATA_MEM_NUM_CHANNELS-1:0]         ; // output
    wire [DATA_MEM_NUM_CHANNELS-1:0]    data_mem_write_ready                                    ; // input

    //instance DUT
    gpu u_pgu(
        .clk                         (clk                         ),
        .reset                       (rst                         ),
        .start                       (start                       ),
        .done                        (done                        ),
                                      
        // Device Control Register 
        .device_control_write_enable (device_control_write_enable ),
        .device_control_data         (device_control_data         ),
                                      
        // Program Memory         
        .program_mem_read_valid      (program_mem_read_valid      ),
        .program_mem_read_address    (program_mem_read_address    ),
        .program_mem_read_ready      (program_mem_read_ready      ),
        .program_mem_read_data       (program_mem_read_data       ),
                                                                 
        // Data Memory           
        .data_mem_read_valid         (data_mem_read_valid         ),
        .data_mem_read_address       (data_mem_read_address       ),
        .data_mem_read_ready         (data_mem_read_ready         ),
        .data_mem_read_data          (data_mem_read_data          ),
        .data_mem_write_valid        (data_mem_write_valid        ),
        .data_mem_write_address      (data_mem_write_address      ),
        .data_mem_write_data         (data_mem_write_data         ),
        .data_mem_write_ready        (data_mem_write_ready        )
    );

    //gen input and connect signal
    initial begin
        clk = $urandom;
        forever begin
            #(PERIOD/2) clk = ~clk;
        end
    end
    
    initial begin
        rst = 1'b0;
        #($urandom_range(200,  2000)) rst = 1'b1;
        #($urandom_range(2000, 5000)) rst = 1'b0;
    end

    gpu_interface drv_gpu_if (clk, rst);
    gpu_interface mon_gpu_if (clk, rst);

    //gpu drv
    assign start                        = drv_gpu_if.start                       ; 
    assign device_control_write_enable  = drv_gpu_if.device_control_write_enable ; 
    assign device_control_data          = drv_gpu_if.device_control_data         ; 
    assign program_mem_read_ready       = drv_gpu_if.program_mem_read_ready      ; 
    assign program_mem_read_data        = drv_gpu_if.program_mem_read_data       ; 
    assign data_mem_read_ready          = drv_gpu_if.data_mem_read_ready         ; 
    assign data_mem_read_data           = drv_gpu_if.data_mem_read_data          ; 
    assign data_mem_write_ready         = drv_gpu_if.data_mem_write_ready        ; 
    assign drv_gpu_if.done                         = done                        ; 
    assign drv_gpu_if.program_mem_read_valid       = program_mem_read_valid      ; 
    assign drv_gpu_if.program_mem_read_address     = program_mem_read_address    ; 
    assign drv_gpu_if.data_mem_read_valid          = data_mem_read_valid         ; 
    assign drv_gpu_if.data_mem_read_address        = data_mem_read_address       ; 
    assign drv_gpu_if.data_mem_write_valid         = data_mem_write_valid        ; 
    assign drv_gpu_if.data_mem_write_address       = data_mem_write_address      ; 
    assign drv_gpu_if.data_mem_write_data          = data_mem_write_data         ; 

    //gpu mon
    assign mon_gpu_if.start                        = start                       ; 
    assign mon_gpu_if.done                         = done                        ; 
    assign mon_gpu_if.device_control_write_enable  = device_control_write_enable ; 
    assign mon_gpu_if.device_control_data          = device_control_data         ; 
    assign mon_gpu_if.program_mem_read_valid       = program_mem_read_valid      ; 
    assign mon_gpu_if.program_mem_read_address     = program_mem_read_address    ; 
    assign mon_gpu_if.program_mem_read_ready       = program_mem_read_ready      ; 
    assign mon_gpu_if.program_mem_read_data        = program_mem_read_data       ; 
    assign mon_gpu_if.data_mem_read_valid          = data_mem_read_valid         ; 
    assign mon_gpu_if.data_mem_read_address        = data_mem_read_address       ; 
    assign mon_gpu_if.data_mem_read_ready          = data_mem_read_ready         ; 
    assign mon_gpu_if.data_mem_read_data           = data_mem_read_data          ; 
    assign mon_gpu_if.data_mem_write_valid         = data_mem_write_valid        ; 
    assign mon_gpu_if.data_mem_write_address       = data_mem_write_address      ; 
    assign mon_gpu_if.data_mem_write_data          = data_mem_write_data         ; 
    assign mon_gpu_if.data_mem_write_ready         = data_mem_write_ready        ; 

    //instance TB
    //tb i_tb(drv_reg_if,drv_data_if,mon_data_if,drv_gpu_if,mon_gpu_if);

    initial begin
        uvm_config_db#(virtual gpu_interface)::set(null, "uvm_test_top.env.gpu_agt.gpu_drv", "drv_gpu_if", drv_gpu_if);
        uvm_config_db#(virtual gpu_interface)::set(null, "uvm_test_top.env.gpu_agt.gpu_mon", "mon_gpu_if", mon_gpu_if);
    end

    //finish
    initial begin
        $timeformat(-9,3,"ns",8);
    end

    initial begin
        run_test();
    end
    
    //initial begin
    //    string name;
    //    if($test$plusargs("WAV_DUMP")) begin
    //        if($value$plusargs("tc_name=%s",name)) begin
    //            $fsdbDumpfile({name,"fsdb"});
    //            $fsdbDumpvars(0,test_top);
    //            $fsdbDumpMDA();
    //            $fsdbDumpSVA();
    //        end
    //    end
    //end
endmodule

`endif
