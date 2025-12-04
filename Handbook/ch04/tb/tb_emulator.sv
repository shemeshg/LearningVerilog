`timescale 1ns / 10ps
module tb_emulator;
  import types_pkg::*;

  logic clk = 0;
  // Clock generator runs forever
  always #100 clk = ~clk;

  logic rst;
  initial begin
    rst = 1;
    #1;
    rst = 0;
  end

  localparam BITS = 16;

  word_t     LED_TB;
  word_t     SW_TB;
  opr_mode_t SELECTOR_TB;


  logic      BTNC_TB;
  logic      BTNU_TB;
  logic      BTNL_TB;
  logic      BTNR_TB;
  logic      BTND_TB;

  select_action #() select_action_inst (
      .SELECTOR(SELECTOR_TB),
      .SW(SW_TB),
      .LED(LED_TB)
  );


  int fdw_led;
  int fdr_sw;
  integer ret;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
    end else begin
      //#1000000000;
      #100000000;
      #10ns;

      fdw_led = $fopen("/Volumes/RAM_Disk_4G/tmpFifo/myLeds", "w");
      if (fdw_led) begin
        $fwrite(fdw_led, "Time: %0t | SW_TB: %b | Selector: %s | LED_TB: %b\n", $time, SW_TB,
                SELECTOR_TB.name(), LED_TB);
        $fclose(fdw_led);
      end else begin
        $display("ERROR: Could not open file!");
      end

      fdr_sw = $fopen("/Volumes/RAM_Disk_4G/tmpFifo/mySw", "r");
      if (fdr_sw == 0) begin
        $display("ERROR: could not open file");
      end else begin
        while (!$feof(
            fdr_sw
        )) begin
          ret = $fscanf(fdr_sw, "%b", SW_TB);
          if (ret == 1) begin
          end
        end
        $fclose(fdr_sw);
      end

      fdr_sw = $fopen("/Volumes/RAM_Disk_4G/tmpFifo/myBtns", "r");
      if (fdr_sw == 0) begin
        $display("ERROR: could not open file");
      end else begin
        while (!$feof(
            fdr_sw
        )) begin
          ret = $fscanf(fdr_sw, "%b %b %b %b %b %b", rst, BTNU_TB, BTNL_TB, BTNC_TB, BTNR_TB, BTND_TB);
          if (ret == 1) begin
          end
        end
        $fclose(fdr_sw);
      end

    end
  end


  always_comb begin
    case (1'b1)
      BTNC_TB: SELECTOR_TB  = MUL;
      BTNU_TB: SELECTOR_TB  = LEADING_ONES;
      BTND_TB: SELECTOR_TB  = COUNT_ONES;
      BTNL_TB: SELECTOR_TB  = ADD;
      BTNR_TB: SELECTOR_TB  = SUB;
      default: SELECTOR_TB = RESET;
    endcase
  end

  initial begin

    @(negedge rst);

    // Set a default mode
    SELECTOR_TB = ADD;
    SW_TB = 16'd0;

    BTNC_TB = 0;
    BTNU_TB = 0;
    BTNL_TB = 0;
    BTNR_TB = 0;
    BTND_TB = 0;

  end


endmodule
