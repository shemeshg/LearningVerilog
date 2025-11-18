module hello;
  import types_pkg::*;

  task run_simulation;
    int result;
    $display("Hello, World parameter value is: %0d", types_pkg::BITS);
    result = add(5, 3);
    $display("Result: %0d", result);
  endtask

  initial begin
    run_simulation;
    $finish;
  end
endmodule
