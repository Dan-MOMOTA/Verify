`ifndef APB_SEQ_ITEM_SVH
`define APB_SEQ_ITEM_SVH

class apb_seq_item extends uvm_sequence_item;
	// Properties
	rand bit[31:0] paddr;
	rand bit[31:0] data; // pwdata or prdata
	rand bit pwrite;
	rand int delay; // delay before send apb setup phase
	bit error;
	
	`uvm_object_utils_begin(apb_seq_item)
		`uvm_field_int(paddr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(pwrite, UVM_ALL_ON)
		`uvm_field_int(delay, UVM_ALL_ON)
		`uvm_field_int(error, UVM_ALL_ON)
	`uvm_object_utils_end

	// Constraints
	constraint addr_alignment { paddr[1:0] == 0; }
	constraint delay_bounds { delay inside {[1:10]}; }

	extern function new(string name = "apb_seq_item");
endclass

function apb_seq_item::new(string name);
	super.new(name);
endfunction

`endif
