`timescale 1ns / 100ps
module sys_pll #(
) (
    input  wire clk_in1,
    output wire clk_out1
);



  assign clk_out1 = clk_in1;
endmodule
