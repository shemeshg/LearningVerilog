import car_types_pkg::*;
module car_lane (
    input logic signal_car_to_cross_if_green_in,
    input logic car_errived_in_lane_in,
    input logic rst,
    input logic clk,
    input strafic_light_t strafic_light,
    output car_counter_t car_counter
);

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

endmodule
