module bram #(parameter ADDR_WIDTH = 10, parameter DATA_WIDTH = 8)(
	input clk, we,
	input [ADDR_WIDTH - 1 : 0] addr_in,
	input [DATA_WIDTH - 1 : 0] data_in,
	output [DATA_WIDTH - 1 : 0] data_out
);

reg [DATA_WIDTH - 1: 0] ram [2**ADDR_WIDTH - 1 : 0];

always @ (posedge clk) begin
	if(we) begin
		ram[addr_in] <= data_in;
	end
	
end

assign data_out = ram[addr_in];

endmodule
