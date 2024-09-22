


module KBE(// Bounce Elimination module
  input logic clk,
  input  logic KeyP,
  output logic Data_Available,
  output logic inhibit
);
bit c=0;
bit veri=0;
reg [15:0] espera=0;

always @(posedge KeyP)begin
  if (~veri) begin
    c<=1;
    veri<=1;
  end
end

always @(posedge clk)begin //divisor de reloj
  if(c)begin
      if(espera>54000)begin//espera 2 ms
        if (KeyP) begin // si la tecla sigue presionada
        Data_Available <= 0;
        inhibit =1;
        end else begin 
          Data_Available <=1;
          inhibit =0;
        end
        espera<=0;
        c<=0;
        veri<=0;
        end
    else espera <= espera+1;
  end
end


endmodule 