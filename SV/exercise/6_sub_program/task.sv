//Verilog
task mytask2;//无（ ）
    output[31:0] x;
    reg [31:0] x;
    input y;
    ...
endtask
//SVerilog
task mytask2 (output logic [31:0] x,input logic y);//可同时声明方向和类型
    ...
endtask

//参数传递
task many(input int a=1,b=2,c=3,d=4);//这里为形参指定默认值，当调用该task而未指定参数值时，使用默认值
    $display(“%0d %0d %0d %0d”,a,b,c,d);
endtask
 
initial begin
    many(6,7,8,9); //6 7 8 9 指定所有值,这种比较常用
    many(); //1 2 3 4 使用缺省值
    many(.c(5)); //1 2 5 4 只指定c
    many(,6,,.d(8)); //1 6 3 8 混合指定
end

//用typedef从函数中返回一个数组
typedef int fixed_array[5];
fixed_array f5;//定义一个数组
 
function fixed_array init(int start);//再定义一个数组类型的函数
    foreach(init[i]) init[i]=i+start;
endfunction
 
initial begin
    f5=init(5)；//调用函数，将函数生成的数组给f5数组，因为函数调用结束后，内存被释放掉了
    foreach(f5[i]) $display("f5[%0d]=%0d",i,f5[i]);
end

//把数组作为ref参数传递给函数---ref可认为是个指针，里面改变在外面也能看到
program example;
    int fa[5];//定义一个数组
 
    initial begin
        init(fa,5);//该函数直接修改上面的数组内存
        foreach(fa[i])    $display(“fa[%0d]=%0d”,i,fa[i]);
    end
 
    function void init(ref int f[5], input int start);//ref指向输入的数组
        foreach(f[i])    f[i]=i+start;
    endfunction
endprogram