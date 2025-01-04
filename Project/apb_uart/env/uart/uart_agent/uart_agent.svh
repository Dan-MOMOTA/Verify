`ifndef UART_AGENT_SVH
`define UART_AGENT_SVH

class uart_agent extends uvm_agent;
	`uvm_component_utils(uart_agent)

	uvm_analysis_port #(uart_seq_item) ap;
	uart_driver m_driver;
	uart_sequencer m_sequencer;
	uart_monitor m_monitor;
	uart_agent_configuration m_config;

	function new(string name = "uart_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// if (!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", cfg) )
		// 	`uvm_fatal("CONFIG_LOAD", "Cannot get() configuration uart_agent_config from uvm_config_db. Have you set() it?")
		if(is_active == UVM_ACTIVE) begin
			m_driver = uart_driver::type_id::create("m_driver", this);
			m_sequencer = uart_sequencer::type_id::create("m_sequencer", this);
		end
		m_monitor = uart_monitor::type_id::create("m_monitor", this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE) begin
			m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
		end
		ap = m_monitor.ap;
	endfunction
endclass

`endif
