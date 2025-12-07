module unbounce_btn (
    input  logic CPU_RESET,  // active-high reset
    input  logic CLOCK,
    input  logic BTN_IN,
    output logic BTN_OUT
);
  parameter int WAIT_COUNT = 3;

  typedef enum logic [1:0] {
    BTN_OFF        = 2'b00,
    BTN_BEFORE_ON  = 2'b01,
    BTN_ON         = 2'b10,
    BTN_BEFORE_OFF = 2'b11
  } btn_status_t;

  btn_status_t btn_status;
  int count;
  logic [1:0] button_sync;

  // Output decode
  always_comb begin
    case (btn_status)
      BTN_OFF, BTN_BEFORE_ON: BTN_OUT = 1'b0;
      BTN_ON, BTN_BEFORE_OFF: BTN_OUT = 1'b1;
      default:                BTN_OUT = 1'b0;
    endcase
  end

  always_ff @(posedge CLOCK or posedge CPU_RESET) begin
    if (CPU_RESET) begin
      btn_status  <= BTN_OFF;
      count       <= 0;
      button_sync <= 2'b00;  // 2‑stage synchronizer reset
    end else begin
      // 2‑stage synchronizer
      button_sync <= {button_sync[0], BTN_IN};

      // edge detection: rising or falling
      if (button_sync == 2'b01 && btn_status == BTN_OFF) begin
        btn_status <= BTN_BEFORE_ON;
      end else if (button_sync == 2'b10 && btn_status == BTN_ON) begin
        btn_status <= BTN_BEFORE_OFF;
      end else begin
        // stable fallback: recover if an edge was missed
        if (btn_status == BTN_ON && !button_sync[1]) btn_status <= BTN_BEFORE_OFF;
        else if (btn_status == BTN_OFF && button_sync[1]) btn_status <= BTN_BEFORE_ON;
      end

      // debounce counter logic
      case (btn_status)
        BTN_BEFORE_ON, BTN_BEFORE_OFF: begin
          count <= count + 1;
          if (count == WAIT_COUNT) begin
            btn_status <= (btn_status == BTN_BEFORE_ON) ? BTN_ON : BTN_OFF;
            count <= 0;
          end
        end
        default: count <= 0;
      endcase
    end
  end



  // Debug prints (simulation only)
  always_ff @(posedge CLOCK) begin
    $display("time=%0t | count=%0d | btn_status=%s | BTN_IN=%b | BTN_OUT=%b", $time, count,
             btn_status.name(), BTN_IN, BTN_OUT);
  end
endmodule
