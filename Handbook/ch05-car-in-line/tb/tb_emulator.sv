`timescale 1ns / 1ps
import car_types_pkg::*;
module tb_emulator;
  //wires
  logic signal_car_to_cross_if_green_in;
  logic car_errived_in_lane_in;
  logic rst;
  logic clk;

  strafic_light_t strafic_light;
  car_counter_t car_counter;



  car_lane car_lane_inst (
      .clk(clk),
      .rst(rst),
      .signal_car_to_cross_if_green_in(signal_car_to_cross_if_green_in),
      .car_errived_in_lane_in(car_errived_in_lane_in),
      .strafic_light(strafic_light),
      .car_counter(car_counter)
  );

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
