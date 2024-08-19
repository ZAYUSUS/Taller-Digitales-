`timescale 1ns / 1ps


module ALUP#(parameter int unsigned WIDTH=4) (//WIDTH ancho de los buses 
  input  logic [WIDTH-1:0] ALUA,
  input  logic [WIDTH-1:0] ALUB,
  input  logic [3:0] ALUControl,
  input logic ALUFlagIn,
  output logic [WIDTH-1:0] ALUResult,
  output logic C,
  output logic Z
);
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
          ALUResult = (ALUA << ALUB) | (~((1 >> (WIDTH - ALUB)) - 1));//corre a la izquierda ALUB bits y los rellena con 1
        else ALUResult = ALUA<<ALUB;//corre a la izquierda y rellena con 0
      'h9: //corrimiento a la derecha de A
        if(ALUFlagIn)
          ALUResult = (ALUA >> ALUB) | (~((1 << (WIDTH - ALUB)) - 1));//mueve a la derecha y rellena con 1
        else ALUResult = ALUA >> ALUB;
        
      default: ALUResult = '0; 
    endcase
  end
  assign Z = ~((ALUResult!=0) ? 0 : 1);// es 1 si el ALUResult es 0
  assign C = ~((ALUControl=='h8) ? (WIDTH<ALUB ? 1 : ALUA[WIDTH-ALUB]):(ALUControl=='h9)? (WIDTH<ALUB ? 0 : ALUA[ALUB-1]) : 0);//toma el valor del ultimo digito desplazado por las funciones 'h8 y 'h9
  assign ALUResult = ~ALUResult;//NIega la salida para ser compatible con la FPGA
endmodule 