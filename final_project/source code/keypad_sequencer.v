`timescale 1ns / 1ps

// ==================================================================================
// keypad_sequencer.v
//
// Manages the input flow from a 16-bit one-hot encoded button array.
// Sequences 1st press (Source) and 2nd press (Target).
// Instantiates your custom display_no module to handle translation.
// ==================================================================================

module keypad_sequencer(
    input  wire        clk,
    input  wire        rst_btn,
    input  wire [15:0] raw_buttons,
    
    output reg   [3:0] src_node,
    output reg   [3:0] tgt_node,
    output reg         start_calc,
    output reg         sys_rst,
    output wire  [1:0] seq_state_out    // NEW
);
    // --- Debounce Logic Registers ---
    reg [15:0] btn_sync_0;
    reg [15:0] btn_sync_1;
    reg [19:0] debounce_timer;
    reg [15:0] clean_buttons;
    reg [15:0] last_clean_buttons;
    
    // --- Decoded Output Wire from your Module ---
    wire [3:0] decoded_node;
    
    // --- Hierarchical Instantiation of your provided Module ---
    display_no decoder_inst (
        .button(clean_buttons), 
        .led(decoded_node) 
    );

    // --- Sequencer State Machine Register ---
    // 2'b00 = Waiting for Source Node
    // 2'b01 = Waiting for Target Node
    // 2'b10 = Locked/Calculating (Waiting for a reset to clear)
    reg [1:0] seq_state;

    always @(posedge clk) begin
        if (rst_btn) begin
            btn_sync_0         <= 16'd0;
            btn_sync_1         <= 16'd0;
            debounce_timer     <= 20'd0;
            clean_buttons      <= 16'd0;
            last_clean_buttons <= 16'd0;
            src_node           <= 4'd0;
            tgt_node           <= 4'd0;
            start_calc         <= 1'b0;
            sys_rst            <= 1'b0;
            seq_state          <= 2'b00;
        end else begin
            // 1. Two-stage register pipeline to synchronize external asynchronous button signals
            btn_sync_0 <= raw_buttons;
            btn_sync_1 <= btn_sync_0;
            
            // 2. Multi-Press Detection Logic (Simultaneous press handler)
            // Mathematical check: if (val & (val - 1)) != 0, it means multiple bits are high.
            // If two or more buttons are down together, force a system reset pulse.
            if (btn_sync_1 != 16'd0 && (btn_sync_1 & (btn_sync_1 - 16'd1)) != 16'd0) begin
                sys_rst   <= 1'b1;
                seq_state <= 2'b00; // Snap back to waiting for the first node input
            end else begin
                sys_rst   <= 1'b0;
            end

            // 3. Glitch Filtering / Debounce Counter
            // The counter increments only if the input changes. It must stay stable for 
            // 1,000,000 clock ticks (10 milliseconds at 100MHz) to change the clean state.
            if (btn_sync_1 != clean_buttons) begin
                debounce_timer <= debounce_timer + 20'd1;
                if (debounce_timer == 20'd1_000_000) begin
                    clean_buttons  <= btn_sync_1;
                    debounce_timer <= 20'd0;
                end
            end else begin
                debounce_timer <= 20'd0;
            end

            // 4. Input State Sequencer
            start_calc         <= 1'b0; // Default state is low (1-cycle edge generation)
            last_clean_buttons <= clean_buttons;
            
            // Look for a rising edge on a debounced, clean keypress
            if (clean_buttons != 16'd0 && last_clean_buttons == 16'd0 && !sys_rst) begin
                case (seq_state)
                    2'b00: begin
                        src_node  <= decoded_node; // Capture output from display_no
                        seq_state <= 2'b01;       // Advance state to wait for target
                    end
                    
                    2'b01: begin
                        tgt_node   <= decoded_node; // Capture output from display_no
                        start_calc <= 1'b1;         // Fire the processing calculation pulse
                        seq_state  <= 2'b10;        // Lock sequencer inputs until a reset occurs
                    end
                    
                    2'b10: begin
                        // Do nothing. The engine is running or reporting data. 
                        // To clear, trigger the two-button multi-press reset sequence.
                    end
                    
                    default: seq_state <= 2'b00;
                endcase
            end
        end
    end
assign seq_state_out = seq_state;
endmodule