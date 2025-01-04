`ifndef UART_RX_FIFO_SV
`define UART_RX_FIFO_SV

module uart_rx_fifo(
	input clk,
	input rstn,
	input push,
	input pop,
	input [10:0] data_in,
	output logic fifo_empty,
	output logic fifo_full,
	output logic[4:0] count,
	output logic[10:0] data_out);

logic[3:0] push_idx;
logic[3:0] pop_idx;
typedef logic[10:0] fifo_t;

fifo_t data_fifo[15:0];

always @(posedge clk) begin
	if(rstn == 0) begin
		push_idx <= 0;
		pop_idx <= 0;
		count <= 0;
		foreach(data_fifo[i]) begin
			data_fifo[i] = 0;
		end
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

endmodule: uart_rx_fifo

`endif
