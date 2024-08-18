`timescale 1ns / 1ps


module ALUP#(parameter int unsigned WIDTH=4) (//WIDTH ancho de los buses 
  input  logic [WIDTH-1:0] ALUA,
  input  logic [WIDTH-1:0] ALUB,
  input  int unsigned ALUControl,
  input logic ALUFlagIn,
  output logic [WIDTH-1:0] ALUResult,
  output logic C,
  output logic Z
);
int B=15;
always_comb begin
    //and 
    //or 
    //suma
    //incremento en 1
    //decremento en 1
    //resta
    //xor
    //corrimiento izquierda
    //corrimiento derecha
    case (ALUControl)
      'h0:             ALUResult = ALUA & ALUB;//and
      'h1:             ALUResult = ALUA | ALUB;//or
      'h2:             ALUResult = (~ALUA+1) + (~ALUB+1);//suma complemento a 2
      'h3: if(ALUFlagIn) ALUResult = ALUB+1;else ALUResult = ALUA+1;//incremento en 1//SI es 0 elije B, si es 1 elije A
      'h4: if(ALUFlagIn) ALUResult = ALUB-1;else ALUResult = ALUA-1;//decremento en 1
      'h5: if(ALUFlagIn)ALUResult = !ALUB;else ALUResult = !ALUA;//not 
      'h6:             ALUResult = (~ALUA+1) - (~ALUB+1);//resta complemento a 2
      'h7:             ALUResult = ALUA ^ ALUB;//Xor
      'h8: if(ALUFlagIn)//corrimiento a la izqueirda de A
          ALUResult = (ALUA << ALUB) + ((2^ALUB)-1);
        else ALUResult = ALUA<<ALUB;
      'h9: //corrimiento a la derecha de A
        if(ALUFlagIn)begin
          B = ALUB;
          for(int i=0;i< B;i++) ALUResult = (ALUA >> 1) + ((2^ALUB)-1);end
          //C = (WIDTH<ALUB) ? 1 : ALUA[ALUB-1];end//Ultimo digito en moverse
        else ALUResult = ALUA >> ALUB;
      default: ALUResult = '0; 
    endcase
  end
  assign Z = (ALUResult!=0) ? 0 : 1;
  assign C = (ALUControl=='h8) ? (WIDTH<ALUB ? 1 : ALUA[WIDTH-ALUB]):(WIDTH<ALUB ? 0 : ALUA[ALUB-1]);

endmodule 