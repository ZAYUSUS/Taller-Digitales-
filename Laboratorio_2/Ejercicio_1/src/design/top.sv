`timescale 1ms / 1ns

module top(
    input clk,       // Señal de reloj
    input rst,       // Señal de reset activo en bajo
    input pulsador,    // Señal de entrada del pulsador (asincrónica)
    output [7:0] leds // Salida del contador de 8 bits
);

    wire salidaEstable;  // Señal estable sin rebotes del módulo antirrebote
    wire [7:0] contador; // Salida del contador original
    
    // Instancia del módulo AntiReboteSincronizado
    AntiReboteSincronizado u_AntiReboteSincronizado(
        .clk(clk),
        .rst(rst),
        .entradaAsincronica(pulsador),
        .salidaSincronizada(salidaEstable)  // Salida estable sin rebotes
    );

    // Instancia del módulo ContadorPruebas
    ContadorPruebas u_ContadorPruebas(
        .clk(clk),
        .rst(rst),
        .EN(salidaEstable),       // Habilitamos el contador solo cuando la señal de antirrebote está estable
        .contador(contador)   // Salida del contador
    );
    // Invertir la salida del contador para los LEDs
    assign leds = ~contador;
endmodule