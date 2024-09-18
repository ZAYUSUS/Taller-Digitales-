`timescale 1ms / 100us
module tb_contador;
    reg clk;
    reg inhibit;
    wire [1:0] out;

    contador c0(.inhibit(inhibit),
                .clk(clk),
                .out(out));
    
    always #1 clk = ~clk;

    initial begin
        clk <=0;
        inhibit <=0;
        $monitor("[%0t] Contador=0x%0h Inhibit=0x%0h",$time,out,inhibit);
        #4 inhibit <=1;

        #16 inhibit <=0;

        #10 inhibit <= 1;

        #20 $finish;
    end
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0,tb_contador);
    end

endmodule