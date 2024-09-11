`timescale 1ms / 100us


module KBE(// Bounce Elimination module
  input  logic KeyP,
  output logic Data_Available,
  output logic Inhibit
);

always @(KeyP)begin
    #20 // Espera 20 ms
    if (KeyP) begin // si la tecla sigue presionada
      Data_Available = 1;
      Inhibit =1;
    end else begin 
      Data_Available =0;
      Inhibit =0;
    end
end


endmodule 