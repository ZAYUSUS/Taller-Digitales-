


module KBE(// Bounce Elimination module
  input logic clk,
  input  logic KeyP,
  output logic Data_Available,
  output logic inhibit
);

wire slow_clk_en;
wire Q1,Q2,Q2_bar,Q0;
clock_enable u1(clk,slow_clk_en);
my_dff_en d0(clk,slow_clk_en,KeyP,Q0);
my_dff_en d1(clk,slow_clk_en,Q0,Q1);
my_dff_en d2(clk,slow_clk_en,Q1,Q2);
assign Q2_bar = ~Q2;
assign Data_Available = ~(Q1 & Q2_bar);
assign inhibit = Q2_bar & Q1;
endmodule 
// Slow clock enable for debouncing button 
module clock_enable(input Clk_27M,output slow_clk_en);
    reg [15:0] counter=0;
    always @(posedge Clk_27M)
    begin
      counter <= (counter>=54000) ? 0: counter+1;
    end
    assign slow_clk_en = (counter == 54000) ? 1'b1:1'b0;
endmodule
// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
  if(clock_enable==1) 
        Q <= D;
    end
endmodule 