import car_types_pkg::*;
module car_crossroad (
    input logic rst,
    input logic clk,
    input logic signal_car_to_cross_if_green_in,
    input logic crossroad_status_changed_in,
    input logic car_errived_in_lane_in_a1,
    input logic car_errived_in_lane_in_a2,
    input logic car_errived_in_lane_in_b1,
    input logic car_errived_in_lane_in_b2,
    output strafic_light_t strafic_light_a,
    output strafic_light_t strafic_light_b,
    output car_counter_t car_counter_a1,
    output car_counter_t car_counter_a2,
    output car_counter_t car_counter_b1,
    output car_counter_t car_counter_b2,
    output crossroad_status_t crossroad_status
);

  
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

endmodule
