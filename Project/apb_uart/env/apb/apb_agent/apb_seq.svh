`ifndef APB_SEQ_SVH
`define APB_SEQ_SVH

class apb_seq extends uvm_sequence #(apb_seq_item);
	`uvm_object_utils(apb_seq)

	extern function new(string name = "apb_seq");
	extern virtual task body();
endclass

function apb_seq::new(string name = "apb_seq");
	super.new(name);
endfunction

task apb_seq::body();
	apb_seq_item req;
	super.body();
	req = apb_seq_item::type_id::create("req");
	start_item(req);
	assert(req.randomize());
	finish_item(req);
endtask

`endif
