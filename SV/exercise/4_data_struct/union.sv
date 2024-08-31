module union_pixel();
	typedef struct packed{
		bit [7:0] r;
		bit [7:0] g;
		bit [7:0] b;
		} pixel_rgb_t;
		
	typedef struct packed{
		bit [7:0] y;
		bit [7:0] u;
		bit [7:0] v;
		} pixel_yuv_t;
		
	typedef union packed{
		pixel_rgb_t rgb;
		pixel_yuv_t yuv;
		} pixel_t;
		
	pixel_t pixel_test;
	
	initial begin
	pixel_test = 0;
	$display("color RGB is: R=%h, G=%h, B=%h",
	pixel_test.rgb.r,pixel_test.rgb.g,pixel_test.rgb.b);
	$display("color YUV is: Y=%h, U=%h, V=%h",
	pixel_test.yuv.y,pixel_test.yuv.u,pixel_test.yuv.v);
	
	pixel_test.rgb.r=8'hab;
	pixel_test.rgb.g=8'hcd;
	pixel_test.rgb.b=8'hef;
	$display("color YUV is: Y=%h, U=%h, V=%h",
	pixel_test.yuv.y,pixel_test.yuv.u,pixel_test.yuv.v);
	end
endmodule

//仿真结果
//color RGB is: R=00, G=00, B=00
//color YUV is: Y=00, U=00, V=00
//color YUV is: Y=ab, U=cd, V=ef