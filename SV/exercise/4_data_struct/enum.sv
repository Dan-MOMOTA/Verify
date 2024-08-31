//color.first()    first method：function int first（ref index）；color第一个index
//color.last()    last method：function int last（ref index）； color最后一个index
//color.next()   next method：function int next（ref index）；color给定index的下一个index
//color.prev()   prev method：function int prev（ref index）；color给定index的前一个index
//color.num()   num method： function int num(); color 数目
//color.name() 

typedef enum {GREEN=1,YELLOW,RED=10,BLUE} colors;
//typedef enum {GREEN=1,YELLOW,RED,BLUE=3} colors;
//typedef enum {GREEN,YELLOW,RED,BLUE} colors;
module top_tb;
	initial begin
	colors color;
	//color=YELLOW;
	color=10;
	$display("color.first()=%0d",color.first());
	$display("color.last()=%0d",color.last());
	$display("color.next()=%0d",color.next());
	$display("color.prev()=%0d",color.prev());
	$display("color.num()=%0d",color.num());
	$display("color.name()=%0d",color.name());
	end
endmodule

//仿真结果
//color.first()=1
//color.last()=11
//color.next()=11
//color.prev()=2
//color.num()=4
//color.name()=RED