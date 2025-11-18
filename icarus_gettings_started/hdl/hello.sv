
module hello;
  event updated;
  import types_pkg::*;

  
  localparam BITS = 16;


  int result;
  word_t LED_TB;
  word_t SW_TB;
  opr_mode_t            SELECTOR_TB;

  select_action #() select_action_inst (
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );
  always_comb begin
    result = add(5, 3);
    -> updated; 
  end


  task run_simulation;
    $display("Hello, World parameter value is: %0d", types_pkg::BITS);    
    $display("Result: %0d", result);
    $display("LED_TB: %0d", LED_TB);
  endtask

  initial begin
    SELECTOR_TB = ADD;
    SW_TB = '0;
    @updated; 
    run_simulation;
    $finish;
  end
endmodule
