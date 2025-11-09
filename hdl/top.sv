module top (
    input wire CLK100MHZ,
    input wire CPU_RESETN,
    input wire [15:0] SW,
    output wire [3:0] LED
);

    wire rst;
    assign rst = ~CPU_RESETN;

/*
    wire [4:0] count;

    count_ones #(.BITS(16)) u_count_ones (
        .clk(CLK100MHZ),
        .rst(rst),
        .SW(SW),
        .LED(count)
    );

    assign LED = count[3:0];
*/

    count_ones #(.BITS(16)) u_count_ones (
        .clk(CLK100MHZ),
        .rst(rst),
        .SW(SW),
        .LED(LED)
    );

endmodule
