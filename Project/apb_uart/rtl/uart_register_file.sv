`ifndef UART_REGISTER_FILE_SV
`define UART_REGISTER_FILE_SV

module uart_register_file (
	input PCLK,
	input PRESETn,
	input PSEL,
	input PWRITE,
	input PENABLE,
	input [5:0] PADDR,
	input [31:0] PWDATA,
	output logic [31:0] PRDATA,
	output logic PREADY,
	output logic PSLVERR,
	output logic [7:0] LCR,
	// Transmitter related signals
	output logic tx_fifo_we,
	output logic tx_enable,
	input tx_fifo_empty,
	input tx_busy,
	// Receiver related signals
	input [10:0] rx_data_out, // BI, FE, PE and data
	input rx_overrun,
	input [4:0] rx_fifo_count,
	input rx_fifo_empty,
	output logic rx_enable,
	output logic rx_fifo_re,
	output logic irq,
	output logic baud_o );

// Include defines for addresses and offsets
`define RBR_ADDR 6'h0  // Receiver Buffer Register (read only)
`define THR_ADDR 6'h0  // Transmitter Holding Register (write only)
`define IER_ADDR 6'h4  // Interrupt Enable Register
`define IIR_ADDR 6'h8  // Interrupt Identification Register (read only)
`define FCR_ADDR 6'h8  // FIFO Control Register (write only)
`define LCR_ADDR 6'hc  // Line Control Register
`define LSR_ADDR 6'h10 // Line Status Register
`define DLL_ADDR 6'h20 // Divisor LSB Latch
`define DLH_ADDR 6'h24 // Divisor MSB Latch

// APB interface FSM states
typedef enum {IDLE, SETUP, ACCESS} APB_STATE;

logic we;
logic re;

// RX FIFO over its threshold:
logic rx_fifo_over_threshold;

// UART Registers:
logic[3:0] IER;
logic[3:0] IIR;
logic[7:0] FCR;
logic[3:0] LSR;
logic[15:0] DIV;

// Baudrate counter
logic[15:0] dlc;
logic enable;
logic start_dlc;

// RX & TX enables
logic tx_int;
logic rx_int;
logic lsr_int;

logic last_tx_fifo_empty;

// APB Bus interface FSM:
APB_STATE fsm_state;

always @(posedge PCLK) begin
	if (PRESETn == 0) begin
		we <= 0;
		re <= 0;
		PREADY <= 0;
		fsm_state <= IDLE;
	end
	else begin
		case (fsm_state)
			IDLE: begin
				we <= 0;
				re <= 0;
				PREADY <= 0;
				if (PSEL)
					fsm_state <= SETUP;
				end
			SETUP: begin
				re <= 0;
				if (PSEL && PENABLE) begin
					fsm_state <= ACCESS;
					if (PWRITE)
						we <= 1;
				end
				else
					fsm_state <= IDLE;
			end
			ACCESS: begin
				PREADY <= 1;
				we <= 0;
				if(PWRITE == 0)
					re <= 1;
				fsm_state <= IDLE;
			end
			default: fsm_state <= IDLE;
		endcase
	end
end

// One clock pulse per enable
assign baud_o = ~PCLK && enable;

// Interrupt line
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		irq <= 0;
	end
	else if((re == 1) && (PADDR == `IIR_ADDR)) begin
		irq <= 0;
	end
	else begin
		irq <= (IER[0] & rx_int) | (IER[1] & tx_int) | (IER[2] & lsr_int);
	end
end

// The register implementations:

// TX Data register strobe
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		tx_fifo_we <= 0;
	end
	else if((we == 1) && (PADDR == `THR_ADDR)) begin
		tx_fifo_we <= 1;
	end
	else begin
		tx_fifo_we <= 0;
	end
end

// DIV - baud rate divider
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		DIV <= 0;
		start_dlc <= 0;
	end
	else begin
		if(we == 1) begin
			case(PADDR)
				`DLL_ADDR: begin
					DIV[7:0] <= PWDATA[7:0];
					start_dlc <= 1;
				end
				`DLH_ADDR: begin
					DIV[15:8] <= PWDATA[7:0];
				end
			endcase
		end
		else begin
			start_dlc <= 0;
		end
	end
end

// LCR - Line control register
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		LCR <= 0;
	end
	else if((we == 1) && (PADDR == `LCR_ADDR)) begin
		LCR <= PWDATA[7:0];
	end
end

// FCR - FIFO Control Register:
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		FCR <= 8'h0;
	end
	else if((we == 1) && (PADDR == `FCR_ADDR)) begin
		FCR <= PWDATA[7:0];
	end
end

// IER - Interrupt Masks:
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		IER <= 0;
	end
	else if((we == 1) && (PADDR == `IER_ADDR)) begin
		IER <= PWDATA[3:0];
	end
end

//
// Read back path:
//
always_comb begin
	PSLVERR = 0;
	case(PADDR)
		`RBR_ADDR: PRDATA = {24'h0, rx_data_out[7:0]};
		`IER_ADDR: PRDATA = {28'h0, IER};
		`IIR_ADDR: PRDATA = {28'hc, IIR};
		`LCR_ADDR: PRDATA = {24'h0, LCR};
		`LSR_ADDR: PRDATA = {24'h0, 1'b0, (tx_fifo_empty & ~tx_busy), tx_fifo_empty, LSR, ~rx_fifo_empty};
		`DLL_ADDR: PRDATA = {24'h0, DIV[7:0]};
		`DLH_ADDR: PRDATA = {24'h0, DIV[15:8]};
		default: begin
			PRDATA = 32'h0;
			PSLVERR = 1;
		end
	endcase
end

// Read pulse to pop the Rx Data FIFO
always @(posedge PCLK) begin
	if (PRESETn == 0)
		rx_fifo_re <= 0;
	else if (rx_fifo_re) // restore the signal to 0 after one clock cycle
		rx_fifo_re <= 0;
	else if ((re == 1) && (PADDR == `RBR_ADDR))
		rx_fifo_re <= 1; // advance read pointer
end

//
// LSR RX error bits
//
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		lsr_int <= 0;
		LSR <= 0;
	end
	else begin
		if((PADDR == `LSR_ADDR) && (re == 1)) begin
			LSR <= 0;
			lsr_int <= 0;
		end
		else if(rx_fifo_re == 1) begin
			LSR <= {rx_data_out[10:8], rx_overrun}; // BI, FE, PE, OE
			lsr_int <= ({rx_data_out[10:8], rx_fifo_over_threshold} != 0);
		end
		else begin
			lsr_int <= (LSR != 0);
		end
	end
end

// Interrupt Identification register
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		IIR <= 4'h1;
	end
	else begin
		if((lsr_int == 1) && (IER[2] == 1)) begin
			IIR <= 4'h6;
		end
		else if((rx_int == 1) && (IER[0] == 1)) begin
			IIR <= 4'h4;
		end
		else if((tx_int == 1) && (IER[1] == 1)) begin
			IIR <= 4'h2;
		end
		else begin
			IIR <= 4'h1;
		end
	end
end

//
// Baud rate generator:
//
// Frequency divider
always @(posedge PCLK) begin
	if (PRESETn == 0)
		dlc <= 0;
	else if (start_dlc | (dlc == 0))
		dlc <= DIV - 1; // preset counter
	else
		dlc <= dlc - 1;; // decrement counter
end

// Enable signal generation logic
always @(posedge PCLK) begin
	if (PRESETn == 0)
		enable <= 1'b0;
	else if ((DIV != 0) & (dlc == 0))
		enable <= 1'b1;
	else
		enable <= 1'b0;
end

assign tx_enable = enable;
assign rx_enable = enable;

//
// Interrupts
//
// TX Interrupt - Triggered when TX FIFO contents below threshold
// Cleared by a write to the interrupt clear bit
//
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		tx_int <= 0;
		last_tx_fifo_empty <= 0;
	end
	else begin
		last_tx_fifo_empty <= tx_fifo_empty;
		if((re == 1) && (PADDR == `IIR_ADDR) && (PRDATA[3:0] == 4'h2)) begin
			tx_int <= 0;
		end
		else begin
			tx_int <= (tx_fifo_empty & ~last_tx_fifo_empty) | tx_int;
		end
	end
end

//
// RX Interrupt - Triggered when RX FIFO contents above threshold
// Cleared by a write to the interrupt clear bit
//
always @(posedge PCLK) begin
	if(PRESETn == 0) begin
		rx_int <= 0;
	end
	else begin
		rx_int <= rx_fifo_over_threshold;
	end
end

// RX FIFO over its threshold
always_comb begin
	case(FCR[7:6])
		2'h0: rx_fifo_over_threshold = (rx_fifo_count >= 1);
		2'h1: rx_fifo_over_threshold = (rx_fifo_count >= 4);
		2'h2: rx_fifo_over_threshold = (rx_fifo_count >= 8);
		2'h3: rx_fifo_over_threshold = (rx_fifo_count >= 14);
		default: rx_fifo_over_threshold = 0;
	endcase
end
endmodule: uart_register_file

`endif
