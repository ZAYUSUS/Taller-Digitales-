`timescale 1ms / 100us

module Interfaz(
    input  logic KeyP,
    input  logic clk,
    input  logic rst,
    input  logic [1:0] columna,
    output logic [1:0] fila,
    output logic [3:0] Q,
    output logic [3:0] code
);
wire inhibit;
wire Data_Available;
wire [1:0] fila1;
wire [3:0] Q1;

KBE b0(
        .KeyP(KeyP),
        .Data_Available(Data_Available),
        .inhibit(inhibit)
);

contador c0(//2bit contador
    .inhibit(inhibit),
    .clk(clk),
    .out(fila1)
);
sincronizador s0(// sincronizador
    .D0(fila1[0]),
    .D1(fila1[1]),
    .D2(columna[0]),
    .D3(columna[1]),
    .clk(~Data_Available),
    .rst(rst),
    .Q(Q1)
);
//Codificador
always @(Q1 or fila1) begin
    Q <= Q1;
    fila <= fila1;
    case (Q)
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