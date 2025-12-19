`timescale 1ns / 10ps
module select_btn_action (
    input word_t SW,
    output word_t LED,
    input wire rst,
    input wire clk,
    input wire BTNC,
    input wire BTNU,
    input wire BTNL,
    input wire BTNR,
    input wire BTND,
    output int calc_displayed,
    output logic isEdit
);
  import types_pkg::*;


  int total;
  always_comb begin
    LED = SW;
    if (isEdit) calc_displayed = int'(SW);
    else calc_displayed = total;
  end

  logic rise_u, rise_d, rise_r, rise_l, rise_c;

  edge_detect ed_u (
      .clk (clk),
      .rst (rst),
      .sig (BTNU),
      .rise(rise_u)
  );

  edge_detect ed_d (
      .clk (clk),
      .rst (rst),
      .sig (BTND),
      .rise(rise_d)
  );

  edge_detect ed_r (
      .clk (clk),
      .rst (rst),
      .sig (BTNR),
      .rise(rise_r)
  );

  edge_detect ed_l (
      .clk (clk),
      .rst (rst),
      .sig (BTNL),
      .rise(rise_l)
  );

  edge_detect ed_c (
      .clk (clk),
      .rst (rst),
      .sig (BTNC),
      .rise(rise_c)
  );


  logic div_start, div_done;
  logic [BITS-1:0] div_quotient, div_remainder;

  divider_nr u_divider (
      .clk(clk),
      .reset(rst),
      .start(div_start),
      .dividend(word_t'(total)),
      .divisor(SW),
      .done(div_done),
      .quotient(div_quotient),
      .remainder(div_remainder)
  );

  logic div_busy;

  always_ff @(posedge clk) begin
    if (rst) begin
      div_start <= 0;
      div_busy  <= 0;
    end else begin
      div_start <= 0;  // default

      if (rise_l && !div_busy) begin
        if (SW != 0) begin
          div_start <= 1;  // pulse start
          div_busy  <= 1;  // block new operations
        end
      end

      if (div_done) begin
        total    <= int'(div_quotient);  // update result
        div_busy <= 0;
      end
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      total  <= '0;
      isEdit <= '1;
    end else begin
      if (rise_u) total <= total + int'(SW);
      if (rise_d) total <= total - int'(SW);
      if (rise_r) total <= total * int'(SW);
      if (rise_c) isEdit <= ~isEdit;

    end
  end



endmodule
