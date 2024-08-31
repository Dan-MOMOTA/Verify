//常用于指定%t显示的时间格式
$timeformat (units_number, precision_number,suffix_string,minimum_field_width)；
//units_number : -9 表示ns; -12表示ps; -15表示fs;
//precision_number: 数据精度,小数点后的多少位;
//suffix_string: 时间值之后的字符串;
//minimum_field_width：时间字符串字段的最小宽度;

module timing;
    timeunit 1ns; // 时间单位
    timeprecision 1ps; // 时间精度   这种方式仅作用与当前module
 
    initial begin
        $timeformat(-9,3,"ns",8);
        #1 $display(“%t”,$realtime); // 1.000ns
        #2ns $display(“%t”,$realtime); // 3.000ns
        #0.1 $display(“%t”,$realtime); // 3.100ns
        #41ps $display(“%t”,$realtime); // 3.141ns
    end
endmodule

//仿真结果
//1.000ns
//3.000ns
//3.100ns
//3.141ns

//$time和$realtime
//time返回的是根据时间精度要求进行舍入的整数,不带小数;
//realtime是带小数的完整实数