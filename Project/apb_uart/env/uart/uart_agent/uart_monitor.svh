`ifndef UART_MONITOR_SVH
`define UART_MONITOR_SVH

class uart_monitor extends uvm_component;
	`uvm_component_utils(uart_monitor)
	
	uvm_analysis_port #(uart_seq_item) ap;
	virtual serial_interface sline;
	uart_agent_configuration cfg;

	uart_seq_item item;
	bit sbe; // start bit error
	bit pe;
	bit fe;
	logic parity;
	logic[7:0] rxData;

	extern function new(string name = "uart_monitor", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern task start_bit_error_detect();
	extern task rxChar();
	extern task bitPeriod;
endclass

function uart_monitor::new(string name, uvm_component parent);
		super.new(name, parent);
endfunction

function void uart_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap", this);
		
	if(!uvm_config_db #(virtual serial_interface)::get(this, "", "UART_VIF", sline))
		`uvm_fatal("uart_monitor", "Cannot get UART_VIF from uvm_config_db.")
	if (!uvm_config_db #(uart_agent_configuration)::get(this, "", "uart_agent_config", cfg))
	 	`uvm_fatal("CONFIG_LOAD", "Cannot get uart_agent_config from uvm_config_db.")
endfunction

task uart_monitor::main_phase(uvm_phase phase);
	super.main_phase(phase);
	repeat(3) @(posedge sline.baud);
	forever begin
		item = uart_seq_item::type_id::create(.name("item"));
		fork
			rxChar();
			start_bit_error_detect();
		join_any
		if (sbe == 1) begin
			disable fork;
			`uvm_info("uart_monitor", "start bit error", UVM_LOW)
		end
		else begin
			item.data = rxData;
			item.pe = pe;
			item.fe = fe;
			ap.write(item);
			rxData = 0;
			// item.print();
		end
	end
endtask

task uart_monitor::start_bit_error_detect();
	sbe = 0;
	item.sbe = 0;
	while((sline.sdata == 1'b1) || (sline.sdata == 1'bx))
		@(posedge sline.baud);
	
	repeat(7) begin
		@(posedge sline.baud);
		if(sline.sdata == 1'b1) begin
			`uvm_warning("uart_monitor", "Start bit error detected")
			sbe = 1;
			item.sbe = 1;
			break;
		end
	end
	while (sbe == 1'b0)
		@(posedge sline.baud);
endtask

task uart_monitor::rxChar();
	// Receives a character according to the appropriate word format
	fe = 0;
	rxData = 0;
	// Wait for a falling edge on txd (Start bit)
	do
		@(posedge sline.baud);
	while((sline.sdata == 1'b1) || (sline.sdata == 1'bx));
	repeat(7) // Sample on mid point of data field
		@(posedge sline.baud);
		
	// Data bits 0 to 4 + lcr[1:0]
	for(int i = 0; i <= 4 + cfg.lcr[1:0]; i++) begin
		bitPeriod;
		rxData[i] = sline.sdata;
	end
	
	// Parity
	if (cfg.lcr[3]) begin
		bitPeriod;
		parity = sline.sdata;
		pe = logic'(calParity (cfg.lcr, rxData));
		if (pe != parity) begin
			pe = 1;
		end
		else
			pe = 0;
	end
	// Check for framing error - get to bit boundary
	repeat(8) @(posedge sline.baud);
	repeat(8) begin
		@(posedge sline.baud);
		if (sline.sdata == 1'b0)
			fe = 1;
	end
endtask

task uart_monitor::bitPeriod;
	repeat(16) @(posedge sline.baud);
endtask

`endif
