`timescale 1ns / 1ps

module modulacionPWM (
    input Interruptor0,  // Interruptor para el bit menos significativo
    input Interruptor1,  // Interruptor para el segundo bit
    input Interruptor2,  // Interruptor para el tercer bit
    input Interruptor3,  // Interruptor para el bit más significativo
    input clk,           // Reloj del sistema
    output logic salidaPWM     // Salida PWM para controlar el LED
);

    // Contador para el ciclo de PWM
    reg [15:0] Contador = 0;           // Contador para el ciclo de PWM
    wire [3:0] numBinario;           // Código de 4 bits combinado
    reg [15:0] Comparador;     // Valor para comparación con el contador

    // Asignar la variable de código PWM combinando las entradas
    assign numBinario = {Interruptor3, Interruptor2, Interruptor1, Interruptor0}; // Combina las entradas de los interruptores

    // Calcular el valor de comparación basado en el código de 4 bits
    assign Comparador = numBinario * (27000 / 16); // Multiplica el código por el ancho de pulso
    // Contador del ciclo de PWM
    always @(posedge clk) begin
        Contador <= Contador + 1;
        if (Contador < Comparador)
            salidaPWM <= 1'b1;
        else
            salidaPWM <= 1'b0;
        //Reiniciar contador (1 milisegundo)
        if (Contador >= 27000)
            Contador <= 16'd0; //Contador=0
    end   
endmodule
