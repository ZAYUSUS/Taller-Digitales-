`timescale 1ns / 1ps

module AntiReboteSincronizado(
    input wire clk,     // Reloj de la FPGA (frecuencia de 27 MHz)
    input wire rst,     // Señal de reset activo en bajo, que reinicia el módulo
    input wire entradaAsincronica,  // Señal de entrada del pulsador (asincrónica respecto al reloj)
    output reg salidaSincronizada  // Señal procesada sin rebotes y sincronizada
);

    // Declaración del contador y las señales internas
    reg [15:0] contadorEstabilida;     // Contador de 16 bits para verificar que la señal se mantiene estable durante un tiempo determinado
    reg salidaEstable;         // Señal filtrada, la cual representa la señal sin rebotes
    reg ff1, ff2;  // Registros (flip-flops) para sincronizar la señal después de eliminar los rebotes

    // Lógica de eliminación de rebotes (antirrebote)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Si el reset está activo (bajo), se reinicia el contador y la señal filtrada
            contadorEstabilida <= 0;          // Inicializa el contador a 0
            salidaEstable <= 0;       // Inicializa la señal sin rebotes a 0
        end 
        else begin
            // Si la señal de entrada cambia, reseteamos el contador
            if (entradaAsincronica != salidaEstable) begin
                contadorEstabilida <= 0;      // Reiniciamos el contador cuando la señal de entrada cambia
            end 
            else if (contadorEstabilida == 54000) begin
                /*
                Si la señal ha permanecido estable durante 54000 ciclos (aproximadamente 2 ms con un reloj de 27 MHz),
                actualizamos la señal estable para que sea igual a la señal de entrada.
                */
                salidaEstable <= entradaAsincronica;  // Actualizamos la señal estable después de eliminar los rebotes
            end 
            else begin
                contadorEstabilida <= contadorEstabilida + 1;  // Incrementamos el contador mientras la señal de entrada no cambia
            end
        end
    end

    // Lógica de sincronización de la señal (sincronización después del antirrebote)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Si el reset está activo (bajo), reiniciamos los flip-flops de sincronización
            ff1 <= 1'b0;     // Inicializamos el primer flip-flop de sincronización
            ff2 <= 1'b0;     // Inicializamos el segundo flip-flop de sincronización
            salidaSincronizada <= 1'b0;       // Inicializamos la salida a 0
        end 
        else begin
            // Sincronización de la señal sin rebotes (btn_stable)
            ff1 <= btn_stable;  // Capturamos la señal btn_stable en el primer flip-flop
            ff2 <= ff1;   // Pasamos la señal a un segundo flip-flop para sincronización completa
            // La salida btn_out es la señal completamente sincronizada con el reloj
            salidaSincronizada <= ff2;
        end
    end

endmodule