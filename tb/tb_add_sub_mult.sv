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
  opr_mode_t            SELECTOR_TB;
  add_sub_mult #() add_sub_mult_inst (
      .clk(clk),
      .rst(rst),
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );


  // Variables to hold the inputs that were present in the PREVIOUS cycle
  // This is what the DUT is CURRENTLY processing internally.
  logic [BITS/2-1:0] previous_SW_LH;
  logic [BITS/2-1:0] previous_SW_RH;
  opr_mode_t previous_SELECTOR;
  // This holds the result *computed* in the previous cycle, which is
  // expected to appear on LED_TB in the CURRENT cycle.
  logic [BITS-1:0] expected_result_q;


  // Use this block to sample inputs from the current cycle and predict 
  // the result for the *next* cycle (which we store in previous_* variables
  // and compute 'expected_result_q').
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      previous_SW_LH    <= '0;
      previous_SW_RH    <= '0;
      previous_SELECTOR <= ADD; // Or any default
      expected_result_q <= '0;
    end else begin
      // Sample the inputs presented during this clock edge
      previous_SW_LH    <= SW_TB[BITS/2-1:0]; // The LH bits (0-7)
      previous_SW_RH    <= SW_TB[BITS-1:BITS/2]; // The RH bits (8-15)
      previous_SELECTOR <= SELECTOR_TB;

      // Calculate the expected result based on the inputs we just sampled.
      // We are *predicting* the output the DUT should have in the *next* cycle.
      case (SELECTOR_TB) 
        ADD: expected_result_q <= SW_TB[BITS/2-1:0] + SW_TB[BITS-1:BITS/2];
        SUB: expected_result_q <= SW_TB[BITS/2-1:0] - SW_TB[BITS-1:BITS/2];
        MUL: expected_result_q <= SW_TB[BITS/2-1:0] * SW_TB[BITS-1:BITS/2];
        default: expected_result_q <= '0;
      endcase
    end
  end

  initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_add_sub_mult.previous_SW_LH);
    $dumpvars(0, tb_add_sub_mult.previous_SW_RH);
    $dumpvars(0, tb_add_sub_mult.expected_result_q); // Dump the expected value
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

    assert  (LED_TB === expected_result_q)
    else begin
      $error("Time %0t: Test FAILED! Expected %0d, got %0d. (Previous LH: %0d, Previous RH: %0d, Selector: %s)", 
             $time, expected_result_q, LED_TB, previous_SW_LH, previous_SW_RH, previous_SELECTOR.name());
      $stop; 
    end

  end
endmodule  // tb
