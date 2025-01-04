`ifndef APB_INTERFACE_SVH
`define APB_INTERFACE_SVH

interface apb_interface #(type T = logic[31:0])
	(input PCLK, input PRESETn);
	T PADDR;
	T PRDATA;
	T PWDATA;
	logic[15:0] PSEL; // Only connect the ones that are needed
	logic PENABLE;
	logic PWRITE;
	logic PREADY;
	logic PSLVERR;
	
	clocking drv_cb @(posedge PCLK);
		output PADDR;
		output PWDATA;
		output PSEL;
		output PENABLE;
		output PWRITE;
		input PRESETn;
		input PRDATA;
		input PREADY;
		input PSLVERR;
	endclocking
	
	clocking mon_cb @(posedge PCLK);
		input PADDR;
		input PWDATA;
		input PSEL;
		input PENABLE;
		input PWRITE;
		input PRESETn;
		input PRDATA;
		input PREADY;
		input PSLVERR;
	endclocking


	property psel_valid;
		@(posedge PCLK)
		!$isunknown(PSEL);
	endproperty

	CHK_PSEL: assert property(psel_valid);
	COVER_PSEL: cover property(psel_valid);
endinterface

`endif
