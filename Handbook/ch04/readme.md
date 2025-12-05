# The FPGA Programming Handbook – Second Edition (Chapter 4)

Repository link:  
[PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition – CH4](https://github.com/PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition/tree/main/CH4)

## Tasks


1. Detect when the button is pressed.

```verilog
logic [2:0] button_sync;
always @(posedge clk) begin
  button_sync <= button_sync << 1 | BTNC;
  if (button_sync[2:1] == 2'b01) 
    button_down <= '1;
  else 
    button_down <= '0;
end
```

2. Detect when the button has been pressed for N cycles.

3. Detect when the button has been released for N cycles.

4. Wrap the logic in a module with an input wire and an output wire.

5. Display the result on the 7-segment display.
