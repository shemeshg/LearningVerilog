`timescale 1ns / 10ps
package car_types_pkg;
  parameter int CAR_LEN_DIGITS = 2;
  typedef logic [4:0] car_counter_t;  //limited to 9
  typedef enum logic [1:0] {
    GREEN  = 2'b00,
    YELLOW = 2'b01,
    RED    = 2'b10
  } strafic_light_t;

   typedef enum logic [1:0] {
    LANE_A  = 2'b00,
    TRANSITION_AB = 2'b01,
    LANE_B    = 2'b10,
    TRANSITION_BA = 2'b11
  } crossroad_status_t;
endpackage
