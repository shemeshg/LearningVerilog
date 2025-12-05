module select_btn_action (
    input  word_t SW,
    output word_t LED,
    input  wire   CPU_RESETN,
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

  always_comb begin
    case (1'b1)
      BTNC: SELECTOR_TB = MUL;
      BTNU: SELECTOR_TB = LEADING_ONES;
      BTND: SELECTOR_TB = COUNT_ONES;
      BTNL: SELECTOR_TB = ADD;
      BTNR: SELECTOR_TB = SUB;
      default: SELECTOR_TB = RESET;
    endcase
  end

endmodule
