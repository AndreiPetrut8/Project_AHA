module wb_cronometru #(parameter ADDR_WIDTH = 10, DATA_WIDTH = 8) (
    input clk,
    input rst_n,
    input we_i,
    input [ADDR_WIDTH-1:0] addr_i,
    input [DATA_WIDTH-1:0] data_i,
    output [DATA_WIDTH-1:0] data_o,
    output reg wb_cyc,
    output reg wb_stb,
    output reg wb_we,
    output reg [ADDR_WIDTH-1:0] wb_adr_o,
    output reg [DATA_WIDTH-1:0] wb_dat_o,
    input [DATA_WIDTH-1:0] wb_dat_i,
    input wb_ack_i
);

    reg [1:0] state = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            wb_cyc <= 0;
            wb_stb <= 0;
        end else begin
            case (state)
                2'b00: begin
                    state <= 2'b01;
                end

                2'b01: begin
                    wb_cyc <= 1;
                    wb_stb <= 1;
                    wb_we  <= we_i;
                    wb_adr_o <= addr_i;
                    wb_dat_o <= data_i;
                    state <= 2'b10;
                end

                2'b10: begin
                    if (wb_ack_i) begin
                        wb_stb <= 0;
                        wb_cyc <= 0;
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end

    assign data_o = wb_dat_i;
endmodule
