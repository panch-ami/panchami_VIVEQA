`timescale 1ns / 1ps
// Four bit adder using 4 fulladders 
// Create Date: 06/25/2026 04:22:27 PM
// Module Name: four_bit_adder



module four_bit_adder(a,b,m,sum,carry);
input [3:0]a,b;
input m;
output [3:0]sum;
output carry;

wire c1,c2,c3,d0,d1,d2,d3;
xor(d0,b[0],m);
xor(d1,b[1],m);
xor(d2,b[2],m);
xor(d3,b[3],m);
full_adder fa1(a[0],d0,m,sum[0],c1);
full_adder fa2(a[1],d1,c1,sum[1],c2);
full_adder fa3(a[2],d2,c2,sum[2],c3);
full_adder fa4(a[3],d3,c3,sum[3],carry);

endmodule
