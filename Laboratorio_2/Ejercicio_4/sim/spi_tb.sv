`timescale 1ns/1ps

module spi_tb (
);
reg clk;
reg resetn;
reg ser_rx;
wire ser_tx;
reg [3:0] leds;
reg [31:0] ms = 1000000;

always
    #37  clk = ~clk;
task wait_n_ms(int delay);
        #(delay*ms);
endtask
initial begin
	//00110000 0
    clk=0;
    resetn=1;
    
	$display("Starting UART RX");
    $monitor("Bit sertx %b",ser_tx);
    $monitor("LED Value %b", leds);
    wait_n_ms(10);
    resetn=0;
    wait_n_ms(300);
    resetn=1;
    wait_n_ms(100);
    resetn=0;
    wait_n_ms(100);
    resetn=1;
    wait_n_ms(100);
    #104118 ser_rx=0;
    #104118 ser_rx=1;
    #104118 ser_rx=0;
    #104118 ser_rx=0;
    #104118 ser_rx=0;
    #104118 ser_rx=0;
    #104118 ser_rx=1;
    #104118 ser_rx=1;
	#1000 $finish;
end

Spi s(
	.clk(clk),
	.resetn(resetn),

	.ser_tx(ser_tx),
	.ser_rx(ser_rx),

	.lcd_resetn(),
	.lcd_clk(),
	.lcd_cs(),
	.lcd_rs(),
	.lcd_data(),
	.leds(leds)
);

    initial begin
        $dumpfile("spi_tb.vcd");
        $dumpvars(0,spi_tb);
    end
endmodule