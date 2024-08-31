module dynamic_array;
    int dyn[], d2[];              //声明动态数组，此时相当于定义了动态数组的指针(句柄)
    initial begin             
        dyn=new[5];               // 分配5个元素和对应内存空间，默认值为0
        foreach(dyn[j]) dyn[j]=j; // 对元素进行初始化
        d2=dyn;                   //复制一个动态数组，只是复制了数组的值，并没有复制地址
        d2[0]=5;                  //更改元素的值
        $display(d2);             
        $display(dyn);            
        dyn=new[20](dyn);         //分配20个整数值并进行复制, 新的数组的开始5个数用旧的元素覆盖
	    $display(dyn);
        dyn=new[100];             //分配100个新的元素, 旧值不复存在
	    $display(dyn);
        dyn.delete();             //删除所有元素
    end
endmodule

//在调用之前，必须用new[]来指定宽度