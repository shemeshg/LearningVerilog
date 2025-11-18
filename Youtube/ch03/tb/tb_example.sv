`timescale 1ns/10ps
module tb_example;
reg A,B,C,D,E,F; 
wire Y;
example DUT(A,B,C,D,E,F,Y);

initial begin
    $dumpfile("wave.vcd");
    $dumpvars (0,tb_example);
    // Use $strobe instead of $monitor


    #5 A=1; B=0; C=0; D=1; E=0; F=0;
    #5 $display ($time,"A=%b, B=%b, C=%b, D=%b, E=%b, F=%b, Y=%b",
        A,B,C,D,E,F,Y);
    #5 A=0; B=0; C=1; D=1; E=0; F=0;
    #5 $display ($time,"A=%b, B=%b, C=%b, D=%b, E=%b, F=%b, Y=%b",
        A,B,C,D,E,F,Y);
    #5 A=1; C=0;
    #5 F=1;
    #5 $finish;
end
endmodule