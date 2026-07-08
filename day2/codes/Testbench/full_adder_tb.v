`timescale 1ns / 1ps
// Full adder testbench
// Create Date: 06/25/2026 03:36:46 PM
// Module Name: full_adder_tb



module full_adder_tb();
reg a,b,cin;
wire sum,carry;

full_adder dut(a,b,cin,sum,carry);
integer i;
initial begin
for(i=0;i<8;i=i+1) begin
{a,b,cin}=i;    //intger-32 bit reg&wire-1 bit time-32bit  
#5;
end
#5; $finish;
end
endmodule
