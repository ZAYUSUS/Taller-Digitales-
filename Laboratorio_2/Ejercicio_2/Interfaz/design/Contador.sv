`timescale 1ms / 1ns

module contador (
    input inhibit,
    input clk,
    output logic [1:0] out
);
reg [1:0] columna_generada=0;

assign out = inhibit ? columna_generada : 2'b00;
always @(posedge clk) begin
        columna_generada<= inhibit ? columna_generada+0 : columna_generada+1;
end
endmodule