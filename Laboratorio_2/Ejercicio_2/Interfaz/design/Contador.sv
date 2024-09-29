`timescale 1ms / 1ns

module contador (
    input inhibit,
    input clk,
    output reg [1:0] out
);
reg [1:0] c=0;
always @(posedge clk) begin
    if(inhibit) begin 
        out <= c;
    end//si se escanea un match se apaga el contador
    else begin
        out <=0;
        c <= c+1;// se el escaneo encuentra una tecla
    end
end
endmodule