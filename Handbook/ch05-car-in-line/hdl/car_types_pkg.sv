`timescale 1ns / 10ps
package car_types_pkg;
  typedef logic [4:0] car_counter_t;  //limited to 9
  typedef enum logic [1:0] {
    GREEN  = 2'b00,
    YELLOW = 2'b01,
    RED    = 2'b10
  } strafic_light_t;
endpackage
