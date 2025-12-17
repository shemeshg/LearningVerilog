module clock_seg_display #(
    parameter CLK_PER   = 10,
    parameter REFR_RATE = 1000
) (
    input  logic clk,
    input  logic rst,
    output logic tick
);

  localparam INTERVAL = int'(100000000 / (CLK_PER * REFR_RATE));
  localparam CNT_W = $clog2(INTERVAL);
  logic [CNT_W-1:0] cnt;

  always @(posedge clk) begin
    if (rst) begin
      cnt  <= '0;
      tick <= 1'b0;
    end else begin
      if (cnt == CNT_W'(INTERVAL - 1)) begin
        cnt  <= '0;
        tick <= 1'b1;
      end else begin
        cnt  <= cnt + 1'b1;
        tick <= 1'b0;
      end
    end
  end

endmodule
