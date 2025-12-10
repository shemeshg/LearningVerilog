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

  word_t  LED_TB;
  word_t  SW_TB;


  logic   BTNC_TB;
  logic   BTNU_TB;
  logic   BTNL_TB;
  logic   BTNR_TB;
  logic   BTND_TB;

  logic   BTNC_DEB;
  logic   BTNU_DEB;
  logic   BTNL_DEB;
  logic   BTNR_DEB;
  logic   BTND_DEB;

  display_t display;

    unbounce_btn #(.WAIT_COUNT(3)) deb_btnC (
    .CPU_RESET(rst),
    .CLOCK(clk),
    .BTN_IN(BTNC_TB),
    .BTN_OUT(BTNC_DEB)
  );

  unbounce_btn #(.WAIT_COUNT(3)) deb_btnU (
    .CPU_RESET(rst),
    .CLOCK(clk),
    .BTN_IN(BTNU_TB),
    .BTN_OUT(BTNU_DEB)
  );

  unbounce_btn #(.WAIT_COUNT(3)) deb_btnL (
    .CPU_RESET(rst),
    .CLOCK(clk),
    .BTN_IN(BTNL_TB),
    .BTN_OUT(BTNL_DEB)
  );

  unbounce_btn #(.WAIT_COUNT(3)) deb_btnR (
    .CPU_RESET(rst),
    .CLOCK(clk),
    .BTN_IN(BTNR_TB),
    .BTN_OUT(BTNR_DEB)
  );

  unbounce_btn #(.WAIT_COUNT(3)) deb_btnD (
    .CPU_RESET(rst),
    .CLOCK(clk),
    .BTN_IN(BTND_TB),
    .BTN_OUT(BTND_DEB)
  );


  word_t SW_DEB; 
  unbounce_array debouncer (
    .CPU_RESET(rst),
    .CLOCK(clk),
    .BTN_IN(SW_TB),
    .BTN_OUT(SW_DEB)
  );

  integer ret;
  select_btn_action #() select_btn_action_inst (
      .SW(SW_DEB),
      .LED(LED_TB),
      .CPU_RESETN(rst),
      .CLOCK(clk),
      .BTNC(BTNC_DEB),
      .BTNU(BTNU_DEB),
      .BTNL(BTNL_DEB),
      .BTNR(BTNR_DEB),
      .BTND(BTND_DEB)
  );


  logic [DIGITS*4-1:0] bcd;
  bin_to_bcd bin_to_bcd_module (
      .bin(LED_TB),
      .bcd(bcd)
  );
  logic [3:0] encoded;
  byte_t cathode;
  dec_cat_map dec_cat_map_module (
      .encoded(encoded),
      .cathode(cathode)
  );

  int fdw_led;
  int fdr_sw;

  always @(posedge clk) begin

    //#1000000000;
    #1000000;
    #10ns;

    fdw_led = $fopen("/Volumes/RAM_Disk_4G/tmpFifo/myLeds", "w");
    if (fdw_led) begin
      $fwrite(fdw_led, "Time: %0t | SW_TB: %b | LED_TB: %b\n", $time, SW_TB, LED_TB);
      $fclose(fdw_led);
    end else begin
      $display("ERROR: Could not open file!");
    end

    fdw_led = $fopen("/Volumes/RAM_Disk_4G/tmpFifo/my7SegDispllay", "w");
    if (fdw_led) begin
      foreach (display[i]) begin
        
        encoded = bcd[i*4+:4];
        #1;  // wait one timestep for cathode to update
        display[i] = cathode;

        $fwrite(fdw_led,"%08b %b \n", 8'b1 << i, display[i]);
      end
      
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
        ret =
            $fscanf(fdr_sw, "%b %b %b %b %b %b", rst, BTNU_TB, BTNL_TB, BTNC_TB, BTNR_TB, BTND_TB);
        if (ret == 1) begin
        end
      end
      $fclose(fdr_sw);
    end

  end




  initial begin

    @(negedge rst);

    SW_TB   = 16'd0;

    BTNC_TB = 0;
    BTNU_TB = 0;
    BTNL_TB = 0;
    BTNR_TB = 0;
    BTND_TB = 0;

    foreach (display[i]) begin
      display[i] = 8'hFF;  // 11111111
    end
  end


endmodule