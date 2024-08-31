//Interface
interface arb_if(input bit clk);   //通常在接口的端口列表中声明时钟信号
    logic      grant;
    logic      request;
    logic      reset_n;

 clocking cb@(posedge clk);      //用于同步时钟域，相当于寄存器，将信号寄存一拍
    input      grant;            //clocking模块主要服务于TB
    output     request;
 endclocking

 modport TB (                    //定义TB视图view
     clocking   cb,
     output     reset_n);

 modport dut(                    //定义dut视图view
     input      request,
     input      reset_n,
     output     grant);

endinterface
//DUT
module arb(                 //简单的仲裁器
    input    reset_n,
    input    clk,
    input    request,
    output reg  grant);

    always @(posedge clk or negedge reset_n) begin
        if(reset_n == 1'b0)begin
            grant <= 1'b0;
        end
        else if(request == 1'b1)begin
            grant <= 1'b1;
        end
        else if(request == 1'b0)begin
            grant <= 1'b0;
        end
    end
endmodule
//Top
module ARB_TB();
    bit      clk;        
    arb_if   arbif(.*);    //隐式例化接口（clk信号名一样），等价arb_if arbif(.clk(clk));
    test     u_test(.*);   //隐私例化激励文件
    arb      u_arb(        //通过接口连接TB与DUT
                  .reset_n(arbif.reset_n),
                  .clk    (clk),
                  .request(arbif.request),
                  .grant  (arbif.grant) 
               );
     initial begin
        clk = 0;
        forever #10 clk = ~clk;
     end
endmodule

