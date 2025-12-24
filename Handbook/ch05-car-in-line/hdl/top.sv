`timescale 1ns / 100ps
import types_pkg::*;


module top #(
    parameter NUM_SEGMENTS = 8,
    parameter CLK_PER      = 10,   // Clock period in ns
    parameter REFR_RATE    = 1000  // Refresh rate in Hz
) (
    input  wire                    CLK100MHZ,
    input  wire                    CPU_RESETN,
    input  wire         [    15:0] SW,
    output logic signed [BITS-1:0] LED,
    input  wire                    BTNC,
    input  wire                    BTNU,
    input  wire                    BTNL,
    input  wire                    BTNR,
    input  wire                    BTND,
    output logic        [     7:0] AN,
    output logic                   CA,
    output logic                   CB,
    output logic                   CC,
    output logic                   CD,
    output logic                   CE,
    output logic                   CF,
    output logic                   CG,
    output logic                   DP,
    output logic                   LED16_B,
    output logic                   LED16_G,
    output logic                   LED16_R,
    output logic                   LED17_B,
    output logic                   LED17_G,
    output logic                   LED17_R
);

  wire rst;
  assign rst = ~CPU_RESETN;
  wire clk;
  assign clk = CLK100MHZ;

  logic clk_50;

  sys_pll u_sys_pll (
      .clk_in1 (clk),
      .clk_out1(clk_50)
  );



  logic  BTNC_DEB;
  logic  BTNU_DEB;
  logic  BTNL_DEB;
  logic  BTNR_DEB;
  logic  BTND_DEB;
  word_t SW_DEB;

  // START unbounce
  unbounce_btn #(
      .WAIT_COUNT(3)
  ) deb_btnC (
      .CPU_RESET(rst),
      .CLOCK(clk),
      .BTN_IN(BTNC),
      .BTN_OUT(BTNC_DEB)
  );

  unbounce_btn #(
      .WAIT_COUNT(3)
  ) deb_btnU (
      .CPU_RESET(rst),
      .CLOCK(clk),
      .BTN_IN(BTNU),
      .BTN_OUT(BTNU_DEB)
  );

  unbounce_btn #(
      .WAIT_COUNT(3)
  ) deb_btnL (
      .CPU_RESET(rst),
      .CLOCK(clk),
      .BTN_IN(BTNL),
      .BTN_OUT(BTNL_DEB)
  );

  unbounce_btn #(
      .WAIT_COUNT(3)
  ) deb_btnR (
      .CPU_RESET(rst),
      .CLOCK(clk),
      .BTN_IN(BTNR),
      .BTN_OUT(BTNR_DEB)
  );

  unbounce_btn #(
      .WAIT_COUNT(3)
  ) deb_btnD (
      .CPU_RESET(rst),
      .CLOCK(clk),
      .BTN_IN(BTND),
      .BTN_OUT(BTND_DEB)
  );


  unbounce_array debouncer (
      .CPU_RESET(rst),
      .CLOCK(clk),
      .BTN_IN(SW),
      .BTN_OUT(SW_DEB)
  );
  // END of unbounce

  strafic_light_t    strafic_light_a;
  strafic_light_t    strafic_light_b;
  car_counter_t      car_counter_a1;
  car_counter_t      car_counter_a2;
  car_counter_t      car_counter_b1;
  car_counter_t      car_counter_b2;
  crossroad_status_t crossroad_status;
  car_crossroad_displays car_crossroad_displays_inst (
      .rst(rst),
      .clk(clk),
      .AN(AN),
      .CA(CA),
      .CB(CB),
      .CC(CC),
      .CD(CD),
      .CE(CE),
      .CF(CF),
      .CG(CG),
      .DP(DP),
      .crossroad_status_changed_in(BTNR_DEB),
      .signal_car_to_cross_if_green_in(BTNC_DEB),
      .car_errived_in_lane_in_a1(BTNU_DEB),
      .car_errived_in_lane_in_a2(BTNU_DEB),
      .car_errived_in_lane_in_b1(BTND_DEB),
      .car_errived_in_lane_in_b2(BTND_DEB),

      .strafic_light_a (strafic_light_a),
      .strafic_light_b (strafic_light_b),
      .car_counter_a1  (car_counter_a1),
      .car_counter_a2  (car_counter_a2),
      .car_counter_b1  (car_counter_b1),
      .car_counter_b2  (car_counter_b2),
      .crossroad_status(crossroad_status)
  );

  reg [7:0] R_target_1, G_target_1, B_target_1;
  reg [7:0] R_target_2, G_target_2, B_target_2;
  always @(*) begin
    case (crossroad_status)
      LANE_A: begin
        R_target_1 = '0;
        G_target_1 = '1;
        B_target_1 = '0;
        R_target_2 = '1;
        G_target_2 = '0;
        B_target_2 = '0;

      end  // Green
      LANE_B: begin
        R_target_1 = '1;
        G_target_1 = '0;
        B_target_1 = '0;
        R_target_2 = '0;
        G_target_2 = '1;
        B_target_2 = '0;

      end

      default: begin
        R_target_1 = '1;
        G_target_1 = '1;
        B_target_1 = '0;
        R_target_2 = '1;
        G_target_2 = '1;
        B_target_2 = '0;
      end
    endcase
  end



  led_rgb ledrgb_1 (
      .CLK100MHZ(clk),
      .LED_R(LED16_R),
      .LED_G(LED16_G),
      .LED_B(LED16_B),
      .r(R_target_1),
      .g(G_target_1),
      .b(B_target_1),
      .brightness(8'd200)
  );

  led_rgb ledrgb_2 (
      .CLK100MHZ(clk),
      .LED_R(LED17_R),
      .LED_G(LED17_G),
      .LED_B(LED17_B),
      .r(R_target_2),
      .g(G_target_2),
      .b(B_target_2),
      .brightness(8'd200)
  );


endmodule
