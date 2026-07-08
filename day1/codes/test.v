//Simple and gate code
`timescale 1ns / 1ps

module test(
    input a,
    input b,
    output y
    );
    
    assign y=a&b;
endmodule
