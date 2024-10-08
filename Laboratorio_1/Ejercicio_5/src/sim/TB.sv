`timescale 1ns / 1ps


module TB#(parameter int unsigned WIDTH=4);
    //'h0 and 
    //'h1 or 
    //'h2 suma
    //'h3 incremento en 1
    //'h4 decremento en 1
    //'h5 resta
    //'h6 xor
    //'h7 corrimiento izquierda
    //'h8 corrimiento derecha

    reg [WIDTH-1:0] ALUA;
    reg [WIDTH-1:0] ALUB;
    reg [3:0] ALUControl;
    reg ALUFlagIn;
    wire [WIDTH-1:0] ALUResult;//salida 1
    wire C;//salida 2
    wire Z;
    reg [WIDTH-1:0] i;

    ALUP alu0(.ALUA(ALUA),
            .ALUB(ALUB),
            .ALUControl(ALUControl),
            .ALUFlagIn(ALUFlagIn),
            .ALUResult(ALUResult),
            .C(C),
            .Z(Z)
    );
    initial begin //bloque de pruebas
        ALUA<=0;
        ALUB<=0;
        ALUControl <= 'h0;
        ALUFlagIn <= 0;
        //Prueba 'h0
        for (int i =0 ; i<4;i++ ) begin
            ALUA<=$random;
            ALUB<=$random;
            ALUFlagIn <=$random;
            #5 ALUControl<='h1;
            ALUFlagIn <=$random;
            #5 ALUControl<='h2;
            ALUFlagIn <=$random;
            #5 ALUControl<='h3;
            ALUFlagIn <=$random;
            #5 ALUControl<='h4;
            ALUFlagIn <=$random;
            #5 ALUControl<='h5;
            ALUFlagIn <=$random;
            #5 ALUControl<='h6;
            ALUFlagIn <=$random;
            #5 ALUControl<='h7;
            ALUFlagIn <=$random;
            #5 ALUControl<='h8;
            ALUFlagIn <=$random;
            #5 ALUControl<='h9;
            ALUFlagIn <=$random;
            #5;
        end
        #5 $finish;
    end
    initial begin
        $dumpfile("TB.vcd");
        $dumpvars(0,TB);
    end

endmodule
