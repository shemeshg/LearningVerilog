`timescale 1ns/ 100ps
`include "types_pkg.sv"
import types_pkg::*;

module leading_ones #
    (
        parameter BITS      = 16
    )
    (
        input logic clk,
        input logic rst,
        input [BITS-1:0]       SW,
        output word_log2_t LED
    );

function automatic word_log2_t leading_ones_fn(input word_t vec);
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
        word_log2_t result;
        result = leading_ones_fn(SW);
        LED <= result;
        $display("DUT IS @%0t: SW = %h, computed = %0d", $time, SW, result);
    end
    end

endmodule