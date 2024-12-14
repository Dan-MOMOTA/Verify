//================================================================
// Copyright (C) 2023 Coachip-Xian. All rights reserved.
// 
// File Name   : fsm_drink.v
// Creator     : Xilin
// Create Date : 2023-02-03- 20:19:54
// Description : 
// 
//================================================================

module fsm_drink(
    input    wire           clk         , 
    input    wire           rst_n       ,  
    input    wire   [1:0]   coin        , 
    input    wire           start_flag  , 
    input    wire           cancel      , 
    output   reg            drink_out   , 
    output   reg            charge_vld  , 
    output   reg    [2:0]   charge_coin ,
    output   reg            working
    );

    parameter [2:0]  IDLE    = 3'b000;
    parameter [2:0]  START   = 3'b001;
    parameter [2:0]  COIN0_5 = 3'b010;
    parameter [2:0]  COIN1_0 = 3'b011;
    parameter [2:0]  COIN1_5 = 3'b100;
    parameter [2:0]  COIN2_0 = 3'b101;
    parameter [2:0]  COIN2_5 = 3'b110;
    parameter [2:0]  COIN3_0 = 3'b111;
   
    reg    [2:0]   cs;
    reg    [2:0]   ns;

    //1.CS
    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 0)begin
            cs <= IDLE;
        end
        else begin
            cs <= ns;
        end
    end

    //2.NS
    always @(*)begin
        case(cs)
            IDLE    : ns = (start_flag == 1'b1) ? START : IDLE;
            START   : begin
                          if(cancel == 1)begin
                              ns = IDLE;
                          end
                          else if(coin == 2'b01)begin
                              ns = COIN0_5;
                          end
                          else if(coin == 2'b10)begin
                              ns = COIN1_0;
                          end
                          else begin
                              ns = START;
                          end
                      end
            COIN0_5 : begin
                          if(cancel == 1)begin
                              ns = IDLE;
                          end
                          else if(coin == 2'b01)begin
                              ns = COIN1_0;
                          end
                          else if(coin == 2'b10)begin
                              ns = COIN1_5;
                          end
                          else begin
                              ns = COIN0_5;
                          end
                      end
            COIN1_0 : begin
                          if(cancel == 1)begin
                              ns = IDLE;
                          end
                          else if(coin == 2'b01)begin
                              ns = COIN1_5;
                          end
                          else if(coin == 2'b10)begin
                              ns = COIN2_0;
                          end
                          else begin
                              ns = COIN1_0;
                          end
                      end
            COIN1_5 : begin
                          if(cancel == 1)begin
                              ns = IDLE;
                          end
                          else if(coin == 2'b01)begin
                              ns = COIN2_0;
                          end
                          else if(coin == 2'b10)begin
                              ns = COIN2_5;
                          end
                          else begin
                              ns = COIN1_5;
                          end
                      end
            COIN2_0 : begin
                          if(cancel == 1)begin
                              ns = IDLE;
                          end
                          else if(coin == 2'b01)begin
                              ns = COIN2_5;
                          end
                          else if(coin == 2'b10)begin
                              ns = COIN3_0;
                          end
                          else begin
                              ns = COIN2_0;
                          end
                      end
            COIN2_5 : ns = IDLE;
            COIN3_0 : ns = IDLE;
            default : ns = IDLE;
        endcase
    end

    //Descript output
    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 0)begin
            drink_out <= 1'b0;
        end
        else if((ns == COIN2_5) || (ns == COIN3_0))begin
            drink_out <= 1'b1;
        end
        else begin
            drink_out <= 1'b0;
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 0)begin
            charge_vld <= 1'b0;
        end
        else begin
            case(cs)
                COIN0_5,COIN1_0,COIN1_5: begin
                    if(cancel == 1'b1)begin
                        charge_vld <= 1'b1;
                    end
                    else begin
                        charge_vld <= 1'b0;
                    end
                end
                COIN2_0: charge_vld <= ((cancel == 1'b1) || (coin == 2'b10)) ? 1'b1 : 1'b0;
                default: charge_vld <= 1'b0;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 0)begin
            charge_coin <= 3'd0;
        end
        else begin
            case(cs)
                COIN0_5 : if(cancel == 1'b1)begin
                    charge_coin <= 3'd1;
                end
                else begin
                    charge_coin <= 3'd0;
                end
                COIN1_0 : if(cancel == 1'b1)begin
                    charge_coin <= 3'd2;
                end
                else begin
                    charge_coin <= 3'd0;
                end
                COIN1_5 : if(cancel == 1'b1)begin
                    charge_coin <= 3'd3;
                end
                else begin
                    charge_coin <= 3'd0;
                end
                COIN2_0 : if(cancel == 1'b1)begin
                    charge_coin <= 3'd4;
                end
                else if(coin == 2'b10)begin
                    charge_coin <= 3'd1;
                end
                else begin
                    charge_coin <= 3'd0;
                end
                default : charge_coin <= 3'd0;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n)begin
        if(rst_n == 0)begin
            working <= 1'b0;
        end
        else if(ns == IDLE)begin
            working <= 1'b0;
        end
        else begin
            working <= 1'b1;
        end
    end
endmodule
