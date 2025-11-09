`timescale 1ns/ 100ps
package types_pkg;

  parameter int BITS = 16;

  typedef logic [BITS-1:0] word_t;

  typedef enum bit [1:0] {
    ADD = 2'b00,
    SUB = 2'b01,
    MUL = 2'b10
  } opr_mode_t;

endpackage
