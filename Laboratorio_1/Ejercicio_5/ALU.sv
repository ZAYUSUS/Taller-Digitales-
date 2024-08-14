`timescale 1ns / 1ps


module ALU#(int unsigned WIDTH=4) (//WIDTH ancho de los buses 
  input  logic [WIDTH-1:0] ALUA,
  input  logic [WIDTH-1:0] ALUB,
  input  int unsigned ALUControl,
  input logic ALUFlagIn,
  output logic [WIDTH-1:0] ALUResult,
  output logic ALUFlags
);
always_comb begin
    case (ALUControl)
      'h0:             ALUResult = ALUA & ALUB;//and
      'h1:             ALUResult = ALUA | ALUB;//or
      'h2:             ALUResult = ALUA + ALUB;//suma
      'h3:if(ALUFlagIn) ALUResult = ALUB+1;else ALUResult = ALUA+1; //incremento en 1//SI es 0 elije B, si es 1 elije A
      'h4:if(ALUFlagIn) ALUResult = ALUB-1;else ALUResult = ALUA-1;//decremento en 1
      'h5:if(ALUFlagIn)ALUResult = !ALUB;else ALUResult = !ALUA;//not 
      'h6:             ALUResult = ALUA - ALUB;//resta
      'h7:             ALUResult = ALUA ^ ALUB;//Xor
      'h8: if(ALUFlagIn) for(int i=0;i<ALUB;i++) ALUResult = (ALUA << 1) | 1;else ALUResult = ALUA<<ALUB;//corrimiento a la izqueirda de A
      'h9: if(ALUFlagIn)for(int i=0;i<ALUB;i++) ALUResult = (ALUA >> 1) | 1; else ALUResult = ALUA >> ALUB;//corrimiento a la derecha de A
      default:         ALUResult = '0; 
    endcase
  end
  
endmodule 