`timescale 1ns/1ps

module tb_unbounce_btn;

  // Testbench signals
  logic CPU_RESET;
  logic CLOCK;
  logic BTN_IN;
  logic BTN_OUT;

  // Instantiate DUT (Device Under Test)
  unbounce_btn #(.WAIT_COUNT(3)) dut (
    .CPU_RESET(CPU_RESET),
    .CLOCK(CLOCK),
    .BTN_IN(BTN_IN),
    .BTN_OUT(BTN_OUT)
  );

  // Clock generator: 10ns period
  initial begin
    CLOCK = 0;
    forever #5 CLOCK = ~CLOCK;  // 100 MHz clock
  end

  // Stimulus
  initial begin
    // Initialize
    CPU_RESET = 1;
    BTN_IN    = 0;
    #20;
    CPU_RESET = 0;

    // Hold button low (OFF)
    #50;

    // Simulate bouncing on press
    BTN_IN = 1; #10;
    BTN_IN = 0; #10;
    BTN_IN = 1; #10;
    BTN_IN = 0; #10;
    BTN_IN = 1; #50;  // finally stable high

    // Hold button high (ON)
    #100;

    // Simulate bouncing on release
    BTN_IN = 0; #10;
    BTN_IN = 1; #10;
    BTN_IN = 0; #10;
    BTN_IN = 1; #10;
    BTN_IN = 0; #50;  // finally stable low

    // Hold button low again
    #100;

    $finish;
  end

  // Monitor outputs
  initial begin
    $display("time | BTN_IN BTN_OUT");
    $monitor("%0t | BTN_IN=%b BTN_OUT=%b", $time, BTN_IN, BTN_OUT);
  end

endmodule
