`timescale 1ns / 100ps
`include "../hdl/types_pkg.sv"

module tb_add_sub_mult;
  logic clk = 0;
  always #0.5 clk = ~clk;
  logic rst;
  initial begin
    rst = 1;
    #1;
    rst = 0;
  end

  localparam BITS = 16;
  // BITS/2 is 8 here for demonstration in error log

  logic      [BITS-1:0] LED_TB;
  logic      [BITS-1:0] SW_TB;

  logic [BITS/2-1:0] SW_LH;
  logic [BITS/2-1:0] SW_RH;
  assign SW_LH = SW_TB[BITS/2-1:0]; 
  assign SW_RH = SW_TB[BITS-1:BITS/2]; 

  opr_mode_t            SELECTOR_TB;
  add_sub_mult #() add_sub_mult_inst (
      .clk(clk),
      .rst(rst),
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );


  // This holds the result *computed* in the previous cycle, which is
  // expected to appear on LED_TB in the CURRENT cycle.
  logic [BITS-1:0] expected_result_q;


  // Use this block to sample inputs from the current cycle and predict 
  // the result for the *next* cycle (which we store in previous_* variables
  // and compute 'expected_result_q').
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      expected_result_q <= '0;
    end else begin


      // Calculate the expected result based on the inputs we just sampled.
      // We are *predicting* the output the DUT should have in the *next* cycle.
      case (SELECTOR_TB)
        ADD: expected_result_q <= SW_LH + SW_RH;
        SUB: expected_result_q <= SW_LH - SW_RH;
        MUL: expected_result_q <= SW_LH * SW_RH;
        default: expected_result_q <= '0;
      endcase
    end
  end

  initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_add_sub_mult.SW_LH);
    $dumpvars(0, tb_add_sub_mult.SW_RH);
    $dumpvars(0, tb_add_sub_mult.expected_result_q);  // Dump the expected value
    $dumpvars(0, tb_add_sub_mult.LED_TB);
    $printtimescale(tb_add_sub_mult);

    @(negedge rst);  // wait until reset is deasserted
    @(posedge clk);  // wait one more cycle to ensure DUT is ready

    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      SELECTOR_TB = ADD;
      @(posedge clk);
    end


    @(posedge clk);
    SW_TB = 0;
    $display("Time now: %0t", $time);
    $display("PASS: logic_ex test PASSED!");
    $finish;
  end


  // Assertion block runs on the positive edge of the clock, 
  // comparing the actual output (LED_TB) with the predicted value (expected_result_q)
  always @(posedge clk) begin
    // Note: The first cycle after reset will compare expected_result_q=0 (from reset) to actual=0.
    $display("At %0t: Expected = %0d, Actual (LED_TB) = %0d", $time, expected_result_q, LED_TB);

    assert (LED_TB === expected_result_q)
    else begin
      $error("Time %0t: Test FAILED! Expected %0d, got %0d. LH: %0d, RH: %0d, Selector: %s", $time,
             expected_result_q, LED_TB, SW_LH, SW_RH, SELECTOR_TB.name());
      $stop;
    end

  end
endmodule  // tb
