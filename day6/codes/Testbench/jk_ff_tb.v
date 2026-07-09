`timescale 1ns / 1ps
// testbench for jk flip flop
// Create Date: 06/29/2026 03:49:08 PM



module jk_ff_tb();
reg clk,rst;
reg J,K;
wire Q,Qb;

jk_ff dut(clk,rst,J,K,Q,Qb);

always begin
        #5 clk = ~clk;
    end

    initial begin
        
        clk = 0;
        rst = 1; 
        J = 0;
        K = 0;

        #15 rst = 0;

        #10 J = 0; K = 0;

        #10 J = 1; K = 0;

        #10 J = 0; K = 0;

        #10 J = 0; K = 1;

        #10 J = 1; K = 1;
        #30; 

        rst = 1;
        #10 rst = 0;

       
        #10 $finish;
    end
    initial begin
        $monitor("Time=%0t | rst=%b | J=%b K=%b | Q=%b Qb=%b", $time, rst, J, K, Q, Qb);
    end

endmodule
