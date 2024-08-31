module vector_transfer2();
	logic [3:0] x_vector=4'b111x;
	bit   [2:0] bit_vector;
	
	initial begin
	$fsdbDumpfile("vector_transfer2.fsdb");
	$fsdbDumpvars;
	end
	
	initial begin
	$display("@1 x_vector='b%b",x_vector);
	bit_vector=x_vector;
	$display("@2 bit_vector='b%b",bit_vector);
	end
endmodule

//仿真结果
//@1 x_vector = 'b111x
//@2 bit_vector = 'b110