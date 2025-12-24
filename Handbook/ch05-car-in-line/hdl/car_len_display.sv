`timescale 1ns / 100ps
import types_pkg::*;
import car_types_pkg::*;
module car_len_display (
    input car_counter_t car_count,
    output logic [CAR_LEN_DIGITS*CATHODS-1:0] car_lan_seg_display
);

  logic [4*CAR_LEN_DIGITS-1:0] bcd;
  bin_to_bcd #(
      .DIGITS(CAR_LEN_DIGITS),
      .BITS  ($bits(car_counter_t))
  ) bin_to_bcd_module (
      .bin(car_count),
      .bcd(bcd)
  );

  // Per-digit encoded nibble and cathode pattern
  logic  [3:0] encoded[CAR_LEN_DIGITS];
  byte_t       cathode[CAR_LEN_DIGITS];

  // Instantiate a decoder per digit
  genvar i;
  generate
    for (i = 0; i < CAR_LEN_DIGITS; i++) begin : decoders
      dec_cat_map dec_cat_map_inst (
          .encoded(encoded[i]),
          .cathode(cathode[i])
      );
    end
  endgenerate

  always_comb begin
    // Break BCD into nibbles
    foreach (encoded[i]) encoded[i] = bcd[i*4+:4];
    foreach (cathode[i]) begin      
       car_lan_seg_display[i*CATHODS+:CATHODS] = cathode[i];
    end    
   end 

endmodule
