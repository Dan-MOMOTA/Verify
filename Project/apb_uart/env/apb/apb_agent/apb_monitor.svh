`ifndef APB_MONITOR_SVH
`define APB_MONITOR_SVH

class apb_monitor extends uvm_component;
	`uvm_component_utils(apb_monitor);

	virtual apb_interface APB; // Virtual interface
	uvm_analysis_port #(apb_seq_item) ap;
	int apb_index = 0; // Which PSEL line is this monitor connected to

	extern function new(string name = "apb_monitor", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
endclass

function apb_monitor::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap", this);
	if(!uvm_config_db #(virtual apb_interface)::get(this, "", "APB_VIF", APB))
		`uvm_fatal("apb_monitor", "Cannot get APB_VIF from uvm_config_db.")
endfunction

task apb_monitor::main_phase(uvm_phase phase);
	apb_seq_item item;
	super.main_phase(phase);
	forever begin
		item = apb_seq_item::type_id::create("item");
		if(APB.mon_cb.PREADY && APB.mon_cb.PSEL[apb_index]) begin
			item.paddr = APB.mon_cb.PADDR;
			item.pwrite = APB.mon_cb.PWRITE;
			if(APB.mon_cb.PWRITE) begin
				item.data = APB.mon_cb.PWDATA;
			end
			else begin
				item.data = APB.mon_cb.PRDATA;
			end
			// if ((item.paddr[7:0] == 0) && (item.pwrite == 1))
				// item.print();
			// Send to subscribers
			ap.write(item);
		end
		@APB.drv_cb;
	end
endtask

`endif
