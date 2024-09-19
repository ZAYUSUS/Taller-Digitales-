`timescale 1ms / 1ns

module ContadorPruebas(
    input  clk,       // Señal de reloj
    input  rst,       // Señal de reset activo en bajo
    input  EN,        // Señal habilitadora activa en alto
    output reg [7:0] contador // Contador de 8 bits
);
    reg anteriorEN; // Registro para almacenar el valor anterior de EN

    // Proceso síncrono
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
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