`ifndef UART_AGENT_PKG_SV
`define UART_AGENT_PKG_SV

`include "serial_interface.svh"

package uart_agent_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "uart_seq_item.svh"
	`include "uart_agent_configuration.svh"
	`include "uart_sequencer.svh"
	`include "uart_driver.svh"
	`include "uart_monitor.svh"
	`include "uart_agent.svh"

	// Parity Calculation
	// Method shared between the driver and the monitor:
	function bit calParity (input logic [7:0] lcr, input logic[7:0] data);
  		bit parity;
		if (lcr[5]) begin
			parity = ~lcr[4];
		end
		else begin
			case (lcr[1:0])
				2'b00: parity = ^data[4:0];
				2'b01: parity = ^data[5:0];
				2'b10: parity = ^data[6:0];
				2'b11: parity = ^data[7:0];
			endcase
			if (!lcr[4])
				parity = ~parity;
		end
		return parity;
	endfunction
endpackage

`endif