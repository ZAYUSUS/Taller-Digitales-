module Uart (
    input logic clk,
    input logic KeyP,
    input logic [3:0] Q,
    input uart_rx,
    output uart_tx,
    output logic [3:0] leds
);

localparam DELAY_FRAMES = 2813;// 27,000,000 (27Mhz) / 9600 Baud rate
localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);
//----------------parte que recibe ----- //
reg [3:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [7:0] dataIn = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 5;

always @(posedge clk) begin
    case (rxState)
        RX_STATE_IDLE: begin
            if (uart_rx == 0) begin
                rxState <= RX_STATE_START_BIT;
                rxCounter <= 1;
                rxBitNumber <= 0;
                byteReady <= 0;
            end
        end 
        RX_STATE_START_BIT: begin
            if (rxCounter == HALF_DELAY_WAIT) begin
                rxState <= RX_STATE_READ_WAIT;
                rxCounter <= 1;
            end else 
                rxCounter <= rxCounter + 1;
        end
        RX_STATE_READ_WAIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_READ;
            end
        end
        RX_STATE_READ: begin
            rxCounter <= 1;
            dataIn <= {uart_rx, dataIn[7:1]};
            rxBitNumber <= rxBitNumber + 1;
            if (rxBitNumber == 3'b111)
                rxState <= RX_STATE_STOP_BIT;
            else
                rxState <= RX_STATE_READ_WAIT;
        end
        RX_STATE_STOP_BIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_IDLE;
                rxCounter <= 0;
                byteReady <= 1;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (byteReady) begin
        leds <= ~dataIn[3:0];
    end
end



//--------------------Parte que envia----------------//
reg [3:0] txState = 0;// estado actual
reg [24:0] txCounter = 0;// ciclos de reloj
reg [7:0] dataOut = 0;// byte que se envía
reg txPinRegister = 1;// valor a adjuntar en uart_tx
reg [2:0] txBitNumber = 0;// bit enviando
reg [3:0] txByteCounter = 0;

assign uart_tx = txPinRegister;

// parte a cambiar
localparam MEMORY_LENGTH = 1;
reg [7:0] code_uart ;
/*
initial begin
    code_uart[0] = "Hola";
end
*/

always @(KeyP) begin
    case (Q)
        4'b0000: code_uart <= 4'h1;
        4'b0001: code_uart <= 4'h2;
        4'b0010: code_uart <= 4'h3;
        4'b0011: code_uart <= 4'hA;
        4'b0100: code_uart <= 4'h4;
        4'b0101: code_uart <= 4'h5;
        4'b0110: code_uart <= 4'h6;
        4'b0111: code_uart <= 4'hB;
        4'b1000: code_uart <= 4'h7;
        4'b1001: code_uart <= 4'h8;
        4'b1010: code_uart <= 4'h9;
        4'b1011: code_uart <= 4'hC;
        4'b1100: code_uart <= 4'hF;
        4'b1101: code_uart <= 4'h0;
        4'b1110: code_uart <= 4'hE;
        4'b1111: code_uart <= 4'hD;
        default: code_uart <= 4'h0;
    endcase
end
/*
always @(KeyP) begin
    case (Q)
        4'b0000: code_uart <= "1";
        4'b0001: code_uart <= "2";
        4'b0010: code_uart <= "3";
        4'b0011: code_uart <= "A";
        4'b0100: code_uart <= "4";
        4'b0101: code_uart <= "5";
        4'b0110: code_uart <= "6";
        4'b0111: code_uart <= "B";
        4'b1000: code_uart <= "7";
        4'b1001: code_uart <= "8";
        4'b1010: code_uart <= "9";
        4'b1011: code_uart <= "C";
        4'b1100: code_uart <= "*";
        4'b1101: code_uart <= "0";
        4'b1110: code_uart <= "#";
        4'b1111: code_uart <= "D";
        default: code_uart <= "0";
    endcase
end
*/
//localparam MEMORY_LENGTH = 2;

localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_DEBOUNCE = 4;
always @(posedge clk)begin
    case (txState)
        
        TX_STATE_IDLE: begin
            
            if (KeyP == 1) begin //cuando se presiona una tecla
                txState <= TX_STATE_START_BIT;
                //$display("Cambiando a estado %d",txState+1);
                txCounter <= 0;
            end
            else begin
                txPinRegister <= 1;
            end
        end 
        TX_STATE_START_BIT: begin
            txPinRegister <= 0;
            if ((txCounter + 1) == DELAY_FRAMES) begin //espera 312us 
                //$display("Cambiando a estado %d",txState+1);
                txState <= TX_STATE_WRITE;
                dataOut <= code_uart[txByteCounter];// guardo el caracter
                txBitNumber <= 0;
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_WRITE: begin
            txPinRegister <= dataOut[txBitNumber];// envia el bit
            if ((txCounter + 1) == DELAY_FRAMES) begin//espera 312us 
                if (txBitNumber == 3'b111) begin // cuenta hasta 8bits
                    txState <= TX_STATE_STOP_BIT;
                    //$display("Cambiando a estado %d",txState+1);
                end else begin
                    txState <= TX_STATE_WRITE;
                    txBitNumber <= txBitNumber + 1;
                end
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_STOP_BIT: begin
            txPinRegister <= 1;
            if ((txCounter + 1) == DELAY_FRAMES) begin// espera 312us 
                if (txByteCounter == MEMORY_LENGTH - 1) begin
                    //$display("Cambiando a estado %d",txState+1);
                    txState <= TX_STATE_DEBOUNCE;
                end else begin
                    txByteCounter <= txByteCounter + 1;
                    txState <= TX_STATE_START_BIT;
                end
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
            TX_STATE_DEBOUNCE: begin
            if (txCounter == 23'b111111111111111111) begin //espera 262143 ciclos es 9,71 ms
                if (KeyP == 0) 
                    //$display("Cambiando a estado %d",txState+1);
                    txState <= TX_STATE_IDLE;
            end else
                txCounter <= txCounter + 1;
        end
    endcase
end
endmodule