`default_nettype none

module uart
#(
    parameter DELAY_FRAMES = 2812 // 27,000,000 (27Mhz) / 9600 Baud rate
)
(
    input clk,
    input uart_rx,
    input KeyP,
    input [1:0] fila,
    input [1:0] columna,
    output uart_tx,
    output reg [5:0] led
);

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

reg [3:0] rxState = 0; // estado actual
reg [12:0] rxCounter = 0; // pulsos de reloj
reg [7:0] dataIn = 0;// bit recivido
reg [2:0] rxBitNumber = 0; // bits leidos
reg byteReady = 0; // indica cuando se leyo un byte (8 bits)

// maquina de estados
localparam RX_STATE_IDLE = 0; 
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 5;

always @(posedge clk) begin
    case (rxState)
        RX_STATE_IDLE: begin // estado inactivo
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
// fin recepción de datos-----------------------------------------

always @(posedge clk) begin
    if (byteReady) begin
        led <= ~dataIn[5:0];
    end
end
// comienzo transmision de datos --------------------------------------------
reg [3:0] txState = 0;// estado actual
reg [24:0] txCounter = 0;// ciclos de reloj
reg [7:0] dataOut = 0;// byte que se envía
reg txPinRegister = 1;// valor a adjuntar en uart_tx
reg [2:0] txBitNumber = 0;// bit enviando
reg [3:0] Q;
reg [3:0] code;
assign uart_tx = txPinRegister;

// parte a cambiar
reg [7:0] code;
always @(KeyP) begin
    Q<={fila[0],fila[1],columna[0],columna[1]};
    case (Q)
        4'b0000: code <= '1';
        4'b0001: code <= '2';
        4'b0010: code <= '3';
        4'b0011: code <= 'A';
        4'b0100: code <= '4';
        4'b0101: code <= '5';
        4'b0110: code <= '6';
        4'b0111: code <= 'B';
        4'b1000: code <= '7';
        4'b1001: code <= '8';
        4'b1010: code <= '9';
        4'b1011: code <= 'C';
        4'b1100: code <= '*';
        4'b1101: code <= '0';
        4'b1110: code <= '#';
        4'b1111: code <= 'D';
        default: code <= '0';
    endcase
end
//localparam MEMORY_LENGTH = 2;

localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_DEBOUNCE = 4;
always @(posedge clk)begin
    case (txState)
        TX_STATE_IDLE: begin
            if (KeyP == 0) begin //cuando se presiona una tecla
                txState <= TX_STATE_START_BIT;
                txCounter <= 0;
            end
            else begin
                txPinRegister <= 1;
            end
        end 
        TX_STATE_START_BIT: begin
            txPinRegister <= 0;
            if ((txCounter + 1) == DELAY_FRAMES) begin
                txState <= TX_STATE_WRITE;
                dataOut <= code;// guardo el caracter
                txBitNumber <= 0;
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_WRITE: begin
            txPinRegister <= dataOut[txBitNumber];
            if ((txCounter + 1) == DELAY_FRAMES) begin
                if (txBitNumber == 3'b111) begin // cuenta hasta 8bits
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
            if ((txCounter + 1) == DELAY_FRAMES) begin
                txState <= TX_STATE_DEBOUNCE;
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
            TX_STATE_DEBOUNCE: begin
            if (txCounter == 23'b111111111111111111) begin
                if (KeyP == 1) 
                    txState <= TX_STATE_IDLE;
            end else
                txCounter <= txCounter + 1;
        end
    endcase
end

endmodule

