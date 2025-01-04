`ifndef APB_DRIVER_SVH
`define APB_DRIVER_SVH

class apb_driver extends uvm_driver #(apb_seq_item);
	`uvm_component_utils(apb_driver)
	
	// Properties
	virtual apb_interface APB; // Virtual Interface
	apb_agent_configuration m_cfg;

	// Methods
	extern function int sel_lookup(bit[31:0] address);
	// Standard UVM Methods:
	extern function new(string name = "apb_driver", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
endclass

function apb_driver::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void apb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_agent_configuration)::get(this, "", "apb_agent_config", m_cfg)) begin
		`uvm_error("build_phase", "Unable to get apb_agent_config")
	end
	if(!uvm_config_db #(virtual apb_interface)::get(this, "", "APB_VIF", APB))
		`uvm_fatal("apb_driver", "Cannot get APB_VIF from uvm_config_db.")
endfunction

task apb_driver::main_phase(uvm_phase phase);
	super.main_phase(phase);
	APB.drv_cb.PSEL <= 0;
	APB.drv_cb.PENABLE <= 0;
	APB.drv_cb.PADDR <= 0;
	// Wait for reset to clear
	do
		@APB.drv_cb;
	while (APB.PRESETn == 1'b0);
	
	forever begin
		int psel_index;
		seq_item_port.get_next_item(req);
		psel_index = sel_lookup(req.paddr);
		
		repeat(req.delay)
			@APB.drv_cb;
				
		if(psel_index >= 0) begin
			APB.drv_cb.PSEL[psel_index] <= 1;
			APB.drv_cb.PADDR <= req.paddr;
			APB.drv_cb.PWDATA <= req.data;
			APB.drv_cb.PWRITE <= req.pwrite;
		
			fork
				begin
					@APB.drv_cb;
					APB.drv_cb.PENABLE <= 1;
				end
				begin
					do
						@APB.drv_cb;
					while (APB.PREADY == 1'b0);
					if(req.pwrite == 0) begin // read
						req.data = APB.drv_cb.PRDATA;
					end
				end
			join
		end
		else begin
			`uvm_error("RUN", $sformatf("Access to addr %0h out of APB address range", req.paddr))
			req.error = 1;
		end
		@APB.drv_cb;
		APB.drv_cb.PSEL[psel_index] <= 0;
		APB.drv_cb.PENABLE <= 0;
		APB.drv_cb.PADDR <= 0;		
		seq_item_port.item_done();
	 end
endtask

// Looks up the address and returns PSEL line that should be activated
// If the address is invalid, a non positive integer is returned to indicate an error
function int apb_driver::sel_lookup(bit[31:0] address);
	for(int i = 0; i < m_cfg.no_select_lines; i++) begin
		if((address >= m_cfg.start_address[i]) && (address <= (m_cfg.start_address[i] + m_cfg.range[i]))) begin
			return i;
		end
	end
	return -1; // Error: Address not found
endfunction

`endif
