module tb_top_system;

    reg clk;
    reg rst;
    reg [2:0] command;

    wire [20:0] count;
    wire [2:0]  data_out1;
    wire [11:0] data_out2;

    top_system DUT (
        .clk(clk),
        .rst(rst),
        .command(command),
        .count(count),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 0;
        command = 3'b000;

        #10;
        rst = 1;
        #50;
        rst = 0;  
        #20;
        rst = 1; 

        #20;
        command = 3'b001; 
        #20;
        command = 3'b000;
        
        #100; 

        command = 3'b010; 
        #20;
        command = 3'b000; 

        #40;

        command = 3'b111; 
        #20;
        command = 3'b000;

        #40;

        command = 3'b100; 
        #20;
        command = 3'b000;

        #100;
        $stop; 
    end

    initial begin
        $display("Time\tRST CMD COUNT DATA1 DATA2");
        $monitor("%0t\t%b   %b  %h   %b   %h", 
                 $time, rst, command, count, data_out1, data_out2);
    end

endmodule
