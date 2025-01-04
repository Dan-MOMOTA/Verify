`ifndef APB_AGENT_CONFIG_SVH
`define APB_AGENT_CONFIG_SVH

class apb_agent_configuration extends uvm_object;
	`uvm_object_utils(apb_agent_configuration)

	// Data Members
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	// Include the APB functional coverage monitor
	bit has_functional_coverage = 0;
	// Include the APB RAM based scoreboard
	bit has_scoreboard = 0;

	// Address decode for the select lines:
	int no_select_lines = 1;
	int apb_index = 0; // Which PSEL is the monitor connected to
	bit[31:0] start_address[15:0];
	bit[31:0] range[15:0];

	// Methods
	extern function new(string name = "apb_agent_configuration");
endclass

function apb_agent_configuration::new(string name);
	super.new(name);
endfunction

`endif