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




  initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_add_sub_mult.previous_SW_LH);
    $dumpvars(0, tb_add_sub_mult.previous_SW_RH);
    $dumpvars(0, tb_add_sub_mult.expected_result_d);
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

  logic [BITS/2-1:0] previous_SW_LH;
  logic [BITS/2-1:0] previous_SW_RH;

  opr_mode_t previous_SELECTOR;
  logic [BITS-1:0] expected_result_d;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      previous_SW_LH    <= '0;
      previous_SW_RH    <= '0;
      previous_SELECTOR <= ADD; // Or any default
      expected_result_d <= '0;
    end else begin
      // Use non-blocking assignments to sample inputs for next cycle's check
      previous_SW_LH    <= SW_TB[BITS/2-1:0];
      previous_SW_RH    <= SW_TB[BITS-1:BITS/2];
      previous_SELECTOR <= SELECTOR_TB;
    end

    case (SELECTOR_TB)  // Use the current TB inputs, not 'previous_' inputs
      ADD: expected_result_d <= previous_SW_LH + previous_SW_RH;
      SUB: expected_result_d <= previous_SW_LH - previous_SW_RH;
      MUL: expected_result_d <= previous_SW_LH * previous_SW_RH;
      default: expected_result_d <= '0;
    endcase
  end

  always @(posedge clk) begin
    $display("At %0t: Expected = %0d, Actual (LED_TB) = %0d", $time, expected_result_d, LED_TB);

    assert  (LED_TB === expected_result_d)
    else begin
      $error("Time %0t: Test FAILED! Expected %0d, got %0d", $time, expected_result_d, LED_TB);
    end

  end  // always @ (SW_TB)

endmodule  // tb
