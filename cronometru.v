module cronometru(input clk, rst, input [2:0] command, output [20:0] count,
    output reg we1, 
    output [9:0] addr_in1,
    output [2:0] state_reg_out,
    output reg we2,
    output [9:0] addr_in2,
    output [11:0] count_div_out,
    input [2:0] data_from_wb1,
    input [11:0] data_from_wb2
);

	reg en, r;
	reg [9:0] addr_in1_reg = 0;
	reg [9:0] addr_in2_reg = 0;
	wire clk_div;
	wire [11:0] count_div;
	wire [6:0] h1, h2, h3;
	wire [6:0] bcd_out1;
	wire [4:0] bcd_out2;

	reg [2:0] state_reg, state_next;


	clk_divider #(.N(25000000)) a(
		.clk(clk),
		.rst(rst),
		.clk_div(clk_div)

	);

	timer b(
		.clk(clk_div),
		.rst(rst & r),
		.e(en),
		.count(count_div)
	);

	bin_to_bcd #(.n(6)) bb(
		.bin(count_div[5:0]),
		.bcd(bcd_out1)
	);

	bin_to_bcd #(.n(4)) bc(
		.bin(count_div[10:7]),
		.bcd(bcd_out2)
	);

	hex c(
		.x(bcd_out1[3:0]),
		.h(h1)
	);

	hex d(
		.x({1'b0, bcd_out1[6:4]}),
		.h(h2)
	);

	hex e(
		.x(bcd_out2[3:0]),
		.h(h3)
	);



	assign state_reg_out = state_reg;
  assign count_div_out = count_div;
  assign addr_in1 = addr_in1_reg;
  assign addr_in2 = addr_in2_reg;
	
	always @ (posedge clk or negedge rst) begin

		if(!rst) begin
			state_reg <= 0;	
		end
		else begin
			state_reg <= state_next;
		end
	end

	always @ (command or state_reg) begin
		r = 1;
		en = 0;
		state_next = state_reg;
		case (state_reg)
			3'b000:begin
				if(command == 3'b001) begin
					state_next = 3'b001;
					en = 1;
				end
			end
			3'b001:begin
				en = 1;
				if(command == 3'b010) begin
					state_next = 3'b010;
					en = 0;
				end
				if(command == 3'b100) begin
					state_next = 3'b011;
					addr_in2_reg = addr_in2_reg + 1;
					we2 = 1;
					en = 0;
				end
				if(command == 3'b111) begin
					state_next = 3'b100;
					addr_in1_reg = addr_in1_reg + 1;
					we1 = 1;
				end
			end
			3'b010:begin
				if(command == 3'b001) begin
					state_next = 3'b001;
					en = 1;
				end
				if(command == 3'b100) begin
					state_next = 3'b011;
					en = 0;
				end
				if(command == 3'b111) begin
					state_next = 3'b100;
					addr_in1_reg = addr_in1_reg + 1;
					we1 = 1;
				end
			end
			3'b011:begin
				we2 = 0;
				if(command == 3'b001) begin
					state_next = 3'b001;
					en = 1;
					r = 0;
				end
				if(command == 3'b111) begin
					state_next = 3'b100;
					addr_in1_reg = addr_in1_reg + 1;
					en = 1;
					we1 = 1;
				end
			end
			3'b100:begin
				we1 = 0;
				if(command == 3'b001) begin
					state_next = 3'b001;
					en = 1;
					r = 0;
				end
				if(command == 3'b010) begin
					state_next = 3'b010;
					en = 0;
				end
				if(command == 3'b100) begin
					state_next = 3'b011;
					en = 0;
				end
			end
		endcase
	end

	assign count = {h3, h2, h1};

endmodule
