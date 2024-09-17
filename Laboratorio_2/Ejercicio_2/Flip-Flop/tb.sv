`timescale 1ns / 1ps
module tb(
);
  reg  D0;
  reg  D1;
  reg  D2; 
  reg  D3; 
  reg  clk; 
  reg  rst;
  wire [3:0]  Q;

sincronizador s0(.D0(D0),
.D1(D1),
.D2(D2),
.D3(D3),
.clk(clk),
.rst(rst),
.Q(Q));

always 
  #1 clk = ~clk;
  
  initial begin
  clk = 0; 
  rst = 0;
  D0 = 0; 
  D1 = 0;
  D2 = 0; 
  D3 = 0;

for(int i=0;i<10;i++) begin
    #5 D0= $random;
       D1 = $random;
       D2 = $random;
       D3 = $random;
end
  
    #10 $finish;
  end

endmodule