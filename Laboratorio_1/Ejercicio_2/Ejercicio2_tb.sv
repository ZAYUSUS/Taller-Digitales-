`timescale 1ns / 1ps

module Ejercicio2_tb;
    // Declaración de señales
    reg  Interruptor0, Interruptor1, Interruptor2, Interruptor3; // Entradas de 1 bit
    wire LED0, LED1, LED2, LED3; // Salidas de 1 bit

    // Instanciación del módulo a probar
    Ejercicio2 uut (
        .Interruptor0(Interruptor0),
        .Interruptor1(Interruptor1),
        .Interruptor2(Interruptor2),
        .Interruptor3(Interruptor3),
        .LED0(LED0),
        .LED1(LED1),
        .LED2(LED2),
        .LED3(LED3)
    );

    // Bloque de pruebas
    initial begin
        // Inicialización y pruebas
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 0; #10; // Prueba: 0000
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 0; #10; // Prueba: 0001
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 1; Interruptor2 = 0; Interruptor3 = 0; #10; // Prueba: 0010
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 1; Interruptor2 = 0; Interruptor3 = 0; #10; // Prueba: 0011
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 1; Interruptor3 = 0; #10; // Prueba: 0100
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 0; Interruptor2 = 1; Interruptor3 = 0; #10; // Prueba: 0101
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 1; Interruptor2 = 1; Interruptor3 = 0; #10; // Prueba: 0110
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 1; Interruptor2 = 1; Interruptor3 = 0; #10; // Prueba: 0111
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 1; #10; // Prueba: 1000
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 0; Interruptor2 = 0; Interruptor3 = 1; #10; // Prueba: 1001
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 1; Interruptor2 = 0; Interruptor3 = 1; #10; // Prueba: 1010
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 1; Interruptor2 = 0; Interruptor3 = 1; #10; // Prueba: 1011
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 0; Interruptor2 = 1; Interruptor3 = 1; #10; // Prueba: 1100
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 0; Interruptor2 = 1; Interruptor3 = 1; #10; // Prueba: 1101
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 0; Interruptor1 = 1; Interruptor2 = 1; Interruptor3 = 1; #10; // Prueba: 1110
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        Interruptor0 = 1; Interruptor1 = 1; Interruptor2 = 1; Interruptor3 = 1; #10; // Prueba: 1111
        $display("Binario = %b%b%b%b, Complemento a 2 = %b%b%b%b", Interruptor3, Interruptor2, Interruptor1, Interruptor0, LED3, LED2, LED1, LED0);
        
        $finish; // Finalizar la simulación
    end

endmodule