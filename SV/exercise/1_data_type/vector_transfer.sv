module vector_transfer();
	logic [7:0] logic_vector=8'b1000_0000;
	bit   [7:0] bit_vector=8'b1000_0000;
	byte  signed_vector=8'b1000_0000;
	
	
	initial begin
	
	$display("logic_vector=%d",logic_vector);
	$display("bit_vector=%d",bit_vector);
	$display("signed_vector=%d",signed_vector);
	
	end
endmodule

//仿真结果
//logic_vector = 128
//bit_vector = 128
//signed_vector = -128