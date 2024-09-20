`timescale 1ms / 1ns
module sincronizador (
  input  logic D0,//fila[0]
  input  logic D1,//fila[1]
  input  logic D2,//columna[0]
  input  logic D3,//columna[1]
  input  logic clk, //cada vez que exite KeyP
  input  logic rst, 
  output  logic [3:0]  Q
);

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      Q = 0;
    end else begin
      Q[0]=D0;
      Q[1]=D1;
      Q[2]=D2;
      Q[3]=D3;
    end
  end
endmodule
