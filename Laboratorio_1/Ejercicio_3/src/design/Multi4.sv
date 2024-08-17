`timescale 1ns / 1ps

module Multi4#(int unsigned WIDTH=16)(//WIDTH:tamaño de los buses
    input [1:0] select,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    output reg [WIDTH:0] out
    );
    //si hay un cambio en alguna entrada el multiplexor actualizar� sus datos.
    always @(a or b or c or d or select)begin 
        case (select)
            2'b00 : out <=a; //se otorga el valor de a  en out si el selector es 0
            2'b01 : out <=b; //se otorga el valor de b  en out si el selector es 1
            2'b10 : out <=c;//se otorga el valor de c  en out si el selector es 2
            2'b11 : out <=d;//se otorga el valor de d  en out si el selector es 3
        endcase
    end
endmodule