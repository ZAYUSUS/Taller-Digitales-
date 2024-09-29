`timescale 1ns / 1ps

module Interfaz_tb();
reg KeyP;
reg clk;
reg rst;
reg uart_rx;
wire uart_tx;
reg [1:0] fila = 0;
wire [3:0] Q;
wire [3:0] code;
wire [1:0] columna;
reg [3:0] Q1;
reg [3:0] Q_Aux;
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
assign Q1 = ~Q;
always begin #37 clk = ~clk;end // cada 37 ns o 27MHz
task bounce();
    #1000000 KeyP=1;
    #500000 KeyP=0;
    #250000 KeyP=1;
    #1000000 KeyP=0;
    #50000 KeyP=1;
    #250000 KeyP=0;
endtask //automatic
task wait_n_ms(int delay);
        #(delay*ms);
endtask
task random_delay();
    #(1000000*$urandom_range(10));
endtask

task juntarQ();
    Q_Aux[3] = fila[1];
    Q_Aux[2] = fila[0];
    Q_Aux[1:0] = columna; 
endtask

task prueba1();// prueba si el código obtenido es correcto
    for(int i=0;i<4;i++)begin
        fila= i;
        $display("Prueba con la fila %b",fila);
        bounce();
        KeyP=1;
        wait_n_ms(4);
        juntarQ(fila,columna);
        KeyP=0;
        if(Q1==Q_Aux)begin
        $display("PASS!! Q=%b Fila=%b Columna=%b Q_aux=%b",Q1,fila,columna,Q_Aux);
        end else
        $display("ERROR!! Q=%b Fila=%b Columna=%b Q_aux=%b",Q1,fila,columna,Q_Aux);
        wait_n_ms(2);
    end
endtask



initial begin
        clk=0;
        rst = 0;
        fila=2'b0;
        KeyP=0;
        wait_n_ms(10);
        prueba1();
        #10000 $finish;
    end
    initial begin
        $dumpfile("Interfaz_tb.vcd");
        $dumpvars(0,Interfaz_tb);
    end
endmodule
