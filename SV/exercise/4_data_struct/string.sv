module string;
 
	string s;
	initial begin
		s = "IEEE ";						
		$display(s.getc(0));               // 显示‘I’的ASCII码, 73. 
		$display("%s",s.getc(0));          // 显示‘I’ 
		$display(s.tolower());             // 显示 ieee 
		s.putc(s.len()-1,"-");             // 将空格变为‘-’ 
		s = {s,"P1800"};                   // "IEEE-P1800" 
		$display(s);                       // 显示 "IEEE-P1800"EE-P 
		$display(s.substr(2,5));           // 显示 EE-P  
		my_log($sformatf("%s %0d",s, 42)); // 创建一个临时字符串并将其打印 ,设置占用位宽为0
	end                                    
	
	task my_log(string message);
		$display("@%0t: %s",$time,message);// 打印消息
	endtask
 
endmodule

//$sformat和$sformat的不同点:
//    1、$sformat()比s$stormatf()多了第一个参数，第一个参数就是放整理好的字符串的容器。$sformat()会直接把整理好的字符串放到第一个字符串类型的参数中。
//    2、$sformatf()没有$sformat()第一个参数。$sformatf()返回的值就是整理好的字符串。
//    3、$sprintf()函数与$sformatf()函数类似。