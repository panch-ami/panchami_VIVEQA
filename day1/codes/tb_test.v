// testbench for and gate
// Create Date: 06/24/2026 04:34:51 PM
`timescale 1ns / 1ps

module tb_test(

    );
    reg a_tb;
    reg b_tb;
    wire y_tb;
    
    test u0(
    .a(a_tb),
    .b(b_tb),
    .y(y_tb)
    );
   
   initial begin 
    a_tb=0; b_tb=0;
    #10;
     a_tb=0; b_tb=1;
    #10;
     a_tb=1; b_tb=0;
    #10;
     a_tb=1; b_tb=1;
    #10;
    
    end
endmodule
