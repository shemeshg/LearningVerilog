// Find the leading ones (highest bit set) in a vector.
`timescale 1ns/10ps



module tb_leading_ones;

logic clk = 0;
always #0.5 clk = ~clk; 
logic rst;
initial begin
    rst = 1;
    #1;
    rst = 0;
end

localparam BITS         = 16;

logic [$clog2(BITS+1)-1:0] LED_TB;
logic [BITS-1:0]       SW_TB;
leading_ones #(.BITS(BITS)) leading_ones_inst(
    .clk(clk),
    .rst(rst),
    .SW(SW_TB),
    .LED(LED_TB)
);

initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_leading_ones.SW_TB);    
    $dumpvars(0, tb_leading_ones.LED_TB);   
    $printtimescale(tb_leading_ones);

    @(negedge rst); // wait until reset is deasserted
    @(posedge clk); // wait one more cycle to ensure DUT is ready

    

    repeat (12) begin
        integer pos = $urandom_range(0, BITS - 1);
        SW_TB = 0;
        while (pos >= 0) begin
            SW_TB = SW_TB | (1 << pos);
            if (pos == 0)
                break;
            pos = $urandom_range(0, pos - 1);
        end
        
        @(posedge clk);
    end


    @(posedge clk);
    SW_TB = 0;


    $display("Time now: %0t", $time);
    $display("PASS: tb_leading_ones PASSED!");
    $finish;
end

logic [BITS-1:0] SW_TB_d;
always_ff @(posedge clk) begin
  SW_TB_d <= SW_TB;
end

always @(posedge clk) begin
    
   automatic int  expected_count = 0;

  for (int i = 0; i < BITS; i++) begin
    if (SW_TB_d[i] == 1) begin
      expected_count = i;
    end
  end

 $display("At %0t: SW_TB_d = %h, expected = %0d, actual = %0d",
         $time, SW_TB_d, expected_count, LED_TB);

  if (expected_count !== LED_TB) begin
    $error("Mismatch: SW_TB_d = %h, expected count = %0d, got LED_TB = %0d",
           SW_TB_d, expected_count, LED_TB);
    $stop; // optional: halt simulation for inspection
  end
end // always @ (SW_TB)

endmodule // tb