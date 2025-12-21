module rgb_test (
    input  wire CLK100MHZ,

    output reg LED16_R,
    output reg LED16_G,
    output reg LED16_B,

    output reg LED17_R,
    output reg LED17_G,
    output reg LED17_B
);

    // 100 MHz → 1 second = 100,000,000 cycles
    `ifdef VERILATOR
    localparam integer ONE_SEC = 3096309;
    `else
    localparam integer ONE_SEC = 100_000_000;
    `endif

    integer counter = 0;   // enough bits for 100M
    reg [2:0]  state   = 0;   // 0..7 for 8 colors

    always @(posedge CLK100MHZ) begin
        // 1-second timer
        if (counter == ONE_SEC - 1) begin
            counter <= 0;
            state <= state + 1;
        end else begin
            counter <= counter + 1;
        end
    end

    // Color lookup table
    always @(*) begin
        case (state)
            3'd0: begin LED16_R=0; LED16_G=0; LED16_B=0; end // Black
            3'd1: begin LED16_R=1; LED16_G=0; LED16_B=0; end // Red
            3'd2: begin LED16_R=0; LED16_G=1; LED16_B=0; end // Green
            3'd3: begin LED16_R=0; LED16_G=0; LED16_B=1; end // Blue
            3'd4: begin LED16_R=1; LED16_G=1; LED16_B=0; end // Yellow
            3'd5: begin LED16_R=0; LED16_G=1; LED16_B=1; end // Cyan
            3'd6: begin LED16_R=1; LED16_G=0; LED16_B=1; end // Magenta
            3'd7: begin LED16_R=1; LED16_G=1; LED16_B=1; end // White
        endcase

        // LED17 mirrors LED16
        LED17_R = LED16_R;
        LED17_G = LED16_G;
        LED17_B = LED16_B;
    end

endmodule