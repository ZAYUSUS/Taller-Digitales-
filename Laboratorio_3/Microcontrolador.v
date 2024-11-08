

`ifndef PICORV32_REGS
`ifdef PICORV32_V
`error "picosoc_noflash.v must be read before picorv32.v!"
`endif
`define PICORV32_REGS picosoc_regs
`endif

`ifndef PICOSOC_MEM
`define PICOSOC_MEM picosoc_mem
`endif

// this macro can be used to check if the verilog files in your
// design are read in the correct order.
`define PICOSOC_V

module Microcontrolador(
    input clk,
    input rst,
    
    output        iomem_valid,
	input         iomem_ready,
	output [ 3:0] iomem_wstrb,
	output [31:0] iomem_addr,
	output [31:0] iomem_wdata,
	input  [31:0] iomem_rdata,
	
    output  UART_TXD_IN,
    input   UART_RXD_OUT
    );
    
	
endmodule





