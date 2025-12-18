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

  always_ff @(posedge clk) begin
    if (rst) begin
      total  <= '0;
      isEdit <= '1;
    end else begin
      if (rise_u) total <= total + int'(SW);
      if (rise_d) total <= total - int'(SW);
      if (rise_r) total <= total * int'(SW);
      if (rise_l) total <= total * int'(SW);  //for now same as bntr
      if (rise_c) isEdit <= ~isEdit;

    end
  end



endmodule
