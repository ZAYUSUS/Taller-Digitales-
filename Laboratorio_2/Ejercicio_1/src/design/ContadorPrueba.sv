`timescale 1ns / 1ps

module ContadorPruebas(
    input wire clk,       // Señal de reloj
    input wire rst,       // Señal de reset activo en bajo
    input wire EN,        // Señal habilitadora activa en alto
    output reg [7:0] contador // Contador de 8 bits
);

    // Proceso síncrono
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Si rst es bajo (reset activo), reiniciamos el contador
            contador <= 8'b0;  // Contador a 0
        end else if (EN) begin
            // Si EN está alto, incrementamos el contador en cada flanco positivo del reloj
            contador <= contador + 1;
        end
    end

endmodule