`timescale 1ns/ 100ps
package types_pkg;

  parameter int BITS = 16;

  typedef logic [BITS-1:0] word_t;
  typedef logic [$clog2(BITS+1)-1:0] word_log2_t;
  typedef logic [BITS/2-1:0] word_half_t;

  typedef enum bit [2:0] {
    RESET = 3'b000,
    ADD = 3'b001,
    SUB = 3'b010,
    MUL = 3'b011,
    LEADING_ONES = 3'b100,
    COUNT_ONES = 3'b101
  } opr_mode_t;

endpackage
