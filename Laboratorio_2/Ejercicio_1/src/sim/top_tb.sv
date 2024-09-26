`timescale 1ns / 1ps

module top_tb;

    // Declaración de señales para el testbench
    reg clk;                        // Señal de reloj
    reg rst;                        // Señal de reset
    reg pulsador;         // Señal de entrada (simulación de un pulsador con rebotes)
    wire [7:0] leds;       // Señal de salida filtrada, sin rebotes y sincronizada
    
    // Instancia del módulo bajo prueba (Unit Under Test - UUT)
    top uut(
        .clk(clk),
        .rst(rst),
        .pulsador(pulsador),
        .leds(leds)
    );

    // Generador de reloj: frecuencia de 27 MHz (periodo de ~37 ns)
    always #18.5 clk = ~clk;   // Alterna la señal de reloj cada 18.5 ns para simular una frecuencia de 27 MHz
    
    // Proceso inicial
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 1;
        pulsador = 0;

        // Esperamos unos ciclos antes de liberar el reset
        #100_000;
        rst = 0;  // Liberamos el reset

        // Simulación de rebotes en el botón
        // Los rebotes suceden dentro del marco de los primeros 2 ms (54,000 ciclos a 27 MHz)
        #200_000 pulsador = 1;  // Botón presionado (simulación de pulsación)
        #100_000 pulsador = 0;  // Rebote: cambia rápidamente a 0
        #200_000 pulsador = 1;  // Rebote: cambia rápidamente a 1
        #200_000 pulsador = 0;  // Rebote: vuelve a 0
        #100_000 pulsador = 1;  // Rebote: vuelve a 1
        #300_000 pulsador = 0;  // Rebote: vuelve a 0
        #200_000 pulsador = 1;  // Finalmente permanece en 1

        // Ahora esperamos 2 ms para que la señal sea considerada estable
        #2_000_000;

        // Soltamos el botón (cambia a 0)
        pulsador = 0;
        #500_000;

        // Simulamos otra secuencia de rebotes en el botón
        #100_000 pulsador = 1;  // Botón presionado nuevamente
        #100_000 pulsador = 0;  // Rebote: cambia rápidamente a 0
        #200_000 pulsador = 1;  // Rebote: cambia rápidamente a 1
        #200_000 pulsador = 0;  // Rebote: vuelve a 0
        #100_000 pulsador = 1;  // Rebote: vuelve a 1
        #200_000 pulsador = 0;  // Rebote: vuelve a 0
        #200_000 pulsador = 1;  // Finalmente permanece en 1

        // Esperamos 2 ms más para la señal estable
        #2_000_000;

        // Soltamos el botón de nuevo
        pulsador = 0;
        #500_000;

        // Finalizamos la simulación después de un tiempo adicional
        #10_000_000;
        $finish;
    end

    // Monitor de señales para ver los cambios en la simulación
    initial begin
        $monitor("Time=%t : pulsador=%b, leds=%b", $time, pulsador, leds);
    end

    initial begin
            $dumpfile("top_tb.vcd");
            $dumpvars(0,top_tb);
    end

endmodule
