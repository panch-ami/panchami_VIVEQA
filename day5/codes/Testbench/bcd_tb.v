`timescale 1ns / 1ps
// test bench for bcd to 7 segment
// Create Date: 06/26/2026 02:56:55 PM



module bcd_tb;

    reg [3:0] i;


    wire a, b, c, d, e, f, g, h;


    integer j;

    bcd_7segment uut (
        .i(i), 
        .a(a), 
        .b(b), 
        .c(c), 
        .d(d), 
        .e(e), 
        .f(f), 
        .g(g), 
        .h(h)
    );

   
    initial begin
        $monitor("Time = %0t | Input (i) = %4b (%0d) | Output {a,b,c,d,e,f,g,h} = %b%b%b%b%b%b%b%b", 
                 $time, i, i, a, b, c, d, e, f, g, h);
        for (j = 0; j < 10; j = j + 1) begin
            i = j;
            #10; 
        end
        i = 4'b1010;
        #10;
        $finish;
    end
endmodule
