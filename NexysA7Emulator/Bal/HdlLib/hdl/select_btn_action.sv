`timescale 1ns / 10ps
module select_btn_action (
    input  word_t SW,
    output word_t LED,
    input  wire   CPU_RESETN,
    input  wire   CLOCK,
    input  wire   BTNC,
    input  wire   BTNU,
    input  wire   BTNL,
    input  wire   BTNR,
    input  wire   BTND
);
  import types_pkg::*;


  opr_mode_t rememberd_selected;


  select_action #() select_action_inst (
      .SELECTOR(rememberd_selected),
      .SW(SW),
      .LED(LED)
  );

  always_ff @(posedge CLOCK or posedge CPU_RESETN) begin
    if (CPU_RESETN) begin
      rememberd_selected <= RESET;
    end else begin
      if (BTNC) begin
        rememberd_selected <= MUL;
      end else if (BTNU) begin
        rememberd_selected <= LEADING_ONES;
      end else if (BTND) begin
        rememberd_selected <= COUNT_ONES;
      end else if (BTNL) begin
        rememberd_selected <= ADD;
      end else if (BTNR) begin
        rememberd_selected <= SUB;
      end else if (1'(RESET)) begin
        rememberd_selected <= RESET;
      end

    end
  end



endmodule
