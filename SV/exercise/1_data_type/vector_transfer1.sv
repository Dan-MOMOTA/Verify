module vector_transfer1();
	byte signed_vector=8'b1000_0000;
	bit [8:0] result_vector;
	
	initial begin
		result_vector=signed_vector;
		$display("@1 result_vector='h%x",result_vector);
		result_vector=unsigned'(signed_vector);
		$display("@2 result_vector='h%x",result_vector);
		end
endmodule

//仿真结果
//@1 result_vector = 'h180
//@2 result_vector = 'h080