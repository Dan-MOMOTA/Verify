`ifndef APB_READ_SEQ_SVH
`define APB_READ_SEQ_SVH

class apb_read_seq extends uvm_sequence #(apb_seq_item);
	`uvm_object_utils(apb_read_seq)
	rand logic [31:0] addr;
	logic [31:0] data;

	extern function new(string name = "apb_read_seq");
	extern virtual task body();
endclass:apb_read_seq

function apb_read_seq::new(string name = "apb_read_seq");
	super.new(name);
endfunction

task apb_read_seq::body();
	apb_seq_item req = apb_seq_item::type_id::create("req");;
	super.body();
	start_item(req);
	req.pwrite = 0;
	req.paddr = addr;
	finish_item(req);
	data = req.data; // apb read
endtask:body

`endif
