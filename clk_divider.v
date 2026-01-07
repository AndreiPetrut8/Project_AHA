module clk_divider #(parameter N=25000000)
			(
			input clk, rst,
			output reg clk_div
			);
	reg [25:0]cnt_reg, cnt_nxt;

	always @(posedge clk or negedge rst) 
	begin
		if(~rst) begin
			cnt_reg <= 0;
			clk_div <= 0;
		end
		else begin
			cnt_reg <= cnt_nxt;
			if(cnt_reg == N) 
			begin
				clk_div <= ~clk_div;
				cnt_reg <= 0;
			end
			
		end	
	end


	always @(cnt_reg) 
	begin 	
		
		cnt_nxt = cnt_reg + 1;
	end

endmodule
