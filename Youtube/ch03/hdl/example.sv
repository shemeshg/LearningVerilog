`timescale 1ns/10ps
module example (
   input A,
   input B,
   input C,
   input D,
   input E,
   input F,
   output Y // This line must *not* contain 'reg'
);
  wire t1, t2, t3;
  // Y is now implicitly a wire, compatible with the gate output
  nand #1 G1 (t1, A, B);
  and #2 G2 (t2, C, ~B, D);
  nor #1 G3 (t3, E, F);
  nand #1 G4 (Y, t1, t2, t3);

endmodule