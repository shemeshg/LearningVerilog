`timescale 1ns / 100ps
`include "types_pkg.sv"
import types_pkg::*;

module select_action #(
) (
    input  logic      clk,
    input  logic      rst,
    input  opr_mode_t SELECTOR,
    input  word_t     SW,
    output word_t     LED
);

word_t result;

word_t      add_sub_mult_LED;
  add_sub_mult #() add_sub_mult_inst (
      .clk(clk),
      .rst(rst),
      .SELECTOR(SELECTOR),
      .SW(SW),
      .LED(add_sub_mult_LED)
  );

word_log2_t      count_ones_LED;
count_ones #(.BITS(BITS)) count_ones_inst(
    .clk(clk),
    .rst(rst),
    .SW(SW),
    .LED(count_ones_LED)
);

word_log2_t      leading_ones_LED;
leading_ones #(.BITS(BITS)) leading_ones_inst(
    .clk(clk),
    .rst(rst),
    .SW(SW),
    .LED(leading_ones_LED)
);

  word_half_t SW_LH;
  word_half_t SW_RH;
  assign SW_LH = SW[BITS/2-1:0]; 
  assign SW_RH = SW[BITS-1:BITS/2]; 

  word_t result_comb;
  always_comb begin
    case (SELECTOR)
      RESET: result_comb = '0;
      ADD:   result_comb = add_sub_mult_LED;
      SUB:   result_comb = add_sub_mult_LED;
      MUL:   result_comb = add_sub_mult_LED;
      LEADING_ONES: result_comb = leading_ones_LED;
      COUNT_ONES: result_comb = count_ones_LED;
      default: result_comb = '0;
    endcase
  end


  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      LED <= 0;
    end else begin      
      LED <= result_comb;
      $display("DUT selection_action IS @%0t: SW = %h, RH = %0d, LH = %0d, computed = %0d", $time, SW, SW_RH, SW_LH,
               result_comb);
    end
  end

endmodule
