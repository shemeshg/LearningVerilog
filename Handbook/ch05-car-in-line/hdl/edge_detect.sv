`timescale 1ns / 1ps
module edge_detect (
    input  logic clk,
    input  logic rst,
    input  logic sig,
    output logic rise
);
  logic [1:0] d;

  always_ff @(posedge clk) begin
    if (rst) begin
      d <= 2'b00;
    end else begin
      d <= {d[0], sig};
    end
  end

  assign rise = (d == 2'b01);
endmodule