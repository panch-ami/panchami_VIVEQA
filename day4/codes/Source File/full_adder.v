`timescale 1ns / 1ps
// Full adder using 2 half adders
// Create Date: 06/25/2026 03:28:24 PM

// Module Name: full_adder



module full_adder(a,b,cin,sum,carry);
input a,b,cin;
output sum,carry;
wire sum1,carry1,carry2;
half_adder ha1(a,b,sum1,carry1);
half_adder ha2(sum1,cin,sum,carry2);
or(carry,carry1,carry2);

endmodule
