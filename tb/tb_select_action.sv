`timescale 1ns / 100ps
`include "../hdl/types_pkg.sv"

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
  always_comb begin
    case (SELECTOR_TB)
      RESET: expected_result_comb = '0;
      ADD:   expected_result_comb = SW_LH_q + SW_RH_q;
      SUB:   expected_result_comb = SW_LH_q - SW_RH_q;
      MUL:   expected_result_comb = SW_LH_q * SW_RH_q;
      default: expected_result_comb = '0;
    endcase
  end

  word_t expected_result_q;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      expected_result_q <= '0;
      SW_LH_q <= '0;
      SW_RH_q <= '0;
    end else begin

      expected_result_q <=expected_result_comb;
      SW_LH_q <= SW_LH;
      SW_RH_q <= SW_RH;
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

    repeat (6) begin
      SW_TB = $urandom_range(0, (1 << BITS) - 1);
      SELECTOR_TB = ADD;
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

    assert (LED_TB === expected_result_q)
    else begin
      $error("Time %0t: Test FAILED! Expected %0d, got %0d. LH: %0d, RH: %0d, Selector: %s", $time,
             expected_result_q, LED_TB, SW_LH, SW_RH, SELECTOR_TB.name());
      //$stop;
    end

  end

endmodule  
