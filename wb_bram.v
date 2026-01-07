module wb_bram #(parameter ADDR_WIDTH = 10, DATA_WIDTH = 8) (
    input wb_clk_i,
    input wb_rst_i,
    input [ADDR_WIDTH-1:0] wb_adr_i,
    input [DATA_WIDTH-1:0] wb_dat_i,
    output [DATA_WIDTH-1:0] wb_dat_o,
    input wb_we_i,
    input wb_stb_i,
    input wb_cyc_i,
    output reg wb_ack_o
);
    bram #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) internal_ram (
        .clk(wb_clk_i),
        .we(wb_we_i && wb_stb_i && wb_cyc_i),
        .addr_in(wb_adr_i),
        .data_in(wb_dat_i),
        .data_out(wb_dat_o)
    );

    always @(posedge wb_clk_i or negedge wb_rst_i) begin
        if (!wb_rst_i) wb_ack_o <= 1'b0;
        else wb_ack_o <= wb_stb_i && wb_cyc_i && !wb_ack_o;
    end
endmodule
