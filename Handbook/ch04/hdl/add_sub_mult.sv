`timescale 1ns / 10ps
import types_pkg::*;

module add_sub_mult (
    input  opr_mode_t SELECTOR,
    input  word_t     SW,
    output word_t     LED
);
  word_t result_comb;
  word_half_t SW_LH;
  word_half_t SW_RH;

  assign SW_LH = SW[BITS/2-1:0];
  assign SW_RH = SW[BITS-1:BITS/2];

  always_comb begin
    case (SELECTOR)
      ADD:     result_comb = SW_LH + SW_RH;
      SUB:     result_comb = SW_LH - SW_RH;
      MUL:     result_comb = SW_LH * SW_RH;
      default: result_comb = '0;
    endcase
    LED = result_comb;
  end

endmodule
