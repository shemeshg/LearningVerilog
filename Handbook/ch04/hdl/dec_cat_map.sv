import types_pkg::*;
module  dec_cat_map (
    input  [3:0] encoded,
    output byte_t cathode
);

always @* begin
    case (encoded)
        4'h0: cathode = 8'b11000000;
        4'h1: cathode = 8'b11111001;
        4'h2: cathode = 8'b10100100;
        4'h3: cathode = 8'b10110000;
        4'h4: cathode = 8'b10011001;
        4'h5: cathode = 8'b10010010;
        4'h6: cathode = 8'b10000010;
        4'h7: cathode = 8'b11111000;
        4'h8: cathode = 8'b10000000;
        4'h9: cathode = 8'b10010000;
        default: cathode = 8'b11111111;
    endcase
end

endmodule