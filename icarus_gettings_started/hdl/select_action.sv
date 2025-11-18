import types_pkg::*;

module select_action (
    input  opr_mode_t SELECTOR,
    input  word_t     SW,
    output word_t     LED
);


  word_t add_sub_mult_LED;
  add_sub_mult #() add_sub_mult_inst (
      .SELECTOR(SELECTOR),
      .SW(SW),
      .LED(add_sub_mult_LED)
  );

  always_comb begin
    case (SELECTOR)
      RESET:        LED = '0;
      ADD:          LED = add_sub_mult_LED;
      SUB:          LED = add_sub_mult_LED;
      MUL:          LED = add_sub_mult_LED;
      LEADING_ONES: LED = SW + 5;
      COUNT_ONES:   LED = SW + 6;
      default:      LED = '0;
    endcase

  end

endmodule
