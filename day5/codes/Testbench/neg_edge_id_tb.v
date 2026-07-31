`timescale 1ns/1ps

module neg_edge_id_tb;

    reg clk;
    reg in;
    wire in_delay;
    wire out;

    // Instantiate DUT
    neg_edge_id dut (
        .clk(clk),
        .in(in),
        .in_delay(in_delay),
        .out(out)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin

        in = 0;
        @(negedge clk);              // align changes away from clock edge

        // Case 1: rising edge on 'in' -> out should NOT pulse
        in = 1;
        repeat (3) @(negedge clk);

        // Case 2: falling edge on 'in' -> out SHOULD pulse
        in = 0;
        repeat (3) @(negedge clk);

        // Case 3: quick falling pulse
        in = 1;
        @(negedge clk);
        in = 0;
        repeat (3) @(negedge clk);

        // Case 4: stays low, no edge -> out should stay 0
        repeat (3) @(negedge clk);

        // Case 5: another rising then falling
        in = 1;
        repeat (2) @(negedge clk);
        in = 0;
        repeat (3) @(negedge clk);

        $display("Simulation complete.");
        $finish;
    end

    // Monitor
    initial begin
        $monitor("t=%0t | clk=%b in=%b in_delay=%b out=%b",
                   $time, clk, in, in_delay, out);
    end

endmodule