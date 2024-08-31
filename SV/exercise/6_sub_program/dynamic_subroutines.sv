//动态子程序---内部变量不可共享，相当于每次调用子程序的时候，都单独为变量开辟了一块儿内存
module top_tb;
    reg [1:0] result_1,result_2;
    reg co_1,co_2;
 
    initial begin
    fork
        begin // p1
            #1;
            add2x2 (2'b01,result_1,co_1);
        end
        begin // p2
            #2;
            add2x2 (2'b10,result_2,co_2);
            #8;
        end
    join
    end
 
//defaut dynamic task
    task automatic add2x2(input [1:0] opt,output [1:0]result,output co);
        reg [1:0] temp;
 
        begin
            temp = opt;
            #4;
            $display("static task : %t : temp is%0d",$time,temp);
            {co,result} = temp + 2'b10;
        end
    endtask
endmodule

//仿真结果
//static task : 5 ns : temp is1
//static task : 6 ns : temp is2