`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 04:48:08 PM
// Design Name: 
// Module Name: d_ff
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module d_ff(a,clk,rst,q,qb);
input a,clk,rst;
output reg q;
output qb;

always @(posedge clk)
begin
if(rst)
q<=1'b0;
else 
q<=a;
end
assign qb=~q;
endmodule
