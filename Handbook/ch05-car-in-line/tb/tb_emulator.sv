`timescale 1ns / 1ps

module tb_emulator;
  //wires
  logic signal_car_to_cross_if_green_in;
  logic car_errived_in_lane_in;
  logic rst;
  logic clk;

 
  typedef logic [4:0] car_counter_t;  //limited to 9
  car_counter_t car_counter;

  typedef enum logic [1:0] {
    GREEN  = 2'b00,
    YELLOW = 2'b01,
    RED    = 2'b10
  } strafic_light_t;
  strafic_light_t strafic_light;

  logic signal_car_to_cross_if_green;
  edge_detect ed_c (
      .clk (clk),
      .rst (rst),
      .sig (signal_car_to_cross_if_green_in),
      .rise(signal_car_to_cross_if_green)
  );

  logic car_errived_in_lane;
  edge_detect ed_l (
      .clk (clk),
      .rst (rst),
      .sig (car_errived_in_lane_in),
      .rise(car_errived_in_lane)
  );

  always_ff @(posedge clk) begin
    if (rst) begin
      car_counter <= '0;
    end else begin
      if (car_errived_in_lane && car_counter <= car_counter_t'('d9)) 
                car_counter <= car_counter + car_counter_t'('d1);
      if (car_counter > 0 && strafic_light == GREEN && signal_car_to_cross_if_green) 
                car_counter <= car_counter - car_counter_t'('d1);

    end
  end


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

  initial begin
    rst = 1;
    car_counter = 0;
    strafic_light = RED;
    #20 rst = 0;

    doExpect("Cars inline to cross 0", int'(car_counter), 0);
    $display("Traffic light is %s", strafic_light.name());

    signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;

    #20 car_errived_in_lane_in = '1;
    #20 car_errived_in_lane_in = '0;

    #20 car_errived_in_lane_in = '1;
    #20 car_errived_in_lane_in = '0;
    doExpect("Cars inline to cross 2", int'(car_counter), 2);

    $display("Start stream cars");
    strafic_light = GREEN;
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 1", int'(car_counter), 1);

    $display("YELLOW all stop");
    strafic_light = YELLOW;
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 1", int'(car_counter), 1);

    $display("and last carp");
    strafic_light = GREEN;
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 0", int'(car_counter), 0);

    $display("All tests completed");
    $finish;
  end
endmodule
