`ifndef UART_TX_FIFO_SV
`define UART_TX_FIFO_SV

module uart_tx_fifo(
	input clk,
	input rstn,
	input push,
	input pop,
	input [7:0] data_in,
	output logic fifo_empty,
	output logic fifo_full,
	output logic[4:0] count,
	output logic[7:0] data_out);

logic[3:0] push_idx;
logic[3:0] pop_idx;
logic[7:0] data_fifo[15:0];

always @(posedge clk) begin
	if(rstn == 0) begin
		push_idx <= 0;
		pop_idx <= 0;
		count <= 0;
	end
	else begin
		case({push, pop})
			2'b01: begin
				if(count > 0) begin
					pop_idx <= pop_idx + 1;
					count <= count - 1;
				end
			end
			2'b10: begin
				if(count <= 5'hf) begin
					push_idx <= push_idx + 1;
					count <= count + 1;
					data_fifo[push_idx] <= data_in;
				end
			end
			2'b11: begin
				pop_idx <= pop_idx + 1;
				push_idx <= push_idx + 1;
				data_fifo[push_idx] <= data_in;
			end
		endcase
	end
end

always_comb
	data_out = data_fifo[pop_idx];

always_comb
	fifo_empty = (count == 5'h0);

always_comb
	fifo_full = (count == 5'h10);

property fifo_full_prop;
	@(posedge clk)
		fifo_full |-> (count == 5'h10);
endproperty: fifo_full_prop

property fifo_empty_prop;
	@(posedge clk)
		fifo_empty |-> (count == 5'h0);
endproperty: fifo_empty_prop

property fifo_neither;
	@(posedge clk)
	(!fifo_full && !fifo_empty) |-> ((count > 5'h0) && (count < 5'h10));
endproperty: fifo_neither

TX_FIFO_FULL_CHK: assert property(fifo_full_prop);
TX_FIFO_EMPTY_CHK: assert property(fifo_empty_prop);
TX_FIFO_OK_CHK: assert property(fifo_neither);

endmodule: uart_tx_fifo

`endif
