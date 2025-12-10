module  dec_cat_map (
    input  [3:0] encoded,
    output reg [7:0] cathode
);

always @* begin
    case (encoded)
        4'h0: cathode = 8'b10000001;
        4'h1: cathode = 8'b11110011;
        4'h2: cathode = 8'b01001001;
        4'h3: cathode = 8'b01100001;
        4'h4: cathode = 8'b00110011;
        4'h5: cathode = 8'b00100101;
        4'h6: cathode = 8'b00000101;
        4'h7: cathode = 8'b11110000;
        4'h8: cathode = 8'b00000001;
        4'h9: cathode = 8'b00100001;
        default: cathode = 8'b11111111;
    endcase
end

endmodule