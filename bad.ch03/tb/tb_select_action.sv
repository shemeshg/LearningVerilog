`timescale 1ns / 100ps
`include "../hdl/types_pkg.sv"
import types_pkg::*;

module tb_select_action;

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

  select_action #() select_action_inst (
      .clk(clk),
      .rst(rst),
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );

  word_half_t SW_LH;
  word_half_t SW_RH;
  assign SW_LH = SW_TB[BITS/2-1:0];
  assign SW_RH = SW_TB[BITS-1:BITS/2];



  word_t expected_result_comb;
  word_half_t SW_LH_q;
  word_half_t SW_RH_q;
  word_t SW_TB_q;
  always_comb begin
    automatic int expected_count = 0;
    automatic int expected_leading_ones = 0;
    for (int i = 0; i < BITS; i++) begin
      expected_count += SW_TB_q[i];
    end

    
    for (int i = 0; i < BITS; i++) begin
      if (SW_TB_q[i] == 1) begin
        expected_leading_ones = i;
      end
    end

    case (SELECTOR_TB)
      RESET: expected_result_comb = '0;
      ADD: expected_result_comb = SW_LH_q + SW_RH_q;
      SUB: expected_result_comb = SW_LH_q - SW_RH_q;
      MUL: expected_result_comb = SW_LH_q * SW_RH_q;
      LEADING_ONES: expected_result_comb = expected_leading_ones;
      COUNT_ONES: expected_result_comb = expected_count;
      default: expected_result_comb = '0;
    endcase
  end

  word_t expected_result_q;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      expected_result_q <= '0;
      SW_LH_q <= '0;
      SW_RH_q <= '0;
      SW_TB_q <= '0;
    end else begin

      expected_result_q <= expected_result_comb;
      SW_LH_q <= SW_LH;
      SW_RH_q <= SW_RH;
      SW_TB_q <= SW_TB;
    end
  end

  initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_select_action.SW_LH_q);
    $dumpvars(0, tb_select_action.SW_RH_q);
    $dumpvars(0, tb_select_action.expected_result_q);
    $dumpvars(0, tb_select_action.LED_TB);
    $printtimescale(tb_select_action);

    @(negedge rst);
    @(negedge clk);

    SELECTOR_TB = ADD;
    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
    end


    SELECTOR_TB = SUB;
    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
    end

    SELECTOR_TB = MUL;
    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
    end

    SELECTOR_TB = COUNT_ONES;
    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
    end

    SELECTOR_TB = LEADING_ONES;
    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
    end

    @(posedge clk);
    SW_TB = 0;
    $display("Time now: %0t", $time);
    $display("PASS: logic_ex test PASSED!");
    $finish;
  end

  always @(posedge clk) begin
    $display("At %0t: Expected = %0d, Actual (LED_TB) = %0d", $time, expected_result_q, LED_TB);

    if (!$isunknown(LED_TB) && !$isunknown(expected_result_q)) begin

      assert (LED_TB === expected_result_q)
      else begin
        $error("Time %0t: Test FAILED! Expected %0d, got %0d. LH: %0d, RH: %0d, Selector: %s",
               $time, expected_result_q, LED_TB, SW_LH, SW_RH, SELECTOR_TB.name());
        //$stop;
      end
    end else begin
      $info("Time %0t: Test unknown (X/Z) values! LED_TB: %h, Expected: %h", $time, LED_TB,
            expected_result_q);
    end

  end

endmodule
