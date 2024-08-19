`timescale 1ns / 1ps

module ComplementoA2 (
//Entradas:
    input  Interruptor0,
    input  Interruptor1,
    input  Interruptor2,
    input  Interruptor3,
//Salidas:
    output LED0,
    output LED1,
    output LED2,
    output LED3
);
//Se combinan los interruptores en un bus de 4 bits.
    wire [3:0] numBinario = {Interruptor3, Interruptor2, Interruptor1, Interruptor0};
//Se calcula el complemento a 2 del numero binario.
    wire [3:0] complemento2;
    assign complemento2 = ~numBinario + 4'b0001;
//Se asigna cada bit del resultado del complemento a 2 a las salidas de los LEDs.
    assign {LED3, LED2, LED1, LED0} = ~complemento2;

endmodule