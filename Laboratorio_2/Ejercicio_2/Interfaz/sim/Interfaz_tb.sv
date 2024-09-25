`timescale 1ns / 1ps

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
reg [3:0] Q1;

reg [31:0] ms = 1000000;

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
task bounce();
    #500 KeyP=1;
    #1000 KeyP=0;
    #200 KeyP=1;
    #2000 KeyP=0;
endtask //automatic
task wait_n_ms(int delay);
        #(delay*ms);
endtask
task random_delay();
    #(1000000*$urandom_range(10));
endtask
task prueba1();
    bounce();
    bounce();
    KeyP=1;
    wait_n_ms(4);
    KeyP=0;
    fila = $random;
    if(Q1=={fila[0],fila[1],columna[0],columna[1]})begin
        $display("PASS!! Q=%b Fila=%b Columna=%b",Q1,fila,columna);
    end else
        $display("ERROR!! Q=%b Fila=%b Columna=%b",Q1,fila,columna);
    
endtask

always begin #37 clk = ~clk;end // cada 37 ns o 27MHz
assign Q1 = ~Q;
initial begin
        clk=0;
        rst = 0;
        fila=2'b0;
        KeyP=0;
        prueba1();
        
        #10000 $finish;
    end
    initial begin
        $dumpfile("Interfaz_tb.vcd");
        $dumpvars(0,Interfaz_tb);
    end
endmodule