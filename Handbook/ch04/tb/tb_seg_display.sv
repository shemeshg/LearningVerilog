`timescale 1ns / 10ps
import types_pkg::*;
module tb_seg_display;

  word_t bin;
  logic [DIGITS*4-1:0] bcd;
  bin_to_bcd bin_to_bcd_module (
      .bin(bin),
      .bcd(bcd)
  );

  logic [3:0] encoded;
  byte_t cathode;
  dec_cat_map dec_cat_map_module (
      .encoded(encoded),
      .cathode(cathode)
  );
  display_t display;

  initial begin
    bin = 16'd0;

    #1000
    for (int i = 0; i < DIGITS; i++) begin
      encoded = bcd[i*4+:4];
      #1;  // wait one timestep for cathode to update
      display[i] = cathode;
      $display("digit[%0d] = %0d", i, bcd[i*4+:4]);
    end

    /*
    foreach (display[i]) begin
      display[i] = 8'hFF;  // 11111111
    end
    */
    #1000

    foreach (display[i]) begin
      $display("%08b %b", 8'b1 << i, display[i]);
    end


  end

endmodule
