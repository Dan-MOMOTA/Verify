program test10;
    bit [31:0] src[5] = '{0,1,2,3,4},dst[5] = '{5,1,2,3,4};
    initial begin
        if (src==dst) 
			$display("src == dst");//比较数组,数量和各个位置的内容都相等才行
        else 
			$display("src != dst");
 
        dst = src;  //数组复制
        //src[0] = 5; //只改变一个元素的值
 
        //所有元素是否相等
        $display("src %s dst",(src==dst)?"==":"!=");
		//使用数组片段对第1-4个元素进行比较
        $display("src[1:4] %s dst[1:4] ",(src[1:4]==dst[1:4])?"==":"!=");
    end
endprogram
 
 
//打印结果：
//src != dst
//src == dst
//src[1:4] == dst[1:4] 