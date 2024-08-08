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
// Description: Archivo con el c�digo para probar el multiplexor de 8:1
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
module Testbench#(int unsigned WIDTH=4);
    reg [WIDTH:0] a;
    reg [WIDTH:0] b;
    reg [WIDTH:0] c;
    reg [WIDTH:0] d;
    reg [WIDTH:0] e;
    reg [WIDTH:0] f;
    reg [WIDTH:0] g;
    reg [WIDTH:0] h;
    wire [WIDTH:0] out;
    reg [WIDTH:0] select;
    integer i;
    
    //Se crea el mux que se utilizar� en las prubeas
    Multi4 mux0( .select(select),
     .a(a),
     .b(b),
     .c(c),
     .d(d),
     .out(out));
    
    initial begin 
    //Se inicia el selector en 0 y se otorgan valores aleatorios a los registros
        select <= 0;
        a <= $random;
        b <= $random;
        c <= $random;
        d <= $random;
        //cambia el valor de select luego de 5ns
        for( i=1;i<4;i=i+1)begin 
            #5 select<=i;
        end
    // se termina la simulaci�n luego de hacer un barrido por las entradas del mux
        #5 $finish;    end
endmodule