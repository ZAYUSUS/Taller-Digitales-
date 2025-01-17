/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module top (
	input CLK100MHZ,
	input BTNC,
	input BTNU,
	input BTNL,
	input BTNR,
	input BTND,
	input XA_N,// JMOD
	output XP_N,//JMOD

	output UART_TXD_IN,
	input UART_RXD_OUT,

    input [15:0] SW,
	output [15:0] LED
);
	wire clk_bufg;
	BUFG bufg (.I(CLK100MHZ), .O(clk_bufg));

	reg [5:0] reset_cnt = 60;
	wire resetn = &reset_cnt;
    
	always @(posedge clk_bufg) begin
		reset_cnt <= reset_cnt + !resetn;
	end
    
	wire        iomem_valid;
	reg         iomem_ready;
	wire [3:0]  iomem_wstrb;
	wire [31:0] iomem_addr;
	wire [31:0] iomem_wdata;
	reg  [31:0] iomem_rdata;

	reg [31:0] gpio;

	assign LED = gpio[15:0];

	always @(posedge clk_bufg) begin
	
		if (!resetn) begin
			gpio <= 0;
		end else begin
			iomem_ready <= 0;
			if (iomem_valid && !iomem_ready && iomem_addr == 32'h3000) begin
				iomem_ready <= 1;
				iomem_rdata <= {gpio[15:0],SW};
				if (iomem_wstrb[0]) gpio[ 7: 0] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) gpio[15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) gpio[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) gpio[31:24] <= iomem_wdata[31:24];
			end else if (iomem_valid && !iomem_ready && iomem_addr == 32'h2000) begin // reads the switches
			     iomem_ready <=1;
			     iomem_rdata <= {gpio[15:0],SW};
			end else if (iomem_valid && !iomem_ready && iomem_addr == 32'h4000) begin // reads the buttons
			     iomem_ready <=1;
			     iomem_rdata <= {gpio[26:0],BTNC,BTNU,BTNL,BTNR,BTND};
			end
		end
	end

	picosoc_noflash soc (
		.clk          (clk_bufg),
		.resetn        (resetn      ),
		
		.iomem_valid  (iomem_valid ),
		.iomem_ready  (iomem_ready ),
		.iomem_wstrb  (iomem_wstrb ),
		.iomem_addr   (iomem_addr  ),
		.iomem_wdata  (iomem_wdata ),
		.iomem_rdata  (iomem_rdata ),
		
		.UARTB_TXD_IN(XP_N),
		.UARTB_RXD_OUT(XA_N),
		
	    .UART_TXD_IN       (UART_TXD_IN),
		.UART_RXD_OUT      (UART_RXD_OUT)
	);

endmodule
