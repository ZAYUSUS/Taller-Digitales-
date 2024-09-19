`timescale 1ms / 1ns

module top_tb();

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

    // Generador de reloj: frecuencia de 27 MHz (periodo de 37 ns)
    always #0.0000185 clk = ~clk;   // Alterna la señal de reloj cada 18.5 ns para simular una frecuencia de 27 MHz

    // Proceso inicial
    initial begin
        $monitor("Time=%t : pulsador=%b, leds=%b", $time, pulsador, leds);
        // Inicialización de señales
        clk = 0;
        rst = 0;
        pulsador = 0;

        // Esperamos unos ciclos antes de liberar el reset
        #10;
        rst = 1;  // Liberamos el reset

        // Simulación de rebotes en el botón
        // Los rebotes suceden dentro del marco de los primeros 2 ms (54,000 ciclos)
        #0.2 pulsador = 1;  // Botón presionado (simulación de pulsación)
        #0.1 pulsador = 0;  // Rebote: cambia rápidamente a 0
        #0.2 pulsador = 1;  // Rebote: cambia rápidamente a 1
        #0.2 pulsador = 0;  // Rebote: vuelve a 0
        #0.1 pulsador = 1;  // Rebote: vuelve a 1
        #0.3 pulsador = 0;  // Rebote: vuelve a 0
        #0.2 pulsador = 1;  // Finalmente permanece en 1
        // Ahora esperamos 1 ms más para completar un total de 2 ms
        #1;

        // Soltamos el botón (cambia a 0)
        pulsador = 0;
        #5
        #0.1 pulsador = 1;  // Botón presionado (simulación de pulsación)
        #0.1 pulsador = 0;  // Rebote: cambia rápidamente a 0
        #0.2 pulsador = 1;  // Rebote: cambia rápidamente a 1
        #0.2 pulsador = 0;  // Rebote: vuelve a 0
        #0.1 pulsador = 1;  // Rebote: vuelve a 1
        #0.2 pulsador = 0;  // Rebote: vuelve a 0
        #0.2 pulsador = 1;  // Finalmente permanece en 1
        // Ahora esperamos 1 ms más para completar un total de 2 ms
        #1;

        // Soltamos el botón (cambia a 0)
        pulsador = 0;
        #5
        // Finalizamos la simulación después de un tiempo adicional
        #10;
        $finish;
    end



    initial begin
            $dumpfile("top_tb.vcd");
            $dumpvars(0,top_tb);
    end

endmodule