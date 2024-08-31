class Packet;
    rand int length;
    constraint c_short {length inside {[1:32]};}
    constraint c_long  {length inside {[1000:1022]};}
endclass

module tb;
    Packet p;
    initial begin
        p = new();
        p.c_short.constraint_mode(0);
        assert(p.randomize());
        $display("LONG length = %0d",p.length);
        p.constraint_mode(0);
        assert(p.randonize());
        $display("ALL length = %0d",p.length);
        p.c_short.constraint_mode(1);
        $display("SHORT length = %0d",p.length);
    end
endmodule