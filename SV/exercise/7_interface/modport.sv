// 使用mofport的接口
interface arb_if (input bit clk);
	logic [1:0] grant, request;
	logic rst;
	
	modport TEST (output request, rst,
	              input grant, clk);
	modport DUT (input request, rst, clk,
	             output grant);
	modport MONITOR (input request, grant, rst, clk);
endinterface

// 仲裁器
module arb (arb_if.DUT arbif);
	...
endmodule

// 测试平台
module test (arb_if.TEST arbif);
	...
endmodule 

// 顶层
module top;
	bit clk;
	always #5 clk = ~clk;
	
	arb_if arbif(clk);
	arb a1(arbif);
	test t1(arbif);
endmodule