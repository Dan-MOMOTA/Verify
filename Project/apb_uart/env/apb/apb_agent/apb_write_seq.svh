`ifndef APB_WRITE_SEQ_SVH
`define APB_WRITE_SEQ_SVH

class apb_write_seq extends uvm_sequence #(apb_seq_item);
	`uvm_object_utils(apb_write_seq)

	rand logic [31:0] addr;
	rand logic [31:0] data;

	// Standard UVM Methods:
	extern function new(string name = "apb_write_seq");
	extern virtual task body;
endclass:apb_write_seq

function apb_write_seq::new(string name = "apb_write_seq");
	super.new(name);
endfunction

task apb_write_seq::body;
	apb_seq_item req = apb_seq_item::type_id::create("req");
	super.body();
	start_item(req);
    req.pwrite = 1;
    req.paddr = addr;
    req.data = data;
    finish_item(req);
endtask:body

`endif
