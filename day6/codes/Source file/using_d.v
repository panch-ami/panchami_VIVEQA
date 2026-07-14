`timescale 1ns / 1ps
// code for implementing jk, and t ff using d ff
// Create Date: 06/29/2026 04:54:31 PM

module using_d(a,b,m,clk,rst,q,qb);
input a,b,clk,rst;
input [1:0]m;
output  q;
output qb;
reg din;
 d_ff d1(din,clk,rst,q,qb);
always @(*) begin
case(m) 
2'b00: din =a;
2'b01: din =a^q;
2'b10: din =a&q | ~b&qb;
default din =1'b0;
endcase 
end
endmodule
