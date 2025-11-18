`timescale 1ns/10ps
module tb_example;



reg A,B,C,D,E,F; 
wire Y;
example DUT(A,B,C,D,E,F,Y);



task run_simulation;
    #4
    $display ($time,"A=%b, B=%b, C=%b, D=%b, E=%b, F=%b, Y=%b",
        A,B,C,D,E,F,Y);
endtask
initial begin
    $dumpfile("wave.vcd");
    $dumpvars (0,tb_example);

    A=1; B=0; C=0; D=1; E=0; F=0;
    run_simulation;
    
    A=0; B=0; C=1; D=1; E=0; F=0;
    run_simulation;
    
    A=1; C=0;

    run_simulation;

    F=1;


    run_simulation;

    $finish;
end
endmodule