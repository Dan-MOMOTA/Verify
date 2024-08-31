//struct {bit [7:0] r, g, b;} pixel;
//tupedef struct {bit [7:0] r, g, b;} pixel_s;


module pixel_array();
	typedef struct{
	bit [7:0] r;
	bit [7:0] g;
	bit [7:0] b;
	} pixel_s;  //非压缩结构体
	
	typedef struct packed{
	bit [7:0] r;
	bit [7:0] g;
	bit [7:0] b;
	} pixel_t;  //压缩结构体
	
	pixel_s my_pixel;
	pixel_t my_pixel1;
	
	initial begin
	my_pixel = '{'h10,'h10,'h10};
	my_pixel1 = {'h10,'h10,'h10}; 
	$display(my_pixel);
	$display(my_pixel1);
	my_pixel = '{8'h10,8'h10,8'h10};
	my_pixel1 = {8'h10,8'h10,8'h10};
	$display(my_pixel);
	$display(my_pixel1);
	end
endmodule

//仿真结果
//@1:'{r:'h10,g:'h10,b:'h10}
//@2:'{r:'h0,g:'h0,b:'h10}
//@1:'{r:'h10,g:'h10,b:'h10}
//@2:'{e:'h10,g:'h10,b:'h10}