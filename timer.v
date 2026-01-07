module timer(
	input clk, rst, e,
	output [11:0] count
);

	reg [6:0]count_reg1, count_nxt1;
	reg [3:0] count_reg2, count_nxt2;
	

	

	always @(posedge clk or negedge rst)
	begin
		
		if(~rst) begin
			count_reg1 <= 0;
			count_reg2 <= 0;
		end
		else begin
			count_reg1 <= count_nxt1;
			count_reg2 <= count_nxt2;
				
		end
	end

	always @(count_reg1) 
	begin
		count_nxt1 = count_reg1;
		count_nxt2 = count_reg2;
		if(e) begin
			if(count_reg1 == 59)
			begin
				count_nxt1 = 0;
				count_nxt2 = count_reg2 + 1;
			
			end
			else
			begin
				count_nxt1 = count_reg1 + 1;
				count_nxt2 = count_reg2;
			end
		end
	end

	assign count = {count_reg2, count_reg1};
endmodule
