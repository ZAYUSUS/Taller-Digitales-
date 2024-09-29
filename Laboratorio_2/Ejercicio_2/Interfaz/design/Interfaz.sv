

module Interfaz(
    input  logic KeyP,
    input  logic rst,
    input logic clk,
    input logic [1:0] fila,
    input logic uart_rx,
    output  logic [1:0] columna,
    output logic [3:0] Q,
    output logic [3:0] code,
    output logic uart_tx
);

reg  inhibit;
reg  Data_Available;
reg  clk1 ;
reg [14:0] espera=0;


wire Data_aux;
wire inhibit_aux;
wire [1:0] columna_aux;
wire [3:0] Q1;

always @(posedge clk)begin //divisor de reloj
    espera <= (espera>=13500) ? 0 : espera+1;
end
assign clk1 = (espera==13500) ? 1 : 0;//cambia cada 1ms
assign Data_Available = Data_aux;
assign inhibit = inhibit_aux;
assign  columna = columna_aux;
assign Q = ~Q1 ;
KBE b0(
        .clk(clk),
        .KeyP(KeyP),
        .Data_Available(Data_aux),
        .inhibit(inhibit_aux)
);

contador c0(//2bit contador
    .inhibit(inhibit),
    .clk(clk1),
    .out(columna_aux)
);
sincronizador s0(// sincronizador
    .D0(fila[1]),
    .D1(fila[0]),
    .D2(columna[0]),
    .D3(columna[1]),
    .data_Available(Data_Available),
    .rst(rst),
    .Q(Q1)
);

//Codificador
always @(Q1) begin
    case (Q1)
        4'b0000: code <= 4'h1;
        4'b0001: code <= 4'h2;
        4'b0010: code <= 4'h3;
        4'b0011: code <= 4'hA;
        4'b0100: code <= 4'h4;
        4'b0101: code <= 4'h5;
        4'b0110: code <= 4'h6;
        4'b0111: code <= 4'hB;
        4'b1000: code <= 4'h7;
        4'b1001: code <= 4'h8;
        4'b1010: code <= 4'h9;
        4'b1011: code <= 4'hC;
        4'b1100: code <= 4'hF;
        4'b1101: code <= 4'h0;
        4'b1110: code <= 4'hE;
        4'b1111: code <= 4'hD;
        default: code <= 4'h0;
    endcase
end

//uart 



localparam DELAY_FRAMES = 2812;// 27,000,000 (27Mhz) / 9600 Baud rate
localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);
reg [3:0] txState = 0;// estado actual
reg [24:0] txCounter = 0;// ciclos de reloj
reg [7:0] dataOut = 0;// byte que se envía
reg txPinRegister = 1;// valor a adjuntar en uart_tx
reg [2:0] txBitNumber = 0;// bit enviando
reg [3:0] txByteCounter = 0;

assign uart_tx = txPinRegister;

// parte a cambiar
localparam MEMORY_LENGTH = 2;
reg [7:0] code_uart [MEMORY_LENGTH-1:0];

initial begin
    code_uart[0] = "2";
end

always @(KeyP) begin
    case (Q1)
        4'b0000: code_uart[1] <= "1";
        4'b0001: code_uart[1] <= "2";
        4'b0010: code_uart[1] <= "3";
        4'b0011: code_uart[1] <= "A";
        4'b0100: code_uart[1] <= "4";
        4'b0101: code_uart[1] <= "5";
        4'b0110: code_uart[1] <= "6";
        4'b0111: code_uart[1] <= "B";
        4'b1000: code_uart[1] <= "7";
        4'b1001: code_uart[1] <= "8";
        4'b1010: code_uart[1] <= "9";
        4'b1011: code_uart[1] <= "C";
        4'b1100: code_uart[1] <= "*";
        4'b1101: code_uart[1] <= "0";
        4'b1110: code_uart[1] <= "#";
        4'b1111: code_uart[1] <= "D";
        default: code_uart[1] <= "0";
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
            if (KeyP == 1) begin //cuando se presiona una tecla
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
                dataOut <= code_uart[txByteCounter];// guardo el caracter
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
            if (txCounter == 23'b111111111111111111) begin
                if (KeyP == 0) 
                    txState <= TX_STATE_IDLE;
            end else
                txCounter <= txCounter + 1;
        end
    endcase
end

endmodule

