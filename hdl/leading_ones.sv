`timescale 1ns/ 100ps

module leading_ones #
    (
        parameter BITS      = 16
    )
    (
        input logic clk,
        input logic rst,
        input [BITS-1:0]       SW,
        output logic [$clog2(BITS+1)-1:0] LED
    );

function automatic logic [$clog2(BITS+1)-1:0] leading_ones_fn(input logic [BITS-1:0] vec);
    for (int i = $high(vec); i >= $low(vec); i--) begin
        if (vec[i]) begin
            return i;
        end
    end
    return 0;
endfunction


    always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        LED <= 0;
    end else begin
        logic [$clog2(BITS+1)-1:0] result;
        result = leading_ones_fn(SW);
        LED <= result;
        $display("DUT IS @%0t: SW = %h, computed = %0d", $time, SW, result);
    end
    end

endmodule