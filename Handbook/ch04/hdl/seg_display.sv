module seg_display #(
    parameter NUM_SEGMENTS = 8,
    parameter CLK_PER      = 10,   // Clock period in ns
    parameter REFR_RATE    = 1000  // Refresh rate in Hz
) (
    input logic  [DIGITS*8-1:0] display,  // flattened: 8 bits per digit
    input  logic        clk,
    input  logic        rst,
    output logic [7:0] AN,
    output logic       CA,
    output logic       CB,
    output logic       CC,
    output logic       CD,
    output logic       CE,
    output logic       CF,
    output logic       CG,
    output logic       DP
);

  localparam INTERVAL = int'(100000000 / (CLK_PER * REFR_RATE));

  logic [7:0] cathode;
  assign {DP, CG, CF, CE, CD, CC, CB, CA} = cathode;

  logic [    $clog2(INTERVAL)-1:0] refresh_count;
  logic [$clog2(NUM_SEGMENTS)-1:0] anode_count;
  initial begin
    refresh_count = '0;
    anode_count   = '0;
  end

  always @(posedge clk) begin
    if (rst) begin
      refresh_count <= '0;
      anode_count   <= '0;
    end
    if (refresh_count == 14'(INTERVAL)) begin
      refresh_count <= '0;
      anode_count   <= anode_count + 1'b1;
    end else refresh_count <= refresh_count + 1'b1;
    AN              <= '1;
    AN[anode_count] <= '0;
    cathode         <= display[anode_count*8+:8];

  end

endmodule
