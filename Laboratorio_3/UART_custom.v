

module UART_custom(
	input clk,
	output ser_tx,
	input  ser_rx,
	
	output [31:0] uart_c,
	output        uart_r_ready,
	
    input         reg_dat_we,
	input         reg_dat_re,
	input  [31:0] reg_dat_di,
	output [31:0] reg_dat_do,
	output        reg_dat_wait
);

localparam DELAY_FRAMES = 10;// 100Mhz / 115200 bauds
localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);
//----------------parte que recibe ----- //
reg [3:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [7:0] dataIn = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;
reg sending = 0;

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 5;

assign reg_dat_wait = reg_dat_we && sending;
assign reg_dat_do = (byteReady && reg_dat_re) ? dataIn : 32'h0000_0000;// data received goes to do
assign uart_r_ready = byteReady ? 1 : 0;

always @(posedge clk) begin
    case (rxState)
        RX_STATE_IDLE: begin
            byteReady<=1;
            dataIn<=0;
            if (ser_rx == 0) begin
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
            dataIn <= {ser_rx, dataIn[7:1]};
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






//--------------------Parte que envia----------------//
reg [3:0] txState = 0;// estado actual
reg [24:0] txCounter = 0;// ciclos de reloj
reg [7:0] dataOut = 0;// byte que se env�a
reg txPinRegister = 1;// valor a adjuntar en uart_tx
reg [2:0] txBitNumber = 0;// bit enviando
reg [3:0] txByteCounter = 0;

assign ser_tx =  txPinRegister;

localparam MEMORY_LENGTH = 1;
localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_DEBOUNCE = 4;
always @(posedge clk)begin
    case (txState)
        TX_STATE_IDLE: begin
            if (reg_dat_we) begin //cuando se presiona una tecla
                txState <= TX_STATE_START_BIT;
                sending<=1;
                txCounter <= 0;
            end
            else begin
                txPinRegister <= 1;
            end
        end 
        TX_STATE_START_BIT: begin
            txPinRegister <= 0;
            
            if ((txCounter + 1) == DELAY_FRAMES) begin //espera 312us 
                txState <= TX_STATE_WRITE;
                dataOut <=  {1'b1, reg_dat_di[7:0], 1'b0};
                txBitNumber <= 0;
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_WRITE: begin
            txPinRegister <= dataOut[txBitNumber];// envia el bit
            if ((txCounter + 1) == DELAY_FRAMES) begin
                if (txBitNumber == 4'b1010) begin // cuenta hasta 8bits
                    txState <= TX_STATE_STOP_BIT;
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
            if ((txCounter + 1) == DELAY_FRAMES) begin //espera 262143 ciclos es 9,71 ms
                if (!reg_dat_we) 
                    sending<=0;
                    txState <= TX_STATE_IDLE;
            end else
                txCounter <= txCounter + 1;
        end
    endcase
end
endmodule