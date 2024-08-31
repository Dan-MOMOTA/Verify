//inout默认为1，output默认为0
clocking ck1 @(posedge clk);
    default input #1step output negedge; // legal
    // outputs driven on the negedge clk
    input ... ;
    output ... ;
endclocking
   
clocking ck2 @(clk); // no edge specified!
    default input #1step output negedge; // legal
    input ... ;
    output ... ;
endclocking
   
clocking bus @(posedge clock1);
    default input #10ns output #2ns;
    input data, ready, enable = top.mem1.enable;
    output negedge ack;
    input #1step addr;
endclocking

//采样驱动
module	clocking1;
	bit	vld;
	bit	grt;
	bit	clk;
	
	clocking ck @ (posedge clk);
		default input #3ns  output #3ns;
		input    vld;
		output   grt;
	endclocking
	
	initial    forever    #5ns    clk <= !clk;
	
	initial begin : drv_vld
		$display("$%0t vld initial value id %d",$time,vld);
		#3ns    vld = 1;    $display("$%0t vld is assigned %d",$time,vld);
		#10ns   vld = 0;    $display("$%0t vld is assigned %d",$time,vld);
		#8ns    vld = 1;    $display("$%0t vld is assigned %d",$time,vld);	
	end
	
	initial forever // @ck == @（posedge clk）
		@ck $display ("$%0t vld is sampled as %d at sampling time $%0t",$time,vld,$time);
	initial forever
		@ck $display ("$%0t ck.vld is sampled as %d at sampling time $%0t",$time,ck.vld,$time-3);
        initial begin : drv_grt
		$display("$%0t grt initial value is %d",$time,grt);
		@ck ck.grt <= 1;$display ("$%0t grt is assigned 1",$time);
		@ck ck.grt <= 0;$display ("$%0t grt is assigned 0",$time);
		@ck ck.grt <= 1;$display ("$%0t grt is assigned 1",$time);
	 end 
	 
	 initial forever
		@grt $display ("$%0t grt is dviven sa %d",$time,grt);
endmodule
//a.代码中采用时钟块的采样时序图（ck.vld）
https://img-blog.csdnimg.cn/20200714224834647.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2MzIwOA==,size_16,color_FFFFFF,t_70
//b.代码中采用时钟块的驱动时序图
https://img-blog.csdnimg.cn/20200714224850106.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2MzIwOA==,size_16,color_FFFFFF,t_70