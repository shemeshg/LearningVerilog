import car_types_pkg::*;
module car_crossroad_displays (
    input logic       rst,
    input logic       clk,
    output logic [7:0] AN,
    output logic       CA,
    output logic       CB,
    output logic       CC,
    output logic       CD,
    output logic       CE,
    output logic       CF,
    output logic       CG,
    output logic       DP,
    input logic       crossroad_status_changed_in,
    input logic       signal_car_to_cross_if_green_in,
    input logic       car_errived_in_lane_in_a1,
    input logic       car_errived_in_lane_in_a2,
    input logic       car_errived_in_lane_in_b1,
    input logic       car_errived_in_lane_in_b2,

    output strafic_light_t    strafic_light_a,
    output strafic_light_t    strafic_light_b,
    output car_counter_t      car_counter_a1,
    output car_counter_t      car_counter_a2,
    output car_counter_t      car_counter_b1,
    output car_counter_t      car_counter_b2,
    output crossroad_status_t crossroad_status
);






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
    car_lan_seg_display_b2,  // highest bits [63:48]
    car_lan_seg_display_b1,  // [47:32]
    car_lan_seg_display_a2,  // [31:16]
    car_lan_seg_display_a1  // lowest bits [15:0]
  };



endmodule
