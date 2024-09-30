`timescale 1ms / 1ns
module sincronizador (
  input  logic D0,//fila[0]
  input  logic D1,//fila[1]
  input  logic D2,//columna[0]
  input  logic D3,//columna[1]
  input  logic data_Available, //cada vez que exite KeyP
  input  logic rst, 
  output  reg [3:0]  Q
);

assign Q = data_Available ?  4'b0000 : {D0,D1,D2,D3};

endmodule
