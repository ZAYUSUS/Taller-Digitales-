`timescale 1ns / 1ps

module Multi4#(parameter int unsigned WIDTH=4)(//WIDTH:tamaño de los buses
    input [1:0] S,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input [WIDTH-1:0] C,
    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Y
    );
    //si hay un cambio en alguna entrada el multiplexor actualizar� sus datos.
    always @(A or B or C or D or S)begin
        case (~S)
            2'b00 : Y <= ~A; //se otorga el valor de a  en out si el selector es 0
            2'b01 : Y <= ~B; //se otorga el valor de b  en out si el selector es 1
            2'b10 : Y <= ~C;//se otorga el valor de c  en out si el selector es 2
            2'b11 : Y <= ~D;//se otorga el valor de d  en out si el selector es 3
        endcase
    end
endmodule