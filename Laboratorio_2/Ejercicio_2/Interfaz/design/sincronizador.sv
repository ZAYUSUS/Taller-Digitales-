`timescale 1ms / 10ns
module sincronizador (
  input  D0,//fila[0]
  input  D1,//fila[1]
  input  D2,//columna[0]
  input  D3,//columna[1]
  input  clk, //cada vez que exite KeyP
  input  rst, 
  output  logic [3:0]  Q
);

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      Q = 0;
    end else begin
      Q[0]=1;
      Q[1]=1;
      Q[2]=0;
      Q[3]=1;
    end
  end
endmodule
