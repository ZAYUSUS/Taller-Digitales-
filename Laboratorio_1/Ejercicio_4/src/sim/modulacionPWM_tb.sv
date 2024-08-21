`timescale 1ns / 1ps

module modulacionPWM_tb;

    // Señales de prueba
    logic Interruptor0, Interruptor1, Interruptor2, Interruptor3;
    logic clk;
    logic salidaPWM;

    // Instanciar el módulo bajo prueba
    modulacionPWM uut (
        .Interruptor0(Interruptor0),
        .Interruptor1(Interruptor1),
        .Interruptor2(Interruptor2),
        .Interruptor3(Interruptor3),
        .clk(clk),
        .salidaPWM(salidaPWM)
    );

    // Generar señal de reloj a 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;  // Genera un reloj con período de 37.04 ns (27 MHz)
    end

    // Inicializar señales y aplicar estímulos
    initial begin
        // Inicializar señales
        Interruptor0 = 0; 
        Interruptor1 = 0; 
        Interruptor2 = 0; 
        Interruptor3 = 0;

        // Esperar un tiempo para estabilización
        #10;

        // Aplicar diferentes combinaciones de interruptores
        // Prueba 1: Interruptor = 0000 (ancho de pulso = 0)
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 0;
        #200;  // Esperar suficiente tiempo para observar el comportamiento

        // Prueba 2: Interruptor = 0001 (ancho de pulso = 1/16 del período)
        Interruptor0 = 1; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 0;
        #200; 

        // Prueba 3: Interruptor = 0100 (ancho de pulso = 4/16 del período)
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 1; Interruptor3 = 0;
        #200; 

        // Prueba 4: Interruptor = 1000 (ancho de pulso = 8/16 del período)
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 1;
        #200; 

        // Prueba 5: sw = 1111 (ancho de pulso = 15/16 del período)
        Interruptor0 = 1; Interruptor1 = 1; Interruptor2 = 1; Interruptor3 = 1;
        #200; 

        $finish;
    end

    // Monitor para observar señales
    initial begin
        $monitor("Interruptor0 = %b, Interruptor1 = %b, Interruptor2 = %b, Interruptor3 = %b, PWM = %b", Interruptor0, Interruptor1, Interruptor2, Interruptor3, salidaPWM);
    end
    initial begin
        $dumpfile("modulacionPWM_tb.vcd");  // For waveform viewing
        $dumpvars(0,modulacionPWM_tb);
    end

endmodule