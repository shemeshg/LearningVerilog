
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


  int        result;
  word_t     LED_TB;
  word_t     LED_TB_comb;
  word_t     SW_TB;
  opr_mode_t SELECTOR_TB;

  select_action #() select_action_inst (
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );


  always_comb begin
    LED_TB_comb = LED_TB;
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
    end else begin
    end
  end

  task run_simulation;
    $display("Hello, World parameter value is: %0d", types_pkg::BITS);
    $display("Result: %0d", result);
    $display("LED_TB_comb: %0d", LED_TB_comb);
  endtask

  initial begin
    SELECTOR_TB = ADD;
    SW_TB = '0;
    result = add(5, 3);
    @(negedge rst);
    
    @(negedge clk);
    run_simulation;
    
    @(negedge clk);
    run_simulation;

    $finish;
  end
endmodule
