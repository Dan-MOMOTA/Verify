`ifndef APB_AGENT_SVH
`define APB_AGENT_SVH

class apb_agent extends uvm_component;
	`uvm_component_utils(apb_agent)
	
	uvm_analysis_port #(apb_seq_item) ap;
	// Component Members	
	apb_agent_configuration m_config;
	apb_monitor m_monitor;
	apb_sequencer m_sequencer;
	apb_driver m_driver;
	apb_subscriber m_subscriber;

	// Methods
	extern function new(string name = "apb_agent", uvm_component parent = null);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
endclass: apb_agent

function apb_agent::new(string name , uvm_component parent);
	super.new(name, parent);
endfunction

function void apb_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_agent_configuration)::get(this, "", "apb_agent_config", m_config)) begin
		`uvm_error("build_phase", "APB agent config not found")
	end
	// Monitor is always present
	m_monitor = apb_monitor::type_id::create("m_monitor", this);
	// Only build the driver and sequencer if active
	if(m_config.is_active == UVM_ACTIVE) begin
		m_driver = apb_driver::type_id::create("m_driver", this);
		m_sequencer = apb_sequencer::type_id::create("m_sequencer", this);
	end
	if(m_config.has_functional_coverage) begin
		m_subscriber = apb_subscriber::type_id::create("m_subscriber", this);
	end
endfunction: build_phase

function void apb_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	m_monitor.apb_index = m_config.apb_index;
	ap = m_monitor.ap;
	// Only connect the driver and the sequencer if active
	if(m_config.is_active == UVM_ACTIVE) begin
		m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
	end
	if(m_config.has_functional_coverage) begin
		ap.connect(m_subscriber.analysis_export);
	end
endfunction: connect_phase

`endif
