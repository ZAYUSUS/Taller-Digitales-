`timescale 1ns / 1ps

module main(
    input wire clk,       // Señal de reloj
    input wire rst,       // Señal de reset activo en bajo
    input wire pulsador,    // Señal de entrada del pulsador (asincrónica)
    output wire [7:0] leds // Salida del contador de 8 bits
);

    wire señalEstable;  // Señal estable sin rebotes del módulo antirrebote

    // Instancia del módulo AntiReboteSincronizado
    AntiReboteSincronizado u_AntiReboteSincronizado(
        .clk(clk),
        .rst(rst),
        .entradaAsincronica(pulsador),
        .salidaSincronizada(señalEstable)  // Salida estable sin rebotes
    );

    // Instancia del módulo ContadorPruebas
    ContadorPruebas u_ContadorPruebas(
        .clk(clk),
        .rst(rst),
        .EN(señalEstable),       // Habilitamos el contador solo cuando la señal de antirrebote está estable
        .contador(leds)      // Salida del contador
    );

endmodule