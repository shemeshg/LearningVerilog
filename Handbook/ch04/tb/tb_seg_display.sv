`timescale 1ns / 10ps
import types_pkg::*;
module tb_seg_display;
   

  display_t display;

  initial begin

    foreach (display[i]) begin
      display[i] = 8'hFF;  // 11111111
    end


    foreach (display[i]) begin
      $display("%08b %b", 8'b1 << i, display[i]);
    end
  end

endmodule
