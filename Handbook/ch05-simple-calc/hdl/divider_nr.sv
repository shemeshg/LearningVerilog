`timescale 1ns / 10ps
module divider_nr #(
    parameter BITS = 16
) (
    input  wire                     clk,
    input  wire                     reset,
    input  wire                     start,
    input  wire unsigned [BITS-1:0] dividend,
    input  wire unsigned [BITS-1:0] divisor,

    output logic                     done,
    output logic unsigned [BITS-1:0] quotient,
    output logic unsigned [BITS-1:0] remainder
);
    import types_pkg::*;

    // ------------------------------------------------------------
    // Internal signed versions (CRITICAL FIX)
    // ------------------------------------------------------------
    logic signed [BITS-1:0] divisor_s;
    logic signed [BITS:0]   int_remainder;

    assign divisor_s = signed'(divisor);

    // ------------------------------------------------------------
    // Leading‑ones result
    // ------------------------------------------------------------
    localparam BC = $clog2(BITS);
    typedef logic [BC:0] numbits_t;

    numbits_t num_bits_w;
    numbits_t num_bits;

    assign num_bits_w = numbits_t'( leading_ones_fn(dividend) );

    // ------------------------------------------------------------
    // FSM
    // ------------------------------------------------------------
    enum logic [3:0] {
        IDLE,
        INIT,
        LEFT_SHIFT,
        ADJ_REMAINDER0,
        ADJ_REMAINDER1,
        UPDATE_QUOTIENT,
        TEST_N,
        TEST_REMAINDER1,
        ADJ_REMAINDER2,
        DIV_DONE
    } state;

    initial state = IDLE;

    // ------------------------------------------------------------
    // Sequential logic
    // ------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            state         <= IDLE;
            done          <= 0;
            quotient      <= 0;
            int_remainder <= 0;
            num_bits      <= 0;
        end else begin
            done <= 0;

            case (state)

                IDLE: begin
                    if (start)
                        state <= INIT;
                end

                INIT: begin
                    // Align quotient with MSB of dividend
                    quotient      <= dividend << (BITS - num_bits_w);
                    int_remainder <= '0;
                    num_bits      <= num_bits_w;
                    state         <= LEFT_SHIFT;
                end

                LEFT_SHIFT: begin
                    // Shift remainder:quotient left by 1
                    {int_remainder, quotient} <= {int_remainder, quotient} << 1;

                    // Decide add or subtract based on sign
                    if (int_remainder[BITS])
                        state <= ADJ_REMAINDER0;  // negative → add divisor
                    else
                        state <= ADJ_REMAINDER1;  // positive → subtract divisor
                end

                ADJ_REMAINDER0: begin
                    int_remainder <= int_remainder + divisor_s;
                    state         <= UPDATE_QUOTIENT;
                end

                ADJ_REMAINDER1: begin
                    int_remainder <= int_remainder - divisor_s;
                    state         <= UPDATE_QUOTIENT;
                end

                UPDATE_QUOTIENT: begin
                    // Set LSB of quotient based on sign of remainder
                    quotient[0] <= ~int_remainder[BITS];
                    num_bits    <= num_bits - 1;
                    state       <= TEST_N;
                end

                TEST_N: begin
                    if (num_bits != 0)
                        state <= LEFT_SHIFT;
                    else
                        state <= TEST_REMAINDER1;
                end

                TEST_REMAINDER1: begin
                    if (int_remainder[BITS])
                        state <= ADJ_REMAINDER2;  // negative → final correction
                    else
                        state <= DIV_DONE;
                end

                ADJ_REMAINDER2: begin
                    int_remainder <= int_remainder + divisor_s;
                    state         <= DIV_DONE;
                end

                DIV_DONE: begin
                    done  <= 1;
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

    // ------------------------------------------------------------
    // Final remainder (unsigned)
    // ------------------------------------------------------------
    assign remainder = int_remainder[BITS-1:0];

endmodule
