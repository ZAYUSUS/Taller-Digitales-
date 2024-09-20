


module KBE(// Bounce Elimination module
  input logic clk,
  input  logic KeyP,
  output logic Data_Available,
  output logic inhibit
);
reg c=0;
reg [15:0] espera=0;
always @(posedge clk)begin //divisor de reloj
  if(KeyP)begin
    c<=1;
  end
  if(c)begin
      if(espera>27000)begin
        espera<=0;
        if (KeyP) begin // si la tecla sigue presionada
        Data_Available <= 0;
        inhibit <=0;
        end else begin 
          Data_Available <=1;
          inhibit <=1;
        end
        c<=0;
        end
    else espera <= espera+1;
  end
end


endmodule 