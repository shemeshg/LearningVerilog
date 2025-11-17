`timescale 1ns / 100ps
`include "types_pkg.sv"

module top (
    input wire CLK100MHZ,
    input wire CPU_RESETN,
    input wire [15:0] SW,
    output wire [3:0] LED
);

  wire rst;
  assign rst = ~CPU_RESETN;

  /*
    wire [4:0] count;

    count_ones #(.BITS(16)) u_count_ones (
        .clk(CLK100MHZ),
        .rst(rst),
        .SW(SW),
        .LED(count)
    );

    assign LED = count[3:0];


    count_ones #(.BITS(16)) u_count_ones (
        .clk(CLK100MHZ),
        .rst(rst),
        .SW(SW),
        .LED(LED)
    );
    */

  opr_mode_t  SELECTOR_TB;
  select_action #() select_action_inst (
      .clk(CLK100MHZ),
      .rst(rst),
      .SELECTOR(SELECTOR_TB),
      .SW(SW),
      .LED(LED)
  );

  always_comb begin
    LED = '0;
    case (1'b1)
      BTNC: SELECTOR_TB  = MUL;
      BTNU: SELECTOR_TB  = LEADING_ONES;
      BTND: SELECTOR_TB  = COUNT_ONES;
      BTNL: SELECTOR_TB  = ADD;
      BTNR: SELECTOR_TB  = SUB;
    endcase
  end

endmodule
