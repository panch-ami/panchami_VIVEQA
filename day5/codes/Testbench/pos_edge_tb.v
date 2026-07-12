`timescale 1ns / 1ps

module pos_edge_tb;
reg clk,in;
wire in_delay;
wire out;

pos_edge_id uut(clk,in,in_delay,out);
 initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
 
 initial begin
 in = 0;
 #12;
 in = 1; 
 #10;
 in = 1; 
 #10;
 in = 0; 
 #10;
 in = 0; 
 #10;
 in = 1; 
 #20;
 $finish;
 end
endmodule