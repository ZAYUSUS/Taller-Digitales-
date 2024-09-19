`timescale 1ms / 1ns

module AntiReboteSincronizado(
    input clk,  // Reloj de la FPGA (frecuencia de 27 MHz)
    input rst,  // Señal de reset activo en bajo, que reinicia el módulo
    input entradaAsincronica,  // Señal de entrada del pulsador (asincrónica respecto al reloj)
    output reg salidaSincronizada  // Señal procesada sin rebotes y sincronizada
);

    // Declaración del contador y las señales internas
    ///// reg [15:0] contadorEstabilidad = 0;  // Contador de 16 bits para verificar que la señal se mantiene estable durante un tiempo determinado
    reg salidaEstable;  // Señal filtrada, la cual representa la señal sin rebotes
    reg ff1;   // Registro (flip-flop) para sincronizar la señal después de eliminar los rebotes

    // Lógica de eliminación de rebotes (antirrebote)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Si el reset está activo (bajo), se reinicia la señal filtrada
            salidaEstable <= 0;  // Inicializa la señal a 0
        end 
    end

    always @(entradaAsincronica) begin
        #2
        if (entradaAsincronica == 1'b1) begin
            salidaEstable <= 1'b1;  // Señal estable se establece en 1, ya que ha sido presionado por 2 ms sin rebotes
        end 
        else
            salidaEstable <= 0;
    end

    // Lógica de sincronización de la señal (sincronización después del antirrebote)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Si reset es bajo (activo), reiniciamos los flip-flops de sincronización
            ff1 <= 1'b0;  // Inicializamos el flip-flop de sincronización
            salidaSincronizada <= 1'b0;  // Inicializamos la salida a 0
        end 
        else begin
            // Sincronización de la señal sin rebotes (salidaEstable)
            ff1 <= salidaEstable;  // Capturamos la señal salidaEstable en el primer flip-flop para la sincronización
            // La salida final es la señal completamente sincronizada con el reloj
            salidaSincronizada <= ff1;
        end
    end

endmodule