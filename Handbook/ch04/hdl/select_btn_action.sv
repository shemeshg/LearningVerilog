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

  opr_mode_t SELECTOR_TB;
  select_action #() select_action_inst (
      .SELECTOR(SELECTOR_TB),
      .SW(SW),
      .LED(LED)
  );

  opr_mode_t rememberd_selected;
  initial begin
    rememberd_selected = RESET;
  end

  always_ff @(posedge CLOCK or posedge CPU_RESETN) begin
    if (CPU_RESETN) begin
      rememberd_selected <= RESET;
    end else begin
      case (1'b1)
        BTNC: rememberd_selected <= MUL;
        BTNU: rememberd_selected <= LEADING_ONES;
        BTND: rememberd_selected <= COUNT_ONES;
        BTNL: rememberd_selected <= ADD;
        BTNR: rememberd_selected <= SUB;
        RESET: rememberd_selected <= RESET;
        //default: rememberd_selected <= RESET;
      endcase
      //$display("Time: %0t  shalom %b %b", $time,rememberd_selected, SELECTOR_TB);
    end
  end

  always_comb begin
    SELECTOR_TB = rememberd_selected;
  end

endmodule
