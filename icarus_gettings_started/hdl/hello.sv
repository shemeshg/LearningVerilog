module hello;
  import my_package::*; 

  task run_simulation;
    int result;
    $display("Hello, World parameter value is: %0d", my_package::MY_PARAMETER);
    result = add(5, 3); 
    $display("Result: %0d", result);
  endtask

  initial begin
      run_simulation; 
      $finish ;
  end
endmodule
