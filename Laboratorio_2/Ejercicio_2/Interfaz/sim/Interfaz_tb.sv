`timescale 1ms / 1ns

module Interfaz_tb();
reg KeyP;
reg clk;
reg rst;
reg uart_rx;
wire uart_tx;
reg [1:0] fila;
wire [3:0] Q;
wire [3:0] code;
wire [1:0] columna;

Interfaz I0(
    .KeyP(KeyP),
    .rst(rst),
    .clk(clk),
    .fila(fila),
    .uart_rx(uart_rx),
    .columna(columna),
    .Q(Q),
    .code(code),
    .uart_tx(uart_tx)
);

    always begin #0.0000185 clk = ~clk;end

    initial begin
        clk=0;
        rst = 0;
        fila=2'b0;
        KeyP=0;
        $monitor("[%0t] Salida Q=%b Codigo=%h Presionada=%h Fila=%h Columna=%h uart_Tx=%b",$time,Q,code,KeyP,fila,columna,uart_tx);
        for (int i =0 ;i<10 ;i++ ) begin
            #3 KeyP=1;
            fila =$random;
            #6 KeyP=0;
        end
        #10 $finish;
    end
    initial begin
        $dumpfile("Interfaz_tb.vcd");
        $dumpvars(0,Interfaz_tb);
    end
endmodule