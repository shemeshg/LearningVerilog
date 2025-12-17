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
    output logic                   DP
);

  wire rst;
  assign rst = ~CPU_RESETN;
  wire clk;
  assign clk = CLK100MHZ;

  logic clk_50;
`ifdef VERILATOR
  assign clk_50 = clk;
  localparam int CLK_PER_VAL = 10;
`elsif ICARUS
  assign clk_50 = clk;
  localparam int CLK_PER_VAL = 10;
`else
  sys_pll u_sys_pll (
      .clk_in1 (clk),
      .clk_out1(clk_50)
  );
  localparam int CLK_PER_VAL = 20;
`endif




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

  //output logic [7:0] display [DIGITS];
  logic [DIGITS*8-1:0] display;
  seg_display_calc seg_display_calc_inst (
      .display(display),
      .clk(clk),
      .rst(rst),
      .SW(SW_DEB),
      .LED(LED),
      .BTNC(BTNC_DEB),
      .BTNU(BTNU_DEB),
      .BTNL(BTNL_DEB),
      .BTNR(BTNR_DEB),
      .BTND(BTND_DEB)
  );

  logic tick_seg;  // wire for the refresh pulse

clock_seg_display #(
    .CLK_PER(CLK_PER_VAL)
) clock_seg_display_inst (
    .clk (clk_50),
    .rst (rst),
    .tick(tick_seg)
);


  seg_display seg_display_inst (
      .display(display),
      .clk(clk_50),
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

endmodule
