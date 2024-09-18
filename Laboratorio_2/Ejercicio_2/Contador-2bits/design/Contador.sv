`timescale 1ms / 100us

module contador (
    input inhibit,
    input clk,
    output logic [1:0] out
);

    always @(posedge clk) begin
        if (!inhibit) begin //si se presiona una tecla
            out <= 0;
        end else
                out <= out+1;
    end

endmodule