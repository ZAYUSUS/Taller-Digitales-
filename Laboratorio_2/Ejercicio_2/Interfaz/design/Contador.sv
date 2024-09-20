`timescale 1ms / 1ns

module contador (
    input inhibit,
    input clk,
    output logic [1:0] out
);

    always @(posedge clk) begin
        if (!inhibit) begin //si se presiona una tecla
            out <= out+1'b1;
        end else
            out <= 0;
    end
endmodule