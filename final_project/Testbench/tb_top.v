`timescale 1ns / 1ps

module tb_top;

    reg         clk;
    reg         rst_btn;
    reg  [15:0] buttons;
    wire        uart_txd;

    top dut (
        .clk(clk),
        .rst_btn(rst_btn),
        .buttons(buttons),
        .uart_txd(uart_txd)
    );

    always #5 clk = ~clk;

    task press_button;
        input [15:0] button_mask;
        begin
            buttons = button_mask;
            #12_000_000; 
            buttons = 16'd0;
            #12_000_000; 
        end
    endtask

    // Automated loop task using bit-shifting for the masks
    task run_auto_test;
        input integer src_id;
        input integer tgt_id;
        begin
            $display("\n=======================================================");
            $display("TESTING ROUTE: Source Node %0d -> Target Node %0d", src_id, tgt_id);
            $display("=======================================================");

            buttons = 16'h0003; 
            #200;
            buttons = 16'd0;
            #200_000; 
            wait(dut.fsm_done == 1'b0);

            // Shift a '1' to the correct bit position to create the 16-bit mask
            press_button(1 << src_id);
            press_button(1 << tgt_id);

            wait(dut.fsm_done == 1'b1);
            #10; 
            
            $display(">> DISTANCE: %0d km", dut.memory_state_inst.dist_mem[dut.tgt_node]);
            $display(">> PATH SEQUENCE (UART): ");

            #5_000_000;
        end
    endtask

    integer s, t;

    initial begin
        $timeformat(-9, 0, " ns", 12);
        clk = 0;
        rst_btn = 1;
        buttons = 16'd0;
        #200; rst_btn = 0; #200;

       for (s = 0; s < 16; s = s + 1) begin
            // By starting 't' at 's + 1', you never test a node against itself,
            // and you never test a reverse route you've already covered!
            for (t = s + 1; t < 16; t = t + 1) begin
                run_auto_test(s, t);
            end
        end

        $finish;
    end

    always @(posedge clk) begin
        if (dut.tx_start && !dut.tx_busy) $write("%c", dut.tx_data);
    end
    always @(posedge clk) begin
        if (dut.fsm_done && dut.reporter_inst.state == 5 && dut.reporter_inst.stack_ptr == 0) begin
            $display(""); 
            wait(dut.fsm_done == 1'b0); 
        end
    end

endmodule
