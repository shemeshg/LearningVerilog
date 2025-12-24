`timescale 1ns / 10ps
import types_pkg::*;

module bin_to_bcd #(
    parameter int DIGITS = 8,     // number of BCD digits
    parameter int BITS   = 32     // width of binary input
)(
    input  logic [BITS-1:0] bin,
    output logic [DIGITS*4-1:0] bcd
);

  integer i, j;
  logic [DIGITS*4-1:0] temp;
  logic [BITS-1:0]     bin_work;

  int first_used;
  bit found;

  always_comb begin
    bin_work = bin;

    // Initialize BCD digits to 0
    for (j = 0; j < DIGITS; j++)
      temp[j*4 +: 4] = 4'd0;

    // Double dabble
    for (i = BITS - 1; i >= 0; i--) begin

      // Add 3 if >= 5
      for (j = 0; j < DIGITS; j++)
        if (temp[j*4 +: 4] >= 5)
          temp[j*4 +: 4] += 3;

      // Shift left
      {temp, bin_work} = {temp, bin_work} << 1;
    end

    bcd = temp;

    // Find highest used digit
    first_used = DIGITS;
    found = 0;

    for (j = DIGITS - 1; j >= 0; j--) begin
      if (!found && bcd[j*4 +: 4] != 0) begin
        first_used = j + 1;
        found = 1;
      end
    end

    if (!found) begin
      // Special case: number is zero
      bcd[0 +: 4] = 4'd0;
      for (j = 1; j < DIGITS; j++)
        bcd[j*4 +: 4] = 4'd10;
    end else begin
      // Mark unused digits with 10
      for (j = 0; j < DIGITS; j++)
        if (j >= first_used)
          bcd[j*4 +: 4] = 4'd10;
    end
  end

endmodule
