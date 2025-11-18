
module hello;
  import types_pkg::*;

  logic clk = 0;
  always #0.5 clk = ~clk;
  logic rst;
  initial begin
    rst = 1;
    #1;
    rst = 0;
  end


  localparam BITS = 16;

  word_t     LED_TB;
  word_t     LED_TB_comb;
  word_t     expected_result_comb;
  word_t     SW_TB;
  opr_mode_t SELECTOR_TB;

  select_action #() select_action_inst (
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );

  word_half_t SW_LH;
  word_half_t SW_RH;
  assign SW_LH = SW_TB[BITS/2-1:0];
  assign SW_RH = SW_TB[BITS-1:BITS/2];
  always_comb begin
    LED_TB_comb = LED_TB;
    case (SELECTOR_TB)
      RESET: expected_result_comb = '0;
      ADD: expected_result_comb = SW_LH + SW_RH;
      SUB: expected_result_comb = SW_LH - SW_RH;
      MUL: expected_result_comb = SW_LH * SW_RH;
      //LEADING_ONES: expected_result_comb = expected_leading_ones;
      //COUNT_ONES: expected_result_comb = expected_count;
      default: expected_result_comb = '0;
    endcase
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
    end else begin
    end
  end

  task run_simulation;
    $display("Hello, World parameter value is: %0d", types_pkg::BITS);
    $display("LED_TB_comb: %0d", LED_TB_comb);
    $display("Time %0t: Expected %0d, got %0d. LH: %0d, RH: %0d, Selector: %s", $time,
             expected_result_comb, LED_TB, SW_LH, SW_RH, SELECTOR_TB.name());
  endtask

  initial begin
    SELECTOR_TB = ADD;
    SW_TB = '0;
    @(negedge rst);

    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
      run_simulation;
    end


    $finish;
  end
endmodule
