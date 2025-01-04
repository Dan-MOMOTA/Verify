`ifndef UART_SEQUENCER_SVH
`define UART_SEQUENCER_SVH

class uart_sequencer extends uvm_sequencer #(uart_seq_item);
	`uvm_component_utils(uart_sequencer)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
endclass

`endif
