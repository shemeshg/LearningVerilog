`timescale 1ns / 10ps
module tb_emulator;
  import types_pkg::*;

  logic clk = 0;
  // Clock generator runs forever
  always #100 clk = ~clk;

  logic rst;
  initial begin
    rst = 1;
    #1;
    rst = 0;
  end

  localparam BITS = 16;

  word_t     LED_TB;
  word_t     SW_TB;
  opr_mode_t SELECTOR_TB;

  select_action #() select_action_inst (
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );



  always @(posedge clk or posedge rst) begin
    if (rst) begin
    end else begin
      #1000000000;
      #10ns;
      $display("Time %0t | SW_TB: %b | Selector: %s | LED_TB: %0d", $time, SW_TB,
               SELECTOR_TB.name(), LED_TB);
      $fflush(32'h80000001);

    end
  end

  // Stimulus Generation Block (Runs once to set initial state, then finishes its own execution)
  initial begin

    @(negedge rst);

    // Set a default mode
    SELECTOR_TB = ADD;
    SW_TB = 16'd0;

  end


endmodule
