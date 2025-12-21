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

    // PWM counter (0..255)
    reg [7:0] pwm = 0;

    // Fade counter (0..255) over 1 second
    reg [31:0] fade_counter = 0;
    reg [7:0] fade_value = 0;

    // Color state (0..7)
    reg [2:0] state = 0;

    // PWM generator
    always @(posedge CLK100MHZ) begin
        pwm <= pwm + 1;
    end

    // Fade timing
    always @(posedge CLK100MHZ) begin
        if (fade_counter == ONE_SEC/256 - 1) begin
            fade_counter <= 0;
            fade_value <= fade_value + 1;

            if (fade_value == 8'hFF) begin
                fade_value <= 0;
                state <= state + 1;
            end
        end else begin
            fade_counter <= fade_counter + 1;
        end
    end

    // Color lookup table (scaled by fade_value)
    reg [7:0] R_target, G_target, B_target;

    always @(*) begin
        case (state)
            3'd0: begin R_target=0;         G_target=0;         B_target=0;         end // Black
            3'd1: begin R_target=fade_value; G_target=0;         B_target=0;         end // Red
            3'd2: begin R_target=0;         G_target=fade_value; B_target=0;         end // Green
            3'd3: begin R_target=0;         G_target=0;         B_target=fade_value; end // Blue
            3'd4: begin R_target=fade_value; G_target=fade_value; B_target=0;        end // Yellow
            3'd5: begin R_target=0;         G_target=fade_value; B_target=fade_value; end // Cyan
            3'd6: begin R_target=fade_value; G_target=0;         B_target=fade_value; end // Magenta
            3'd7: begin R_target=fade_value; G_target=fade_value; B_target=fade_value; end // White
        endcase
    end

    // PWM compare → actual LED outputs
    always @(*) begin
        LED16_R = (pwm < R_target);
        LED16_G = (pwm < G_target);
        LED16_B = (pwm < B_target);

        LED17_R = LED16_R;
        LED17_G = LED16_G;
        LED17_B = LED16_B;
    end


endmodule