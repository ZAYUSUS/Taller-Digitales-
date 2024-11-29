module Uart (
    input logic clk,
    input logic KeyP,
    
    input uart_rx,
    output uart_tx,
    output logic [7:0] data_out
);

localparam DELAY_FRAMES = 868;// 100Mhz / 115200 bauds
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
        data_out <= dataIn;
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
reg [7:0] code_uart = 2'b10 ;
/*
initial begin
    code_uart[0] = "Hola";
end
*/

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
