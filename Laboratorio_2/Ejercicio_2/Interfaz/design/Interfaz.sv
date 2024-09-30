

module Interfaz(
    input  logic KeyP,
    input  logic rst,
    input logic clk,
    input logic [1:0] fila,
    input logic uart_rx,
    output  logic [1:0] columna,
    output logic [3:0] Q,
    output logic [3:0] code,
    output logic uart_tx,
    output logic [3:0] leds
);

reg  inhibit;
reg  Data_Available;
reg  clk1 ;
reg [16:0] espera=0;

wire uart_tx1;
wire Data_aux;
wire inhibit_aux;
wire [3:0] leds_aux;
wire [1:0] columna_aux;
wire [3:0] Q1;

always @(posedge clk)begin //divisor de reloj
    espera <= (espera>=67500) ? 0 : espera+1;
end
assign clk1 = (espera==67500) ? 1 : 0;//cambia cada 2,5ms
assign Data_Available = Data_aux;
assign inhibit = inhibit_aux;
assign  columna = columna_aux;
assign Q = ~Q1 ;
assign uart_tx = uart_tx1;
assign leds = leds_aux;
KBE b0(
        .clk(clk),
        .KeyP(KeyP),
        .Data_Available(Data_aux),
        .inhibit(inhibit_aux)
);

contador c0(//2bit contador
    .inhibit(inhibit),
    .clk(clk1),
    .out(columna_aux)
);
sincronizador s0(// sincronizador
    .D0(fila[1]),
    .D1(fila[0]),
    .D2(columna[0]),
    .D3(columna[1]),
    .data_Available(Data_Available),
    .rst(rst),
    .Q(Q1)
);
Uart uart( 
    .clk(clk),
    .KeyP(~Data_Available),
    .Q(Q1),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx1),
    .leds(leds_aux)
    );
//Codificador
always @(Q1) begin
    case (Q1)
        4'b0000: code <= 4'h1;
        4'b0001: code <= 4'h2;
        4'b0010: code <= 4'h3;
        4'b0011: code <= 4'hA;
        4'b0100: code <= 4'h4;
        4'b0101: code <= 4'h5;
        4'b0110: code <= 4'h6;
        4'b0111: code <= 4'hB;
        4'b1000: code <= 4'h7;
        4'b1001: code <= 4'h8;
        4'b1010: code <= 4'h9;
        4'b1011: code <= 4'hC;
        4'b1100: code <= 4'hF;
        4'b1101: code <= 4'h0;
        4'b1110: code <= 4'hE;
        4'b1111: code <= 4'hD;
        default: code <= 4'h0;
    endcase
end



endmodule

