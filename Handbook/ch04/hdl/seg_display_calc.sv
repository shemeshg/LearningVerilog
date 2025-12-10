import types_pkg::*;

module seg_display_calc (
    output logic  [DIGITS*8-1:0] display,  // flattened: 8 bits per digit
    input  wire                  clk,
    input  wire                  rst,
    input  word_t                SW,
    output word_t                LED,
    input  wire                  BTNC,
    input  wire                  BTNU,
    input  wire                  BTNL,
    input  wire                  BTNR,
    input  wire                  BTND
);

  // Button action logic
  select_btn_action #() select_btn_action_inst (
      .SW(SW),
      .LED(LED),
      .CPU_RESETN(rst),
      .CLOCK(clk),
      .BTNU(BTNU),
      .BTNC(BTNC),
      .BTNL(BTNL),
      .BTNR(BTNR),
      .BTND(BTND)
  );

  // Convert LED value to BCD digits
  logic [DIGITS*4-1:0] bcd;
  bin_to_bcd bin_to_bcd_module (
      .bin(LED),
      .bcd(bcd)
  );

  // Per-digit encoded nibble and cathode pattern
  logic  [3:0] encoded[DIGITS];
  byte_t       cathode[DIGITS];

  // Instantiate a decoder per digit
  genvar i;
  generate
    for (i = 0; i < DIGITS; i++) begin : decoders
      dec_cat_map dec_cat_map_inst (
          .encoded(encoded[i]),
          .cathode(cathode[i])
      );
    end
  endgenerate

  // Combinational mapping
  always_comb begin
    // Break BCD into nibbles
    foreach (encoded[i]) encoded[i] = bcd[i*4+:4];

    // Flatten cathode outputs into packed bus
    foreach (cathode[i]) display[i*8+:8] = cathode[i];
  end

endmodule
