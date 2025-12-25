`timescale 1ns / 10ps
import types_pkg::*;

module seg_display_calc (
    output logic  [DIGITS*8-1:0] display,  // flattened: 8 bits per digit
    input  wire                  clk,
    input  wire                  rst,
    input  word_t                SW,
    output word_t                LED,
    input  wire                  BTNC,
    input  wire                  BTNU,
    input  wire                  BTNL,
    input  wire                  BTNR,
    input  wire                  BTND
);

  // Value coming from the button logic
  int   calc_displayed;
  logic isEdit;

  // Button action logic
  select_btn_action select_btn_action_inst (
      .SW(SW),
      .LED(LED),
      .rst(rst),
      .clk(clk),
      .BTNU(BTNU),
      .BTNC(BTNC),
      .BTNL(BTNL),
      .BTNR(BTNR),
      .BTND(BTND),
      .calc_displayed(calc_displayed),
      .isEdit(isEdit)
  );

  // Signed interpretation + absolute value
  int signed calc_displayed_signed;
  int signed calc_displayed_abs;

  // BCD output
  logic [DIGITS*4-1:0] bcd;

  // Per-digit encoded nibble and cathode pattern
  logic [3:0] encoded[DIGITS];
  byte_t      cathode[DIGITS];

  // Instantiate a decoder per digit
  genvar i;
  generate
    for (i = 0; i < DIGITS; i++) begin : decoders
      dec_cat_map dec_cat_map_inst (
          .encoded(encoded[i]),
          .cathode(cathode[i])
      );
    end
  endgenerate

  // ------------------------------------------------------------
  // 1) Compute signed + absolute value
  // ------------------------------------------------------------
  always_comb begin
    calc_displayed_signed = signed'(calc_displayed);

    calc_displayed_abs =
        (calc_displayed_signed < 0)
        ? -calc_displayed_signed
        :  calc_displayed_signed;
  end

  // ------------------------------------------------------------
  // 2) Convert absolute value to BCD
  // ------------------------------------------------------------
  bin_to_bcd bin_to_bcd_module (
      .bin(word_t'(calc_displayed_abs)),
      .bcd(bcd)
  );

  // ------------------------------------------------------------
  // 3) Break BCD into encoded nibbles
  //    (separate block to avoid combinational loops)
  // ------------------------------------------------------------
  always_comb begin
    foreach (encoded[i])
      encoded[i] = bcd[i*4 +: 4];
  end

  // ------------------------------------------------------------
  // 4) Build final display output
  //    (separate block to avoid encoded → cathode → display → encoded loops)
  // ------------------------------------------------------------
  always_comb begin
    foreach (cathode[i]) begin
      if (isEdit && i == DIGITS - 1)
        display[i*8 +: 8] = 8'b0000_0110;  // edit indicator
      else if (!isEdit && i == DIGITS - 1 && calc_displayed_signed < 0)
        display[i*8 +: 8] = 8'b1011_1111;  // minus indicator
      else
        display[i*8 +: 8] = cathode[i];
    end
  end

endmodule
