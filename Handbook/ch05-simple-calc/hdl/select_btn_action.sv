`timescale 1ns / 10ps
module select_btn_action (
    input  word_t SW,
    output word_t LED,
    input  wire   rst,
    input  wire   clk,
    input  wire   BTNC,
    input  wire   BTNU,
    input  wire   BTNL,
    input  wire   BTNR,
    input  wire   BTND,
    output int    calc_displayed,
    output logic  isEdit
);
  import types_pkg::*;

  // ------------------------------------------------------------
  // Internal signed accumulator
  // ------------------------------------------------------------
  logic signed [BITS-1:0] total;

  // Display logic
  always_comb begin
    LED = SW;
    calc_displayed = isEdit ? int'(SW) : int'(total);
  end

  // ------------------------------------------------------------
  // Edge detectors
  // ------------------------------------------------------------
  logic rise_u, rise_d, rise_r, rise_l, rise_c;

  edge_detect ed_u (.clk(clk), .rst(rst), .sig(BTNU), .rise(rise_u));
  edge_detect ed_d (.clk(clk), .rst(rst), .sig(BTND), .rise(rise_d));
  edge_detect ed_r (.clk(clk), .rst(rst), .sig(BTNR), .rise(rise_r));
  edge_detect ed_l (.clk(clk), .rst(rst), .sig(BTNL), .rise(rise_l));
  edge_detect ed_c (.clk(clk), .rst(rst), .sig(BTNC), .rise(rise_c));

  // ------------------------------------------------------------
  // Divider interface
  // ------------------------------------------------------------
  logic        div_start, div_done, div_busy;
  logic [BITS-1:0] div_quotient, div_remainder;

  // Divider instance (unsigned)
  divider_nr u_divider (
      .clk(clk),
      .reset(rst),
      .start(div_start),
      .dividend(dividend_abs),
      .divisor(divisor_abs),
      .done(div_done),
      .quotient(div_quotient),
      .remainder(div_remainder)
  );

  // ------------------------------------------------------------
  // Signed-division wrapper
  // ------------------------------------------------------------

  // Signed versions of operands
  logic signed [BITS-1:0] dividend_s, divisor_s;
  assign dividend_s = total;
  assign divisor_s  = $signed(SW);

  // Signs
  logic result_negative;
  assign result_negative = (dividend_s < 0) ^ (divisor_s < 0);

  // Absolute values for divider
  logic [BITS-1:0] dividend_abs, divisor_abs;
  assign dividend_abs = dividend_s < 0 ? -dividend_s : dividend_s;
  assign divisor_abs  = divisor_s  < 0 ? -divisor_s  : divisor_s;

  // Signed quotient after correction
  logic signed [BITS-1:0] quotient_s;

  // ------------------------------------------------------------
  // Main sequential logic
  // ------------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst) begin
      total     <= '0;
      isEdit    <= 1;
      div_start <= 0;
      div_busy  <= 0;
    end else begin
      div_start <= 0;

      // -------------------------
      // Arithmetic operations
      // -------------------------
      if (rise_u) total <= total + $signed(SW);
      if (rise_d) total <= total - $signed(SW);
      if (rise_r) total <= total * $signed(SW);

      // Toggle edit mode
      if (rise_c) isEdit <= ~isEdit;

      // -------------------------
      // Start division
      // -------------------------
      if (rise_l && !div_busy && SW != 0) begin
        div_start <= 1;
        div_busy  <= 1;
      end

      // -------------------------
      // Division result
      // -------------------------
      if (div_done) begin
        // Restore sign
        quotient_s = result_negative
                     ? -$signed(div_quotient)
                     :  $signed(div_quotient);

        total    <= quotient_s;
        div_busy <= 0;
      end
    end
  end

endmodule
