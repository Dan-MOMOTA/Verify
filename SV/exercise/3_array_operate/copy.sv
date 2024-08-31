module test;
    bit [31:0] src[5] = '{0,1,2,3,4},
    dst[5];
    dst = src;     // 数组复制
    src[0] = 5;    // 只改变一个元素的值
    $display(dst); //打印dst，看其是否得到了src的值，元素[0]是旧的值还是新值；
    $display(src); //打印src，看是否改变了src[0]的值
endmodule