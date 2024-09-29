`timescale 1ns / 1ps

module ContadorPruebas(
    input logic clk,       // Señal de reloj
    input logic rst,       // Señal de reset activo en bajo
    input logic EN,        // Señal habilitadora activa en alto
    output reg [5:0] contador // Contador de 8 bits
);
    reg anteriorEN; // Registro para almacenar el valor anterior de EN

    // Proceso síncrono
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Si rst es bajo (activo), reiniciamos el contador
            contador <= 8'b0;  // Contador a 0
            anteriorEN <= 1'b0;   // Reiniciamos el valor previo de EN
        end 
        else begin
            // Detectamos flanco positivo de EN
            if (EN && !anteriorEN) begin
                contador <= contador + 1;
            end
            // Actualizamos el valor anterior de EN
            anteriorEN <= EN;
        end
    end
endmodule
