module test;
	int md[2][3]=' {'{0,1,2}, '{3,4,5}};
	initial begin
		$display("Initial value:");
	foreach(md[i,j])
		$display("md[%0d][%0d]=%0d",i,j,md[i][j]);//i为外循环，j为内循环
	for(int i;i<2;i++)
		for(int j;j<3;j++)
			$display("md[%0d][%0d]=%0d",i,j,md[i][j]);//结果与上面相同
	end
endmodule

//打印结果
//Initial value:
//md[0][0]=0
//md[0][1]=1
//md[0][2]=2
//md[1][0]=3
//md[1][1]=4
//md[1][2]=5
//md[0][0]=0
//md[0][1]=1
//md[0][2]=2
//md[1][0]=3
//md[1][1]=4
//md[1][2]=5