`timescale 1ns / 1ps

module top(
    input logic clk,       // Señal de reloj
    input logic rst,       // Señal de reset activo en bajo
    input logic pulsador,    // Señal de entrada del pulsador (asincrónica)
    output [5:0] leds // Salida del contador de 8 bits
);

    wire salidaEstable;  // Señal estable sin rebotes del módulo antirrebote
    wire [5:0] contador; // Salida del contador original
    
    // Instancia del módulo AntiReboteSincronizado
    AntiReboteSincronizado u_AntiReboteSincronizado(
        .clk(clk),
        .rst(~rst),
        .entradaAsincronica(pulsador),
        .salidaSincronizada(salidaEstable)  // Salida estable sin rebotes
    );

    // Instancia del módulo ContadorPruebas
    ContadorPruebas u_ContadorPruebas(
        .clk(clk),
        .rst(~rst),
        .EN(salidaEstable),       // Habilitamos el contador solo cuando la señal de antirrebote está estable
        .contador(contador)   // Salida del contador
    );
    // Invertir la salida del contador para los LEDs
    assign leds = ~contador;
endmodule
