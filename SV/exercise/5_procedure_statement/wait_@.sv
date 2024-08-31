//wait()和@()都是等待()中的内容的触发

//1.wait()中的内容为电平触发，即只要()中的内容为1就触发；而@()中的内容是0/1跳变才触发
program automatic test_event();
    logic clk,a,b,c;
    initial begin
        clk=1'b1;//固定到高电平
    end
    initial begin
        wait(clk) $display("i have reached clk");//只要clk为1就触发，因此只触发这句
    end
 
    initial begin
        @(clk) $display("reached posedge of clk");//clk跳变才触发，因此该处不会被触发
    end
endprogram

//2.wait只等待一次，@每时每刻都在等待
program automatic test_event();
    logic clk,a,b,c;
 
    initial begin
        clk=1'b0;
        #3 clk=1'b1;
    end
 
    initial begin
        fork
            begin
                #5;
                wait(clk) $display("i have reached clk");//5ns时clk已经为1，所以这句后触发
            end
            begin
                @(clk) $display("reached negedge of clk");//3ns时发生了跳变，先触发这句
            end
        join
    end
endprogram