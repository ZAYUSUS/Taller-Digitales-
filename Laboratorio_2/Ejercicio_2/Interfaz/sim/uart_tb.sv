`timescale 1ns / 1ps

module uart_tb();


reg KeyP;
reg clk;
reg [3:0] Q;
reg uart_rx;
wire uart_tx;
reg [31:0] ms = 1000000;

Uart u0( 
    .clk(clk),
    .KeyP(KeyP),
    .Q(Q1),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx1)
);

always begin #37 clk = ~clk;end // cada 37 ns o 27MHz
task wait_n_ms(int delay);
        #(delay*ms);
endtask
task Generator();
    $display("Comenzando prueba uart....");
    $monitor("Estado rx: %b",uart_rx);
    for (int i=0;i<16;i++ ) begin
        Q = i;
        KeyP=1;
        uart_rx=uart_tx;//envia de nuevo el dato
        $display("Codigo recibido del teclado %b",Q);
        wait_n_ms(2);
        KeyP=0;
    end
endtask

initial begin
    Generator();
    #10000 $finish;
end

endmodule