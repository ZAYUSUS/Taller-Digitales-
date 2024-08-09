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
// Description: Archivo con el código para probar el multiplexor de 8:1
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//se inicializan los registros para variables de entrada y de selección
// se declaran las variables de salida
module Testbench#(int unsigned WIDTH=16);
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    reg [WIDTH-1:0] c;
    reg [WIDTH-1:0] d;
    wire [WIDTH-1:0] out;
    reg [1:0] select;
    integer i;
    
    //Se crea el mux que se utilizará en las prubeas
    Multi4 mux0( .select(select),
     .a(a),
     .b(b),
     .c(c),
     .d(d),
     .out(out));
    
    initial begin 
    //Se inicia el selector en 0 y se otorgan valores aleatorios a los registros
        select <= 0;
        //cambia el valor de select luego de 5ns
        for( i=0;i<50;i=i+1)begin
             a <= $random;
             b <= $random;
             c <= $random;
             d <= $random;
            #5 select<= $random;
        end
    // se termina la simulación luego de hacer un barrido por las entradas del mux
        #5 $finish;    end
endmodule