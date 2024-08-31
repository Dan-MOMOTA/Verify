//关联数组的语法如下:
//data_type array_id [index_type];
//data_type 是数组元素的数据类型。可以是适用于固定大小数组的任何类型
//array_id 是要声明的数组的名称。
//index_type 是作为索引的数据类型或是*。

//关联数组：索引不规则，且稀疏分布，存取速度是最慢的,因为过程中要有大量算法实现

//一些function
//num()---返回数组长度
//delete()---删除指定索引或者所有元素
//exists()---检查是否存在该索引，存在返回1，否则返回0
//first()---将指定的索引变量赋值为数组第一个索引的值
//last()---将指定的索引变量赋值为数组最后一个索引的值
//next()---索引变量被赋值为下一个条目的索引
//prev()---索引变量被赋值为上一个条目的索引

bit [63:0] assoc[bit[31:0]];//64bit数据的关联数组，以32bit数据为索引
int age[string];//int类型数据的关联数组，以字符串为索引
integer i_array[*];//int类型数据的关联数组，未规定索引类型，通配
event ev_array[myClass];//事件类型的关联数组，以类myClass为索引

//赋值
int imem[int];
imem[2'b3] = 1; //索引为2'b3，索引值为1
imem[16'hffff] = 2;//索引为16'hffff，索引值为2
imem[4b'1000] = 5;//索引为4b'1000 ，索引值为5
$display("关联数组中有%0d 个键值对\n", imem.num);//3个

module associative_array;
    integer i_a[*];
    bit[31:0] i_b[string];
    //int i_c[some_class];

    int i;
    integer q;
    string str;

    initial begin
        i_a[0] = 1;
        i_a[3] = 3;
        i_a[5] = 5;

        //illegal
        //foreach (i_a[i])
        //    begin
        //        $display("i_a[%0d] = %0d", i, i_a[i]);
        //    end

        for(i=0; i<3; i++)
            $display("i_a[%0d] = %0d", i, i_a[i]);
        i_a.first(q);
        $display("first is %0d", q);
        i_a.next(q);
        $display("next is %0d", q);
        i_a.next(q);
        $display("next is %0d", q);

        i_b["zhao"] = 32'h3;
        i_b["zhang"] = 32'h4;
        i_b["zhong"] = 32'h5;

        str = "zhang";
        if(i_b.exists(str))
            $display("i_b[%s] is %0d",str, i_b[str]);
        else begin
            $display("no exists this item");
        end

        $display("i_b[string] size is %0d",i_b.size());
        i_b.delete("zhang");
        $display("deleted zhang");
        $display("i_b[string] size is %0d",i_b.size());
    end
endmodule;

//仿真结果
//i_a[0] = x
//i_a[1] = 1
//i_a[2] = x
//first is 1
//next is 3
//next is 5
//i_b[zhang] is 4
//i_b[string] size is 3
//deleted zhang
//i_b[string] size is 2