`ifndef UART_SEQ_ITEM_SVH
`define UART_SEQ_ITEM_SVH

class uart_seq_item extends uvm_sequence_item;
	rand int delay;
	rand bit sbe; // start bit error
	rand int sbe_clks; // start bit error clock cycles
	rand bit[7:0] data;
	rand bit fe;
	rand bit pe;

	`uvm_object_utils_begin(uart_seq_item)
		`uvm_field_int(delay, UVM_ALL_ON)
		`uvm_field_int(sbe, UVM_ALL_ON)
		`uvm_field_int(sbe_clks, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(fe, UVM_ALL_ON)
		`uvm_field_int(pe, UVM_ALL_ON)
	`uvm_object_utils_end
	
	constraint error_dists {
		fe dist {1:=1, 0:=99};
		pe dist {1:=1, 0:=99};
		sbe dist {1:=0, 0:=50};}

	constraint clks {
		delay inside {[0:8]};
		sbe_clks inside {[1:4]};}

	extern function new(string name = "uart_seq_item");
endclass

function uart_seq_item::new(string name);
	super.new(name);
endfunction

`endif
