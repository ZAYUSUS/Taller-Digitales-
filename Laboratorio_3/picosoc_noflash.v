`timescale 1ns / 1ps

`ifndef PICORV32_REGS

`define PICORV32_REGS picosoc_regs
`endif

`ifndef PICOSOC_MEM
`define PICOSOC_MEM picosoc_mem
`endif

// this macro can be used to check if the verilog files in your
// design are read in the correct order.
`define PICOSOC_V

module picosoc_noflash (
	input clk,
	input resetn,
	output        iomem_valid,
	input         iomem_ready,
	output [ 3:0] iomem_wstrb,
	output [31:0] iomem_addr,
	output [31:0] iomem_wdata,
	input  [31:0] iomem_rdata,
	
    output  UART_TXD_IN,
    input   UART_RXD_OUT
);
	parameter integer MEM_WORDS = 129600;
	parameter [31:0] STACKADDR = 32'h80000;       // end of memory
	parameter [31:0] PROGADDR_RESET = 32'h 0000_0000; // 1 MB into flash

	wire mem_valid;
	wire mem_instr;
	wire mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	wire [31:0] mem_rdata;

	wire progmem_ready;
	wire [31:0] progmem_rdata;

	reg ram_ready;
	wire [31:0] ram_rdata;

	assign iomem_valid = mem_valid && mem_addr > 32'h800 && mem_addr < 32'h40000;
	assign iomem_wstrb = mem_wstrb;
	assign iomem_addr = mem_addr;
	assign iomem_wdata = mem_wdata;

	wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == 32'h5000 || mem_addr ==32'h8000);
	wire [31:0] simpleuart_reg_dat_do;
	wire        simpleuart_reg_dat_wait;

	assign mem_ready = 
            (iomem_valid && iomem_ready) || progmem_ready || ram_ready || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait);

	assign mem_rdata = 
            (iomem_valid && iomem_ready) ? iomem_rdata :
            progmem_ready ? progmem_rdata :
            ram_ready ? ram_rdata :
			simpleuart_reg_dat_sel ? simpleuart_reg_dat_do : 32'h0000_0000;

//Processor
picorv32 #(
		.STACKADDR(STACKADDR),
		.PROGADDR_RESET(PROGADDR_RESET),
		.BARREL_SHIFTER(1),
		.COMPRESSED_ISA(0),
		.ENABLE_MUL(0),
		.ENABLE_DIV(0)
	) cpu (
		.clk         (clk        ),
		.resetn      (resetn     ),
		.mem_valid   (mem_valid  ),//output
		.mem_instr   (mem_instr  ),//output 
		.mem_ready   (mem_ready  ),//output
		.mem_addr    (mem_addr   ),//output 32 bit
		.mem_wdata   (mem_wdata  ),//output 32 bit
		.mem_wstrb   (mem_wstrb  ),//output 4 bit
        .mem_rdata   (mem_rdata  )
	);
//----------------------------------------End processor instance------------------------------
//RAM instance
	always @(posedge clk)
		ram_ready <= mem_valid && !mem_ready && mem_addr > 32'h3FFFC;

	picosoc_mem #(.WORDS(MEM_WORDS)) memory (//instance RAM memory
		.clk(clk),
        .wen((mem_valid && !mem_ready && mem_addr>32'h3FFFC && mem_addr < 32'h80000) ? mem_wstrb : 4'b0),
		.addr(mem_addr[23:2]),
		.wdata(mem_wdata),
		.rdata(ram_rdata)
	);
//-----------------------------------------END RAM instance-------------------------------------
    // This it the program ROM memory for the PicoRV32
    progmem progmem (
        .clk    (clk),
        .rstn   (resetn),

        .valid  (mem_valid && mem_addr < 32'h800),
        .ready  (progmem_ready),
        .addr   (mem_addr),
        .rdata  (progmem_rdata)
    );
//-------------------------------------END ROM instance-----------------------------------------
//UART A PC-FPGA
	UART_custom UA (
		.clk         (clk         ),

		.ser_tx      (UART_TXD_IN      ),
		.ser_rx      (UART_RXD_OUT      ),

		.reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b 0),
		.reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
		.reg_dat_di  (mem_wdata),
		.reg_dat_do  (simpleuart_reg_dat_do),
		.reg_dat_wait(simpleuart_reg_dat_wait)
	);
endmodule

module picosoc_regs (//RISCV core registers
	input clk, wen,
	input [5:0] waddr,
	input [5:0] raddr1,
	input [5:0] raddr2,
	input [31:0] wdata,
	output [31:0] rdata1,
	output [31:0] rdata2
);
	(* ram_style = "distributed" *) reg [31:0] regs [0:31];

	always @(posedge clk)
		if (wen) regs[waddr[4:0]] <= wdata;

	assign rdata1 = regs[raddr1[4:0]];
	assign rdata2 = regs[raddr2[4:0]];
endmodule

module picosoc_mem #(// RAM memory
	parameter integer WORDS = 512
) (
	input clk,
	input [3:0] wen,
	input [21:0] addr,
	input [31:0] wdata,
	output reg [31:0] rdata
);
	(* ram_style = "distributed" *) reg [31:0] mem [0:WORDS-1];// RAM

	always @(posedge clk) begin
		rdata <= mem[addr];
		if (wen[0]) mem[addr][ 7: 0] <= wdata[ 7: 0];
		if (wen[1]) mem[addr][15: 8] <= wdata[15: 8];
		if (wen[2]) mem[addr][23:16] <= wdata[23:16];
		if (wen[3]) mem[addr][31:24] <= wdata[31:24];
	end
endmodule