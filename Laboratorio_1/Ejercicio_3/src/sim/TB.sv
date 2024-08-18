`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TEC Costa Rica
// Engineer: Bryan Esquivel Flores
// 
// Create Date: 05/06/2024 07:20:26 PM
// Design Name: 
// Module Name: Testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Archivo con el c�digo para probar el multiplexor de 4:1
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//se inicializan los registros para variables de entrada y de selecci�n
// se declaran las variables de salida
module Testbench#(parameter int unsigned WIDTH=4);//WIDTH:tamaño de los buses
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    reg [WIDTH-1:0] C;
    reg [WIDTH-1:0] D;
    wire [WIDTH-1:0] Y;
    reg [1:0] S;
    integer i;
    
    //Se crea el mux que se utilizar� en las prubeas
    Multi4 mux0( .S(S),
    .A(A),
    .B(B),
    .C(D),
    .D(D),
    .Y(Y));
    
    initial begin 
    //Se inicia el selector en 0 y se otorgan valores aleatorios a los registros
        S <= 0;
        //cambia el valor de select luego de 5ns
        for( i=0;i<50;i=i+1)begin
            A <= $random;
            B <= $random;
            C <= $random;
            D <= $random;
            #5 S<= $random;
        end
    // se termina la simulaci�n luego de hacer un barrido por las entradas del mux
        #5 $finish;    end
    initial begin
        $dumpfile("Testbench.vcd");
        $dumpvars(0,Testbench);
    end

endmodule