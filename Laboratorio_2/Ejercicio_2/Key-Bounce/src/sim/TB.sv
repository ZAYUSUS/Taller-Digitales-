`timescale 1ms / 100us


module KBE_TB;
    reg KeyP;
    wire Data_Available;
    wire Inhibit;

    KBE be0(
        .KeyP(KeyP),
        .Data_Available(Data_Available),
        .Inhibit(Inhibit)
    );
    initial begin //bloque de pruebas
        KeyP<=0;

        for(int i=0;i<10;i=i+1)begin
            KeyP<=$random;
            #25
            $display("[%0t] key=0x%0h Data Available=0x%0h Inhibit=0x%0h",$time,KeyP,Data_Available,Inhibit);
        end
        #5 $finish;
    end
    initial begin
        $dumpfile("KBE_TB.vcd");
        $dumpvars(0,KBE_TB);
    end

endmodule
