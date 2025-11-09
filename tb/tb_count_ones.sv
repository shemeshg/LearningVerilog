`timescale 1ns/ 100ps




module tb_count_ones;
logic clk = 0;
always #0.5 clk = ~clk; 
logic rst;
initial begin
    rst = 1;
    #1;
    rst = 0;
end

localparam BITS         = 16;

logic [$clog2(BITS+1)-1:0] count_ones_module;
logic [BITS-1:0]       SW_TB;
count_ones #(.BITS(BITS)) count_ones_inst(
    .clk(clk),
    .rst(rst),
    .SW(SW_TB),
    .LED(count_ones_module)
);




initial begin
    $dumpfile("wave.vcd");
    //$dumpvars(0, tb); // or use your top-level module name    
    $dumpvars(0, tb_count_ones.SW_TB);    
    $dumpvars(0, tb_count_ones.count_ones_module);   
    $printtimescale(tb_count_ones);

    @(negedge rst); // wait until reset is deasserted
    @(posedge clk); // wait one more cycle to ensure DUT is ready

    repeat (6) begin  
            
        SW_TB = $urandom_range(0, (1 << BITS) - 1);
        @(posedge clk); 
    end


    @(posedge clk);
    SW_TB = 0;

    // Extend simulation time to ensure waveform visibility
    //#10;

    $display("Time now: %0t", $time);
    $display("PASS: logic_ex test PASSED!");
    $finish;
end

logic [BITS-1:0] SW_TB_d;
always_ff @(posedge clk) begin
  SW_TB_d <= SW_TB;
end

always @(posedge clk) begin
    
   automatic int  expected_count = 0;

  for (int i = 0; i < BITS; i++) begin
    expected_count += SW_TB_d[i];
  end

 $display("At %0t: SW_TB_d = %h, expected = %0d, actual = %0d",
         $time, SW_TB_d, expected_count, count_ones_module);

  if (expected_count !== count_ones_module) begin
    $error("Mismatch: SW_TB_d = %h, expected count = %0d, got count_ones_module = %0d",
           SW_TB_d, expected_count, count_ones_module);
    $stop; // optional: halt simulation for inspection
  end
end // always @ (SW_TB)

endmodule // tb