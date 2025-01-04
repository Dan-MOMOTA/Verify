`ifndef UART_SV
`define UART_SV

module uart (
	// APB Signals
	input PCLK,
	input PRESETn,
	input [31:0] PADDR,
	input [31:0] PWDATA,
	output[31:0] PRDATA,
	input PWRITE,
	input PENABLE,
	input PSEL,
	output PREADY,
	output PSLVERR,
	// UART interrupt request line
	output IRQ,
	// UART signals
	// serial input/output
	output TXD,
	input RXD,
	// Baud rate generator output - needed for checking
	output baud_o
	);

// Interconnect
// Transmitter related:
wire tx_fifo_we;
wire tx_enable;
wire[4:0] tx_fifo_count;
wire tx_fifo_empty;
wire tx_fifo_full;
wire tx_busy;
// Receiver related:
wire[10:0] rx_data_out;
wire rx_idle;
wire rx_overrun;
wire parity_error;
wire framing_error;
wire break_error;
wire[4:0] rx_fifo_count;
wire rx_fifo_empty;
wire push_rx_fifo;
wire rx_enable;
wire rx_fifo_re;

wire[7:0] LCR;

uart_register_file control(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PSEL(PSEL),
	.PWRITE(PWRITE),
	.PENABLE(PENABLE),
	.PADDR(PADDR[5:0]),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA),
	.PREADY(PREADY),
	.PSLVERR(PSLVERR),
	.LCR(LCR),
	// Transmitter related signals
	.tx_fifo_we(tx_fifo_we),
	.tx_enable(tx_enable),
	.tx_fifo_empty(tx_fifo_empty),
	.tx_busy(tx_busy),
	// Receiver related signals
	.rx_data_out(rx_data_out),
	.rx_overrun(rx_overrun),
	.rx_fifo_count(rx_fifo_count),
	.rx_fifo_empty(rx_fifo_empty),
	.rx_enable(rx_enable),
	.rx_fifo_re(rx_fifo_re),
	// Modem interface related signals
	.irq(IRQ),
	.baud_o(baud_o)
);

// Transmitter and TX FIFO
uart_tx tx_channel(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PWDATA(PWDATA[7:0]),
	.tx_fifo_push(tx_fifo_we),
	.LCR(LCR),
	.enable(tx_enable),
	.tx_fifo_empty(tx_fifo_empty),
	.tx_fifo_full(tx_fifo_full),
	.tx_fifo_count(tx_fifo_count),
	.busy(tx_busy),
	.TXD(TXD));

// Receiver and RX FIFO
uart_rx rx_channel(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.RXD(RXD),
	.pop_rx_fifo(rx_fifo_re),
	.enable(rx_enable),
	.LCR(LCR),
	.rx_idle(rx_idle),
	.rx_fifo_out(rx_data_out),
	.rx_fifo_count(rx_fifo_count),
	.push_rx_fifo(push_rx_fifo),
	.rx_fifo_empty(rx_fifo_empty),
	.rx_fifo_full(rx_fifo_full),
	.rx_overrun(rx_overrun),
	.parity_error(parity_error),
	.framing_error(framing_error),
	.break_error(break_error));
endmodule: uart

`endif
