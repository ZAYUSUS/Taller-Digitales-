`timescale 1ns / 1ps

module AntiReboteSincronizado_tb;

    // Declaración de señales para el testbench
    reg clk;                       // Señal de reloj
    reg rst;                       // Señal de reset
    reg entradaAsincronica;        // Señal de entrada (simulación de un pulsador con rebotes)
    wire salidaSincronizada;       // Señal procesada, sin rebotes y sincronizada

    // Instancia del módulo bajo prueba (Unit Under Test - UUT)
    AntiReboteSincronizado uut (
        .clk(clk),
        .rst(rst),
        .entradaAsincronica(entradaAsincronica),
        .salidaSincronizada(salidaSincronizada)
    );

    // Generador de reloj: frecuencia de 27 MHz (periodo de aproximadamente 37 ns)
    always #18.5 clk = ~clk;   // Alterna la señal de reloj cada 18.5 ns para generar una frecuencia de 27 MHz

    // Proceso inicial
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 0;
        entradaAsincronica = 0;

        // Esperamos unos ciclos antes de liberar el reset
        #100;
        rst = 1;  // Liberamos el reset

        // Simulación de rebotes
        // Pulsación con rebotes (señal de entrada cambia rápidamente)
        #50 entradaAsincronica = 1;  // Cambia a 1 (simulación de pulsación)
        #10 entradaAsincronica = 0;  // Rebote: vuelve a 0
        #20 entradaAsincronica = 1;  // Rebote: vuelve a 1
        #5  entradaAsincronica = 0;  // Rebote: cambia a 0
        #10 entradaAsincronica = 1;  // Rebote final: cambia a 1 y permanece

        // Mantener la señal estable durante un periodo suficiente para eliminar los rebotes
        #100000;  // Mantener estable durante 2 ms

        // Simulación de una nueva pulsación después de eliminar los rebotes
        #50 entradaAsincronica = 0;
        #100000 entradaAsincronica = 1;  // Otra pulsación estable durante 2 ms

        // Finalizamos la simulación
        #500;
        $stop;
    end

    // Monitor de señales para ver los cambios en la simulación
    initial begin
        $monitor("Time=%t : entradaAsincronica=%b, salidaSincronizada=%b", $time, entradaAsincronica, salidaSincronizada);
    end

    initial begin
        $dumpfile("AntiReboteSincronizado_tb.vcd");
        $dumpvars(0,AntiReboteSincronizado_tb);
    end
endmodule
