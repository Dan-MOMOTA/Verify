`ifndef UART_DRIVER_SVH
`define UART_DRIVER_SVH

class uart_driver extends uvm_driver #(uart_seq_item);
	`uvm_component_utils(uart_driver)
	virtual serial_interface sline;
	uart_agent_configuration cfg;
	uart_seq_item item;	

	function new(string name = "uart_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern task send_pkts;
	extern task bitPeriod;
endclass

function void uart_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual serial_interface)::get(this, "", "UART_VIF", sline))
		`uvm_fatal("uart_driver", "Cannot get UART_RX_VIF from uvm_config_db.")
	if (!uvm_config_db #(uart_agent_configuration)::get(this, "", "uart_agent_config", cfg))
	 	`uvm_fatal("CONFIG_LOAD", "Cannot get uart_agent_config from uvm_config_db.")
endfunction

task uart_driver::main_phase(uvm_phase phase);
	super.main_phase(phase);
	send_pkts;
endtask

task uart_driver::send_pkts;
	// transmits a character according to the appropriate word format
	sline.sdata <= 1;
	forever begin
		seq_item_port.get_next_item(item);
		// Variable delay
		repeat(item.delay)
			@(posedge sline.baud);
		// inject start bit error
		if (item.sbe) begin
			sline.sdata <= 0;
			repeat(item.sbe_clks)
				@(posedge sline.baud);
			sline.sdata <= 1;
			repeat(item.sbe_clks)
				@(posedge sline.baud);
		end
		// Start bit
		sline.sdata <= 0;
		bitPeriod;
		
		// Data bits 0 to 5 + lcr[1:0]
		for(int i = 0; i < 5 + cfg.lcr[1:0]; i++) begin
			sline.sdata <= item.data[i];
			bitPeriod;
		end

		// Parity
		if (cfg.lcr[3]) begin
			if (item.pe)
				sline.sdata <= ~calParity(cfg.lcr, item.data);
			else
				sline.sdata <= calParity(cfg.lcr, item.data);
			bitPeriod;
		end
		// The first stop bit
		if (!item.fe)
			sline.sdata <= 1;
		else
			sline.sdata <= 0;
		bitPeriod;
		if (!item.fe) begin
			if (cfg.lcr[2]) begin
				// another 0.5 stop bit
				if (cfg.lcr[1:0] == 2'b00) begin
					repeat(8)
						@(posedge sline.baud);
				end
				else
					bitPeriod; // the second stop bit				
			end
		end
		else begin
		   	sline.sdata <= 1;
			bitPeriod;
		end
		seq_item_port.item_done();
	end
endtask

task uart_driver::bitPeriod;
	repeat(16) @(posedge sline.baud);
endtask

`endif
