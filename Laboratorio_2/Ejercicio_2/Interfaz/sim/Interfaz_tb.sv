`timescale 1ms / 100us

module Interfaz_tb();
reg KeyP;
reg clk;
reg rst;
reg [1:0] columna;
wire [3:0] Q;
wire [3:0] code;
wire [1:0] fila;
Interfaz I0(
    .KeyP(KeyP),
    .clk(clk),
    .rst(rst),
    .columna(columna),
    .fila(fila),
    .Q(Q),
    .code(code)
);

    always begin #5 clk = ~clk;end

    initial begin
        rst = 0;
        clk =0;
        columna=2'b0;
        KeyP=0;
        $monitor("[%0t] Salida Q=%b Codigo=%h Presionada=%h Fila=%h Columna=%h",$time,Q,code,KeyP,fila,columna);
        for (int i =0 ;i<10 ;i++ ) begin
            #3 KeyP=1;
            columna =$random;
            #6 KeyP=0;
        end
        #10 $finish;
    end
    initial begin
        $dumpfile("Interfaz_tb.vcd");
        $dumpvars(0,Interfaz_tb);
    end
endmodule