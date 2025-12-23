`timescale 1ns / 1ps
import car_types_pkg::*;
module tb_emulator;
  //wires
  logic crossroad_status_changed_in;

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


  logic crossroad_status_changed;
  edge_detect ed_crossroad_status (
      .clk (clk),
      .rst (rst),
      .sig (crossroad_status_changed_in),
      .rise(crossroad_status_changed)
  );

  typedef enum logic [1:0] {
    LANE_A  = 2'b00,
    TRANSITION_AB = 2'b01,
    LANE_B    = 2'b10,
    TRANSITION_BA = 2'b11
  } crossroad_status_t;
  crossroad_status_t crossroad_status;

  always_ff @(posedge clk) begin
    if (rst) begin
      crossroad_status <= LANE_A;
    end else begin
      if (crossroad_status_changed)
        crossroad_status <= crossroad_status_t'(crossroad_status + crossroad_status_t'(1));

    end
  end

  always_comb begin
    case (crossroad_status)
      LANE_A: begin
        strafic_light_a = GREEN;
        strafic_light_b = RED;
      end
      TRANSITION_AB: begin
        strafic_light_a = YELLOW;
        strafic_light_b = YELLOW;
      end
      LANE_B: begin
        strafic_light_a = RED;
        strafic_light_b = GREEN;
      end
      TRANSITION_BA: begin
        strafic_light_a = YELLOW;
        strafic_light_b = YELLOW;
      end
    endcase
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
    car_counter_a1 = 0;
    //strafic_light_a = RED;
    #20 rst = 0;

    doExpect("Cars inline to cross 0", int'(car_counter_a1), 0);
    $display("Traffic light is %s", strafic_light_a.name());
    $display("crossroad_status is %s", crossroad_status.name());


    signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;

    #20 car_errived_in_lane_in_a1 = '1;
    #20 car_errived_in_lane_in_a1 = '0;

    #20 car_errived_in_lane_in_a1 = '1;
    #20 car_errived_in_lane_in_a1 = '0;
    doExpect("Cars inline to cross 2", int'(car_counter_a1), 2);

    $display("Start stream cars");
    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 1", int'(car_counter_a1), 1);

    #20 crossroad_status_changed_in = '1;
    #20 crossroad_status_changed_in = '0;
    $display("crossroad_status is %s", crossroad_status.name());
    $display("YELLOW all stop");

    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 1", int'(car_counter_a1), 1);

    #20 crossroad_status_changed_in = '1;
    #20 crossroad_status_changed_in = '0;
    $display("crossroad_status is %s", crossroad_status.name());

    #20 crossroad_status_changed_in = '1;
    #20 crossroad_status_changed_in = '0;
    $display("crossroad_status is %s", crossroad_status.name());

    #20 crossroad_status_changed_in = '1;
    #20 crossroad_status_changed_in = '0;
    $display("crossroad_status is %s", crossroad_status.name());

    $display("and last carp");

    #20 signal_car_to_cross_if_green_in = '1;
    #20 signal_car_to_cross_if_green_in = '0;
    doExpect("Cars inline to cross 0", int'(car_counter_a1), 0);



    $display("All tests completed");
    $finish;
  end
endmodule
