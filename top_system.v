module top_system(
    input clk, rst,
    input [2:0] command,
    output [20:0] count,
    output [2:0] data_out1,
    output [11:0] data_out2
);
    wire we1, we2;
    wire [9:0] addr1, addr2;
    wire [2:0] s_reg;
    wire [11:0] c_div;
    wire [2:0] data_wb1;
    wire [11:0] data_wb2;

    wire cyc1, stb1, we_wb1, ack1;
    wire [9:0] adr_wb1;
    wire [2:0] dat_m1, dat_s1;
    
    wire cyc2, stb2, we_wb2, ack2;
    wire [9:0] adr_wb2;
    wire [11:0] dat_m2, dat_s2;

    cronometru inst_crono (
        .clk(clk), .rst(rst), .command(command), .count(count),
        .we1(we1), .addr_in1(addr1), .state_reg_out(s_reg),
        .we2(we2), .addr_in2(addr2), .count_div_out(c_div),
        .data_from_wb1(data_wb1), .data_from_wb2(data_wb2)
    );

    wb_cronometru #(.DATA_WIDTH(3)) m1 (
        .clk(clk), .rst_n(rst), .we_i(we1), .addr_i(addr1), .data_i(s_reg), .data_o(data_wb1),
        .wb_cyc(cyc1), .wb_stb(stb1), .wb_we(we_wb1), .wb_adr_o(adr_wb1),
        .wb_dat_o(dat_m1), .wb_dat_i(dat_s1), .wb_ack_i(ack1)
    );

    bram #(.ADDR_WIDTH(10), .DATA_WIDTH(3)) ram1 (
        .clk(clk),
        .we(we_wb1 && stb1),
        .addr_in(adr_wb1),
        .data_in(dat_m1),
        .data_out(dat_s1)
    );
    assign data_out1 = dat_s1;
    assign ack1 = stb1; 
    
    wb_cronometru #(.DATA_WIDTH(12)) m2 (
        .clk(clk), .rst_n(rst), .we_i(we2), .addr_i(addr2), .data_i(c_div), .data_o(data_wb2),
        .wb_cyc(cyc2), .wb_stb(stb2), .wb_we(we_wb2), .wb_adr_o(adr_wb2),
        .wb_dat_o(dat_m2), .wb_dat_i(dat_s2), .wb_ack_i(ack2)
    );

    bram #(.ADDR_WIDTH(10), .DATA_WIDTH(12)) ram2 (
        .clk(clk),
        .we(we_wb2 && stb2),
        .addr_in(adr_wb2),
        .data_in(dat_m2),
        .data_out(dat_s2)
    );
    assign data_out2 = data_wb2;
    assign ack2 = stb2;

endmodule