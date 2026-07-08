`timescale 1ns / 1ps

// Fourbit adder testbench code
// Create Date: 06/25/2026 04:38:20 PM
// Module Name: four_bit_adder_tb



module four_bit_adder_tb();
reg [3:0]a,b;
reg m;
wire [3:0]sum;
wire carry;

four_bit_adder dut(a,b,m,sum,carry);
initial begin
m=0; 
a=4'd1;b=4'd2; #10;
a=4'd5;b=4'd5; #10;
 a=4'd10;b=4'd2; #10;
a=4'd5;b=4'd9; #10;
 a=4'd10;b=4'd4; #10;
 m=1;
 a=4'd1;b=4'd2; #10;
a=4'd5;b=4'd5; #10;
 a=4'd10;b=4'd2; #10;
a=4'd5;b=4'd9; #10;
 a=4'd10;b=4'd4; #10;
$finish;
end
initial begin
$monitor("Sum of a=%d and b=%d is %d and carry is %b",a,b,sum,carry);
end
endmodule
