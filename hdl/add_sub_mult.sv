`timescale 1ns / 100ps
`include "types_pkg.sv"

import types_pkg::*;

module add_sub_mult #() (
    input  logic                           clk,
    input  logic                           rst,
    input  opr_mode_t                      SELECTOR,
    input  word_t SW,
    output word_t LED
);
   
  logic [BITS/2-1:0] SW_LH;
  logic [BITS/2-1:0] SW_RH;

  assign SW_LH = SW[BITS/2-1:0];
  assign SW_RH = SW[BITS-1:BITS/2];



  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      LED <= 0;
    end else begin
      word_t result;

      case (SELECTOR)
        ADD: result = SW_LH + SW_RH;
        SUB: result = SW_LH - SW_RH;
        MUL: result = SW_LH * SW_RH;
        default: result = '0;
      endcase


      LED <= result;
      $display("DUT IS @%0t: SW = %h, RH = %0d, LH = %0d, computed = %0d", $time, SW, SW_RH, SW_LH,
               result);
    end
  end

endmodule
