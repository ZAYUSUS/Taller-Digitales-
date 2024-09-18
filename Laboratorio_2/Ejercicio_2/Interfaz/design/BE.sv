`timescale 1ms / 100us


module KBE(// Bounce Elimination module
  input  logic KeyP,
  output logic Data_Available,
  output logic inhibit
);
always @(KeyP)begin
    #2 // Espera 2 ms
    if (KeyP) begin // si la tecla sigue presionada
      Data_Available = 1;
      inhibit =1;
    end else begin 
      Data_Available =0;
      inhibit =0;
    end
end


endmodule 