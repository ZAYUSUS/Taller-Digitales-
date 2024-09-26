`timescale 1ns / 1ps

module AntiReboteSincronizado(
    input logic clk,  // Reloj de la FPGA (frecuencia de 27 MHz)
    input logic rst,  // Señal de reset activo en bajo, que reinicia el módulo
    input logic entradaAsincronica,  // Señal de entrada del pulsador (asincrónica respecto al reloj)
    output reg salidaSincronizada  // Señal procesada sin rebotes y sincronizada
);

    // Parámetro para contar 2 ms a 27 MHz
    localparam int CICLO_2MS = 54000;  // 2 ms * 27 MHz = 54000 ciclos de reloj

    // Declaración del contador y las señales internas
    reg [15:0] contadorEstabilidad;  // Contador para los 2 ms de estabilidad
    reg salidaEstable;  // Señal filtrada, la cual representa la señal sin rebotes
    reg ff1;  // Registro (flip-flop) para sincronizar la señal después de eliminar los rebotes

    // Lógica de eliminación de rebotes (antirrebote)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Si el reset está activo (bajo), reinicia las señales
            salidaEstable <= 1'b0;  // Inicializa la señal estable a 0
            contadorEstabilidad <= 16'b0;  // Reinicia el contador
        end 
        else begin
            if (entradaAsincronica == 1'b1) begin
                // Si la entrada asincrónica es 1, comenzamos a contar
                if (contadorEstabilidad == CICLO_2MS) begin
                    salidaEstable <= 1'b1;  // Después de 2 ms, establecemos la señal estable
                end 
                else
                    contadorEstabilidad <= contadorEstabilidad + 1;  // Incrementa el contador
            end 
            else begin
                // Si la entrada asincrónica y el contador son 0, la señal estable se hace 0
                if (contadorEstabilidad == 16'b0 || contadorEstabilidad == CICLO_2MS) begin
                salidaEstable <= 1'b0;  // Inicializa la salida estable a 0
                contadorEstabilidad <= 16'b0;  // Inicializa el contador a 0
                end
                else
                    contadorEstabilidad <= contadorEstabilidad + 1;  // Incrementa el contador
            end
        end
    end

    // Lógica de sincronización de la señal (sincronización después del antirrebote)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Si reset es activo, reiniciamos los flip-flops de sincronización
            ff1 <= 1'b0;  // Reinicia el flip-flop
            salidaSincronizada <= 1'b0;  // Inicializa la salida a 0
        end 
        else begin
            // Sincronización de la señal sin rebotes (salidaEstable)
            ff1 <= salidaEstable;  // Capturamos la señal salidaEstable en el primer flip-flop para sincronización
            salidaSincronizada <= ff1;  // La salida final es la señal completamente sincronizada
        end
    end

endmodule
