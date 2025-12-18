`timescale 1ns / 1ps






module tb_emulator;
  import types_pkg::*;

  // Testbench signals
  logic rst;
  logic clk;
  logic BTNU;
  logic BTND;
  logic BTNR;
  logic BTNL;
  logic BTNC;
  word_t SW;
  int calc_displayed;
  logic isEdit;


  // Instantiate DUT (Device Under Test)
  // Will be moved to file

  int total;
  always_comb begin
    if (isEdit) calc_displayed = int'(SW);
    else calc_displayed = total;
  end

  logic rise_u, rise_d, rise_r, rise_l, rise_c;

  edge_detect ed_u (
      .clk (clk),
      .rst (rst),
      .sig (BTNU),
      .rise(rise_u)
  );

  edge_detect ed_d (
      .clk (clk),
      .rst (rst),
      .sig (BTND),
      .rise(rise_d)
  );

  edge_detect ed_r (
      .clk (clk),
      .rst (rst),
      .sig (BTNR),
      .rise(rise_r)
  );

  edge_detect ed_l (
      .clk (clk),
      .rst (rst),
      .sig (BTNL),
      .rise(rise_l)
  );

  edge_detect ed_c (
      .clk (clk),
      .rst (rst),
      .sig (BTNC),
      .rise(rise_c)
  );

  always_ff @(posedge clk) begin
    if (rst) begin
      total  <= '0;
      isEdit <= '1;
    end else begin
      if (rise_u) total <= total + int'(SW);
      if (rise_d) total <= total - int'(SW);
      if (rise_r) total <= total * int'(SW);
      if (rise_l) total <= total * int'(SW);  //for now same as bntr
      if (rise_c) isEdit <= ~isEdit;

    end
  end


  // Clock generator: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 100 MHz clock
  end

  task automatic doExpect(string msg, int actual, int expected);
    if (actual !== expected) begin
      $error("FAIL: %s | got %0d expected %0d", msg, actual, expected);
      $finish;
    end else begin
      $display("PASS: %s | value %0d", msg, actual);
    end
  endtask

  task automatic press_with_bounce(ref logic btn);
    btn = 1;
    #7;
    btn = 0;
    #5;
    btn = 1;
    #6;
    btn = 0;
    #4;
    btn = 1;
    #20;  // final stable high
  endtask

  task automatic clean_press(ref logic btn);
    btn = 1;
    #20;
    btn = 0;
    #20;
  endtask

  // Stimulus
  initial begin
    // Initialize
    rst  = 1;
    BTNU = 0;
    BTND = 0;
    BTNR = 0;
    BTNL = 0;
    BTNC = 0;
    SW   = 5;
    #20 rst = 0;

    // --- Test 1: Edit mode shows SW ---
    doExpect("Edit mode shows SW", calc_displayed, 5);

    // --- Test 2: Add operation (BTNU) ---
    press_with_bounce(BTNU);
    #20;
    doExpect("Add 5", total, 5);

    // --- Test 3: Subtract operation (BTND) ---
    press_with_bounce(BTND);
    #20;
    doExpect("Subtract 5", total, 0);

    // --- Test 4: Multiply operation (BTNR) ---
    SW = 3;
    press_with_bounce(BTNR);
    #20;
    doExpect("Multiply by 3", total, 0);

    // --- Test 5: Toggle mode (BTNC) ---
    press_with_bounce(BTNC);
    #20;
    doExpect("Mode toggled to compute", int'(isEdit), 0);

    // --- Test 6: Display shows total in compute mode ---
    doExpect("Compute mode shows total", calc_displayed, total);

    // --- Test 7: Clean press (no bounce) ---
    SW = 2;
    BTNU = 0;
#20; 
    clean_press(BTNU);
    clean_press(BTNU);
    clean_press(BTNU);
    #20;
    doExpect("Add 3 clean press", total, 6);

    $display("All tests completed");
    $finish;
  end



endmodule
