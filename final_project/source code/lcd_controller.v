`timescale 1ns / 1ps
// =============================================================
// lcd_controller.v
//
// Drives a 16x2 HD44780-style character LCD in 8-bit mode,
// write-only (R/W tied low, no busy-flag polling -- uses fixed
// conservative time delays instead, sized for a 24MHz clk).
//
// Shows one of 5 canned two-line messages selected by msg_sel,
// and automatically redraws whenever msg_sel changes value.
// =============================================================
module lcd_controller #(
    parameter CLK_HZ = 24_000_000
)(
    input  wire       clk,
    input  wire       rst,
    input  wire [2:0] msg_sel,   // which message to show (0-4)

    output reg         lcd_rs,
    output reg         lcd_rw,   // tied low always -- write only
    output reg         lcd_e,
    output reg  [7:0]  lcd_data
);

    // -----------------------------------------------------------
    // Timing constants (in clock cycles) -- generous on purpose
    // -----------------------------------------------------------
    localparam integer T_POWERON   = (CLK_HZ / 1000) * 20;  // 20ms power-on wait
    localparam integer T_LONG_CMD  = (CLK_HZ / 1000) * 3;   // 3ms  (clear/home need >1.64ms)
    localparam integer T_SHORT_CMD = (CLK_HZ / 1000000) * 100; // 100us (most commands/chars need <43us)
    localparam integer T_E_PULSE   = 20;                     // >450ns E pulse width @24MHz (~20 cyc)

    // -----------------------------------------------------------
    // Message ROM: 2 lines x 16 chars, selected by msg_sel
    // -----------------------------------------------------------
    function [7:0] msg_char;
        input [2:0] sel;
        input       line;      // 0 = line1, 1 = line2
        input [3:0] col;       // 0-15
        reg [8*16-1:0] l;
        begin
            case ({sel, line})
                4'b000_0: l = "Welcome to Path ";
                4'b000_1: l = "  Finder   ";
                4'b001_0: l = "Enter Source    ";
                4'b001_1: l = "Node (0-F)      ";
                4'b010_0: l = "Enter Dest.     ";
                4'b010_1: l = "Node (0-F)      ";
                4'b011_0: l = "Calculating...  ";
                4'b011_1: l = "                ";
                4'b100_0: l = "Done! Check UART";
                4'b100_1: l = "for route       ";
                default:  l = "                ";
            endcase
            // char at col 0 is the leftmost = MSB byte of l
            msg_char = l[(15-col)*8 +: 8];
        end
    endfunction

    // -----------------------------------------------------------
    // FSM
    // -----------------------------------------------------------
    localparam S_POWERON    = 0,
               S_FUNC_SET   = 1,
               S_DISP_OFF   = 2,
               S_CLEAR      = 3,
               S_ENTRY_MODE = 4,
               S_DISP_ON    = 5,
               S_SET_ADDR1  = 6,
               S_WRITE_L1   = 7,
               S_SET_ADDR2  = 8,
               S_WRITE_L2   = 9,
               S_IDLE_WAIT  = 10,
               S_PULSE_E    = 11;   // shared sub-state: strobe E, then go to WAIT

    reg [3:0]  state, return_state;
    reg [31:0] delay_cnt;
    reg [31:0] delay_target;
    reg [3:0]  char_idx;
    reg [2:0]  msg_sel_shown;      // last message actually drawn
    reg        pending_cmd;        // 1 = next byte is a command (RS=0), 0 = data (RS=1)
    reg [7:0]  next_byte;

    task start_pulse(input [3:0] ret_state, input [31:0] wait_cycles);
        begin
            return_state <= ret_state;
            delay_target <= wait_cycles;
            state        <= S_PULSE_E;
        end
    endtask

    always @(posedge clk) begin
        lcd_rw <= 1'b0; // always write-only

        if (rst) begin
            state         <= S_POWERON;
            delay_cnt     <= 0;
            delay_target  <= T_POWERON;
            char_idx      <= 0;
            msg_sel_shown <= 3'b111; // force a redraw after reset
            lcd_e         <= 0;
            lcd_rs        <= 0;
            lcd_data      <= 8'h00;
        end else begin
            case (state)
                // ---- power-on wait ----
                S_POWERON: begin
                    if (delay_cnt < delay_target)
                        delay_cnt <= delay_cnt + 1;
                    else begin
                        delay_cnt <= 0;
                        lcd_rs   <= 0;
                        lcd_data <= 8'h38; // function set: 8-bit, 2-line, 5x8
                        start_pulse(S_FUNC_SET, T_LONG_CMD);
                    end
                end

                S_FUNC_SET: begin
                    lcd_rs   <= 0;
                    lcd_data <= 8'h08; // display off
                    start_pulse(S_DISP_OFF, T_SHORT_CMD);
                end

                S_DISP_OFF: begin
                    lcd_rs   <= 0;
                    lcd_data <= 8'h01; // clear display
                    start_pulse(S_CLEAR, T_LONG_CMD);
                end

                S_CLEAR: begin
                    lcd_rs   <= 0;
                    lcd_data <= 8'h06; // entry mode: increment, no shift
                    start_pulse(S_ENTRY_MODE, T_SHORT_CMD);
                end

                S_ENTRY_MODE: begin
                    lcd_rs   <= 0;
                    lcd_data <= 8'h0C; // display on, cursor off, blink off
                    start_pulse(S_DISP_ON, T_SHORT_CMD);
                end

                S_DISP_ON: begin
                    // init complete -- fall into normal redraw logic
                    state <= S_IDLE_WAIT;
                end

                // ---- redraw trigger ----
                S_IDLE_WAIT: begin
                    if (msg_sel_shown != msg_sel) begin
                        msg_sel_shown <= msg_sel;
                        char_idx      <= 0;
                        lcd_rs        <= 0;
                        lcd_data      <= 8'h80; // set DDRAM addr = line1, col0
                        start_pulse(S_SET_ADDR1, T_SHORT_CMD);
                    end
                end

                S_SET_ADDR1: begin
                    char_idx <= 0;
                    state    <= S_WRITE_L1;
                end

                S_WRITE_L1: begin
                    lcd_rs   <= 1;
                    lcd_data <= msg_char(msg_sel_shown, 1'b0, char_idx);
                    if (char_idx == 15)
                        start_pulse(S_SET_ADDR2, T_SHORT_CMD);
                    else begin
                        start_pulse(S_WRITE_L1, T_SHORT_CMD);
                        char_idx <= char_idx + 1;
                    end
                end

                S_SET_ADDR2: begin
                    lcd_rs   <= 0;
                    lcd_data <= 8'hC0; // set DDRAM addr = line2, col0
                    char_idx <= 0;
                    start_pulse(S_WRITE_L2, T_SHORT_CMD);
                end

                S_WRITE_L2: begin
                    lcd_rs   <= 1;
                    lcd_data <= msg_char(msg_sel_shown, 1'b1, char_idx);
                    if (char_idx == 15)
                        start_pulse(S_IDLE_WAIT, T_SHORT_CMD);
                    else begin
                        start_pulse(S_WRITE_L2, T_SHORT_CMD);
                        char_idx <= char_idx + 1;
                    end
                end

                // ---- shared E-strobe + delay sub-state ----
                S_PULSE_E: begin
                    if (delay_cnt < T_E_PULSE) begin
                        lcd_e     <= 1'b1;
                        delay_cnt <= delay_cnt + 1;
                    end else if (delay_cnt < T_E_PULSE + delay_target) begin
                        lcd_e     <= 1'b0;
                        delay_cnt <= delay_cnt + 1;
                    end else begin
                        delay_cnt <= 0;
                        state     <= return_state;
                    end
                end

                default: state <= S_POWERON;
            endcase
        end
    end

endmodule