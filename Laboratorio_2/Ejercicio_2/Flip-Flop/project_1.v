`timescale 1ns / 1ps
module sincronizador (
  input  D0,
  input  D1,
  input  D2, 
  input  D3, 
  input  clk, 
  input  rst, 
  output logic [3:0]  Q
);
  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      Q = 0;
    end else begin
      Q = {D0,D1,D2,D3};
    end
  end
endmodule
