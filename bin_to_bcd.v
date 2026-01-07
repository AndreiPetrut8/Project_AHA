module bin_to_bcd #(parameter n = 6) (
	input [n-1:0]bin,
	output [n:0]bcd
);

integer i;
reg [n:0] bcd_out;
always @ (bin) begin
	bcd_out=0;
	for(i = 0; i <= n-1; i=i+1) 
	begin
		bcd_out = {bcd_out[n-1:0], bin[n-1-i]};
		if((bcd_out[3:0] > 4'b0100) && (i != n-1)) begin
			bcd_out[3:0] = bcd_out[3:0] + 4'b0011;
		end
		if((bcd_out[n:4] > 4'b0100) && (i != n-1)) begin
			bcd_out[n:4] = bcd_out[n:4] + 4'b0011;
		end
		
		
	end
	
end

assign bcd = bcd_out;

endmodule
