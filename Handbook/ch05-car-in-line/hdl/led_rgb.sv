module led_rgb (
    input  wire        CLK100MHZ,

    input  wire [7:0]  r,
    input  wire [7:0]  g,
    input  wire [7:0]  b,
    input  wire [7:0]  brightness,

    output reg         LED_R,
    output reg         LED_G,
    output reg         LED_B
);

    // 8‑bit PWM counter (0..255)
    reg [7:0] pwm = 0;

    // PWM generator
    always @(posedge CLK100MHZ) begin
        pwm <= pwm + 1;
    end

    // Apply global brightness scaling
    wire [15:0] r_scaled = r * brightness;
    wire [15:0] g_scaled = g * brightness;
    wire [15:0] b_scaled = b * brightness;

    // Take upper 8 bits (divide by 256)
    wire [7:0] R_target = r_scaled[15:8];
    wire [7:0] G_target = g_scaled[15:8];
    wire [7:0] B_target = b_scaled[15:8];

    // PWM compare → LED outputs
    always @(*) begin
        LED_R = (pwm < R_target);
        LED_G = (pwm < G_target);
        LED_B = (pwm < B_target);
    end

endmodule
