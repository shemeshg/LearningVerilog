`timescale 1ns / 10ps
import types_pkg::*;
module tb_seg_display;

  word_t bin;
  logic [DIGITS*4-1:0] bcd;
  bin_to_bcd bin_to_bcd_module (
      .bin(bin),
      .bcd(bcd)
  );

  display_t display;

  initial begin
    bin = 16'd2091;

    foreach (display[i]) begin
      display[i] = 8'hFF;  // 11111111
    end


    foreach (display[i]) begin
      $display("%08b %b", 8'b1 << i, display[i]);
    end

    #1000
    for (int i = 0; i < DIGITS; i++) begin
      // slice out 4 bits for digit i
      $display("digit[%0d] = %0d", i, bcd[i*4+:4]);
    end
  end

endmodule
