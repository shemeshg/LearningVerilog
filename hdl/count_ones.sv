`timescale 1ns/ 100ps

module count_ones #
    (
        parameter BITS      = 16
    )
    (
        input logic clk,
        input logic rst,
        input [BITS-1:0]       SW,
        output logic [$clog2(BITS+1)-1:0] LED
    );

    function automatic logic [$clog2(BITS+1)-1:0] count_ones_fn(input logic [BITS-1:0] vec);
        logic [$clog2(BITS+1)-1:0] count = 0;
        for (int i = 0; i < BITS; i++) begin
            count = count + vec[i];
        end
        return count;
    endfunction

    always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        LED <= 0;
    end else begin
        logic [$clog2(BITS+1)-1:0] result;
        result = count_ones_fn(SW);
        LED <= result;
        $display("DUT IS @%0t: SW = %h, computed = %0d", $time, SW, result);
    end
    end

endmodule