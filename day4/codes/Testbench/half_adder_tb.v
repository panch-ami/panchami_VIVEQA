//Half adder code
`timescale 1ns / 1ps
// half adder testbench
// Create Date: 06/25/2026 03:06:22 PM
// Module Name: half_adder_tb



module half_adder_tb();
reg a,b;
wire sum,carry;
half_adder dut(.a(a),.b(b),.sum(sum),.carry(carry)); //half_adder dut(a,b,sum,carry)
initial begin  //executes only once and starts at 0ns
a=1'b0;b=1'b0;
#10;
a=1'b0;b=1'b1;
#10;
a=1'b1;b=1'b0;
#10;
a=1'b1;b=1'b1;
#10 $finish;
end
endmodule
