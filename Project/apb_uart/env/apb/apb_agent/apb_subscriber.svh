`ifndef APB_SUBSCRIBER_SVH
`define APB_SUBSCRIBER_SVH

class apb_subscriber extends uvm_subscriber #(apb_seq_item);
	`uvm_component_utils(apb_subscriber);
	// Cover Group(s)
	covergroup apb_cov;
		OPCODE: coverpoint analysis_txn.pwrite {
			bins write = {1};
			bins read = {0};}
	endgroup

	// Component Members
	apb_seq_item analysis_txn;

	// Methods
	extern function new(string name = "apb_subscriber", uvm_component parent = null);
	extern function void write(T t);
	extern virtual function void report_phase(uvm_phase phase);
endclass: apb_subscriber

function apb_subscriber::new(string name, uvm_component parent);
	super.new(name, parent);
	apb_cov = new();
endfunction

function void apb_subscriber::write(T t);
	analysis_txn = t;
	apb_cov.sample();
endfunction

function void apb_subscriber::report_phase(uvm_phase phase);
	super.report_phase(phase);
endfunction

`endif
