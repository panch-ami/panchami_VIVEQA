`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2026 05:14:04 PM
// Design Name: 
// Module Name: using_d_tb
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


module using_d_tb();
reg a,b,clk,rst;
reg [1:0]m;
wire q,qb;

using_d dut(a,b,m,clk,rst,q,qb);

always begin
#5 clk=~clk;
end

initial begin
rst=1'b0;
#5  m=2'b00; a=1'b0 ;
#5   a=1'b1 ;
#5 m=2'b01; a=1'b0 ; 
#5   a=1'b0 ;

m=2'b10; a=1'b0 ; b=1'b0;
#5 a=1'b0 ; b=1'b1;
#5 a=1'b1 ; b=1'b0;
#5 a=1'b1 ; b=1'b1;

#5;$finish;

end

endmodule
