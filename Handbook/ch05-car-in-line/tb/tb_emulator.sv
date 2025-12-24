`timescale 1ns / 1ps
import car_types_pkg::*;
module tb_emulator;
  //wires
  logic                    crossroad_status_changed_in;

  logic                    signal_car_to_cross_if_green_in;
  logic                    car_errived_in_lane_in_a1;
  logic                    car_errived_in_lane_in_a2;
  logic                    car_errived_in_lane_in_b1;
  logic                    car_errived_in_lane_in_b2;
  logic                    rst;
  logic                    clk;

  strafic_light_t          strafic_light_a;
  strafic_light_t          strafic_light_b;
  car_counter_t            car_counter_a1;
  car_counter_t            car_counter_a2;
  car_counter_t            car_counter_b1;
  car_counter_t            car_counter_b2;
  crossroad_status_t       crossroad_status;

  logic              [7:0] AN;
  logic                    CA;
  logic                    CB;
  logic                    CC;
  logic                    CD;
  logic                    CE;
  logic                    CF;
  logic                    CG;
  logic                    DP;

  car_crossroad car_crossroad_inst (
      .rst(rst),
      .clk(clk),
      .signal_car_to_cross_if_green_in(signal_car_to_cross_if_green_in),
      .crossroad_status_changed_in(crossroad_status_changed_in),
      .car_errived_in_lane_in_a1(car_errived_in_lane_in_a1),
      .car_errived_in_lane_in_a2(car_errived_in_lane_in_a2),
      .car_errived_in_lane_in_b1(car_errived_in_lane_in_b1),
      .car_errived_in_lane_in_b2(car_errived_in_lane_in_b2),
      .strafic_light_a(strafic_light_a),
      .strafic_light_b(strafic_light_b),
      .car_counter_a1(car_counter_a1),
      .car_counter_a2(car_counter_a2),
      .car_counter_b1(car_counter_b1),
      .car_counter_b2(car_counter_b2),
      .crossroad_status(crossroad_status)
  );

  logic [CAR_LEN_DIGITS*CATHODS-1:0] car_lan_seg_display_a1;
  car_len_display car_len_display_inst_a1 (
      car_counter_a1,
      car_lan_seg_display_a1
  );
  logic [CAR_LEN_DIGITS*CATHODS-1:0] car_lan_seg_display_a2;
  car_len_display car_len_display_inst_a2 (
      car_counter_a2,
      car_lan_seg_display_a2
  );
  logic [CAR_LEN_DIGITS*CATHODS-1:0] car_lan_seg_display_b1;
  car_len_display car_len_display_inst_b1 (
      car_counter_b1,
      car_lan_seg_display_b1
  );
  logic [CAR_LEN_DIGITS*CATHODS-1:0] car_lan_seg_display_b2;
  car_len_display car_len_display_inst_b2 (
      car_counter_b1,
      car_lan_seg_display_b2
  );

  logic [DIGITS*8-1:0] display;

  logic tick_seg;  // wire for the refresh pulse
  clock_seg_display clock_seg_display_inst (
      .clk (clk),
      .rst (rst),
      .tick(tick_seg)
  );

  seg_display seg_display_inst (
      .display(display),
      .clk(clk),
      .rst(rst),
      .tick(tick_seg),
      .AN(AN),
      .CA(CA),
      .CB(CB),
      .CC(CC),
      .CD(CD),
      .CE(CE),
      .CF(CF),
      .CG(CG),
      .DP(DP)
  );


assign display = {
    car_lan_seg_display_b2,   // highest bits [63:48]
    car_lan_seg_display_b1,   // [47:32]
    car_lan_seg_display_a2,   // [31:16]
    car_lan_seg_display_a1    // lowest bits [15:0]
};

 always_comb begin

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
