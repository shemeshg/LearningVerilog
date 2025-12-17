module seg_display #(
    parameter NUM_SEGMENTS = 8
)(
    input  logic clk,
    input  logic rst,
    input  logic tick,                     // NEW: refresh pulse
    input  logic [NUM_SEGMENTS*8-1:0] display,
    output logic [7:0] AN,
    output logic       CA, CB, CC, CD, CE, CF, CG, DP
);

  logic [7:0] cathode;
  assign {DP, CG, CF, CE, CD, CC, CB, CA} = cathode;

  logic [$clog2(NUM_SEGMENTS)-1:0] anode_count;

  always @(posedge clk) begin
    if (rst) begin
      anode_count <= '0;
    end else if (tick) begin
      anode_count <= anode_count + 1'b1;
    end

    AN              <= '1;
    AN[anode_count] <= '0;
    cathode         <= display[anode_count*8+:8];
  end

endmodule
