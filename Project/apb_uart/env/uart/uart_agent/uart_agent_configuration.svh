`ifndef UART_AGENT_CONFIG_
`define UART_AGENT_CONFIG_

class uart_agent_configuration extends uvm_object;
	`uvm_object_utils(uart_agent_configuration)

	// lcr, div and ier are set in uart_config_seq
	bit [7:0] lcr; // {DLAB, BC, SP, EPS, PEN, STB, WLS}

	function new(string name = "uart_agent_configuration");
		super.new(name);
	endfunction
endclass

`endif
