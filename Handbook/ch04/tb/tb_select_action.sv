`timescale 1ns/10ps
module tb_select_action;
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
    case (SELECTOR_TB)
      RESET: expected_result_comb = '0;
      ADD: expected_result_comb = SW_LH + SW_RH;
      SUB: expected_result_comb = SW_LH - SW_RH;
      MUL: expected_result_comb = SW_LH * SW_RH;
      LEADING_ONES: expected_result_comb = leading_ones_fn(SW_TB);
      COUNT_ONES: expected_result_comb = count_ones_fn(SW_TB);
      default: expected_result_comb = '0;
    endcase
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
    end else begin
    end
  end

  task run_simulation;
    $display("Time %0t , sw: %b: Expected %0d, got %0d. LH: %0d, RH: %0d, Selector: %s", $time, SW_TB,
             expected_result_comb, LED_TB, SW_LH, SW_RH, SELECTOR_TB.name());
    assert (LED_TB === expected_result_comb)
    else begin
      $error("Time %0t: Test FAILED! ", $time);
      $finish;

    end
  endtask

  integer pos=0;
  initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_select_action.SW_TB);    
    $dumpvars(0, tb_select_action.LED_TB);   
    $dumpvars(0, tb_select_action.SW_LH);   
    $dumpvars(0, tb_select_action.SW_RH);   
    $dumpvars(0, tb_select_action.SELECTOR_TB);   

    $printtimescale(tb_select_action);

    SELECTOR_TB = RESET;
    SW_TB = '0;
    
    @(negedge rst);

    repeat (6) begin
      SELECTOR_TB = ADD;
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
      run_simulation;
    end

    repeat (6) begin
      SELECTOR_TB = SUB;
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
      run_simulation;
    end

    repeat (6) begin
      SELECTOR_TB = MUL;
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
      run_simulation;
    end

    
    repeat (6) begin
      SELECTOR_TB = LEADING_ONES;
       pos = $urandom_range(0, BITS - 1);
      SW_TB = 0;
      while (pos >= 0) begin
        SW_TB = SW_TB | (1 << pos);
        if (pos == 0) begin
          pos = -1;  // force exit instead of disable/break
        end else begin
          pos = $urandom_range(0, pos - 1);
        end
      end

      @(negedge clk);
      run_simulation;
    end

    repeat (6) begin
      SELECTOR_TB = COUNT_ONES;
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      @(negedge clk);
      run_simulation;
    end

    $finish;
  end
endmodule
