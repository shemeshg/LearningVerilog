module unbounce_array #(
    parameter int BITS       = 16,  // number of buttons
    parameter int WAIT_COUNT = 3    // debounce length
) (
    input  logic            CPU_RESET,  // active-high reset
    input  logic            CLOCK,
    input  logic [BITS-1:0] BTN_IN,     // raw button inputs
    output logic [BITS-1:0] BTN_OUT     // debounced outputs
);

  // Generate one unbounce_btn instance per bit
  genvar i;
  for (i = 0; i < BITS; i++) begin : gen_btn
    unbounce_btn #(
        .WAIT_COUNT(WAIT_COUNT)
    ) u_btn (
        .CPU_RESET(CPU_RESET),
        .CLOCK(CLOCK),
        .BTN_IN(BTN_IN[i]),
        .BTN_OUT(BTN_OUT[i])
    );
  end

endmodule
