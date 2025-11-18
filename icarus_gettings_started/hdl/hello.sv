
module hello;
  event updated;
  import types_pkg::*;
  int result;
  
  always_comb begin
    result = add(5, 3);
    -> updated; 
  end


  task run_simulation;
    $display("Hello, World parameter value is: %0d", types_pkg::BITS);    
    $display("Result: %0d", result);
  endtask

  initial begin
    @updated; 
    run_simulation;
    $finish;
  end
endmodule
