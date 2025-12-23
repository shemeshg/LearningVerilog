`timescale 1ns / 1ps
import car_types_pkg::*;
module tb_emulator;
  //wires
  logic signal_car_to_cross_if_green_in;
  logic car_errived_in_lane_in_a1;
  logic car_errived_in_lane_in_a2;
  logic car_errived_in_lane_in_b1;
  logic car_errived_in_lane_in_b2;
  logic rst;
  logic clk;

  strafic_light_t strafic_light_a;
  strafic_light_t strafic_light_b;
  car_counter_t car_counter_a1;
  car_counter_t car_counter_a2;
  car_counter_t car_counter_b1;
  car_counter_t car_counter_b2;


  car_lane car_lane_inst_a1 (
      .clk(clk),
      .rst(rst),
      .signal_car_to_cross_if_green_in(signal_car_to_cross_if_green_in),
      .car_errived_in_lane_in(car_errived_in_lane_in_a1),
      .strafic_light(strafic_light_a),
      .car_counter(car_counter_a1)
  );


  car_lane car_lane_inst_a2 (
      .clk(clk),
      .rst(rst),
      .signal_car_to_cross_if_green_in(signal_car_to_cross_if_green_in),
      .car_errived_in_lane_in(car_errived_in_lane_in_a2),
      .strafic_light(strafic_light_a),
      .car_counter(car_counter_a2)
  );

  car_lane car_lane_inst_b1 (
      .clk(clk),
      .rst(rst),
      .signal_car_to_cross_if_green_in(signal_car_to_cross_if_green_in),
      .car_errived_in_lane_in(car_errived_in_lane_in_b1),
      .strafic_light(strafic_light_b),
      .car_counter(car_counter_b1)
  );


  car_lane car_lane_inst_b2 (
      .clk(clk),
      .rst(rst),
      .signal_car_to_cross_if_green_in(signal_car_to_cross_if_green_in),
      .car_errived_in_lane_in(car_errived_in_lane_in_b2),
      .strafic_light(strafic_light_b),
      .car_counter(car_counter_b2)
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
    car_counter_a1 = 0;
    strafic_light_a = RED;
    #20 rst = 0;

    doExpect("Cars inline to cross 0", int'(car_counter_a1), 0);
    $display("Traffic light is %s", strafic_light_a.name());

    signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;

    #20 car_errived_in_lane_in_a1 = '1;
    #20 car_errived_in_lane_in_a1 = '0;

    #20 car_errived_in_lane_in_a1 = '1;
    #20 car_errived_in_lane_in_a1 = '0;
    doExpect("Cars inline to cross 2", int'(car_counter_a1), 2);

    $display("Start stream cars");
    strafic_light_a = GREEN;
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 1", int'(car_counter_a1), 1);

    $display("YELLOW all stop");
    strafic_light_a = YELLOW;
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 1", int'(car_counter_a1), 1);

    $display("and last carp");
    strafic_light_a = GREEN;
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 0", int'(car_counter_a1), 0);

    $display("All tests completed");
    $finish;
  end
endmodule
