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
    output  logic         [     7:0] AN,
    output  logic                    CA,
    output  logic                    CB,
    output  logic                    CC,
    output  logic                    CD,
    output  logic                    CE,
    output  logic                    CF,
    output  logic                    CG,
    output  logic                    DP
);

  wire rst;
  assign rst = ~CPU_RESETN;
  wire clk;
  assign clk = CLK100MHZ;
  

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

  seg_display seg_display_inst (
          .display(display),
      .clk(clk),
      .rst(rst),
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
