`timescale 1ns / 1ps

module route_reporter(
    input  wire        clk,
    input  wire        rst,
    input  wire        fsm_done,
    input  wire  [3:0] tgt_node,
    input  wire  [3:0] src_node,
    input  wire [15:0] total_dist,    // The final shortest distance cost
    
    output reg   [3:0] prev_rd_addr,
    input  wire  [3:0] prev_rd_data,
    
    // Handshake with your uart_tx
    output reg         tx_start,
    output reg   [7:0] tx_data,
    input  wire        tx_busy,
    input  wire        tx_done
);

    reg [3:0] stack [0:15];
    reg [4:0] stack_ptr;
    reg [3:0] state;
    reg [3:0] curr_trace;
    reg [7:0] char_idx;
    reg [3:0] dist_print_step; // Added for distance printing sequence
    
    wire [3:0] d_thou, d_hund, d_tens, d_ones;
    
    // Instantiate BCD converter for printing the final distance
    bin2bcd bcd_inst (
        .bin(total_dist), 
        .thou(d_thou),
        .hund(d_hund),
        .tens(d_tens),
        .ones(d_ones)
    );
    
    // ASCII Decoder LUT for updated mapped towns (Max 8 Chars)
    function [7:0] get_ascii;
        input [3:0] node;
        input [2:0] char_pos;
        begin
            case (node)
                4'h0: case(char_pos) 0:get_ascii="U"; 1:get_ascii="d"; 2:get_ascii="u"; 3:get_ascii="p"; 4:get_ascii="i"; default:get_ascii=" "; endcase
                4'h1: case(char_pos) 0:get_ascii="B"; 1:get_ascii="r"; 2:get_ascii="a"; 3:get_ascii="h"; 4:get_ascii="m"; 5:get_ascii="v"; 6:get_ascii="a"; 7:get_ascii="r"; endcase
                4'h2: case(char_pos) 0:get_ascii="M"; 1:get_ascii="a"; 2:get_ascii="n"; 3:get_ascii="i"; 4:get_ascii="p"; 5:get_ascii="a"; 6:get_ascii="l"; default:get_ascii=" "; endcase
                4'h3: case(char_pos) 0:get_ascii="H"; 1:get_ascii="i"; 2:get_ascii="r"; 3:get_ascii="i"; 4:get_ascii="y"; 5:get_ascii="d"; 6:get_ascii="k"; 7:get_ascii="a"; endcase
                4'h4: case(char_pos) 0:get_ascii="S"; 1:get_ascii="e"; 2:get_ascii="e"; 3:get_ascii="t"; 4:get_ascii="h"; 5:get_ascii="n"; 6:get_ascii="d"; 7:get_ascii="i"; endcase
                4'h5: case(char_pos) 0:get_ascii="A"; 1:get_ascii="g"; 2:get_ascii="u"; 3:get_ascii="m"; 4:get_ascii="b"; 5:get_ascii="e"; default:get_ascii=" "; endcase
                4'h6: case(char_pos) 0:get_ascii="K"; 1:get_ascii="a"; 2:get_ascii="r"; 3:get_ascii="k"; 4:get_ascii="a"; 5:get_ascii="l"; 6:get_ascii="a"; default:get_ascii=" "; endcase
                4'h7: case(char_pos) 0:get_ascii="S"; 1:get_ascii="h"; 2:get_ascii="i"; 3:get_ascii="r"; 4:get_ascii="v"; 5:get_ascii="a"; default:get_ascii=" "; endcase
                4'h8: case(char_pos) 0:get_ascii="B"; 1:get_ascii="e"; 2:get_ascii="l"; 3:get_ascii="m"; 4:get_ascii="a"; 5:get_ascii="n"; default:get_ascii=" "; endcase
                4'h9: case(char_pos) 0:get_ascii="P"; 1:get_ascii="a"; 2:get_ascii="d"; 3:get_ascii="u"; 4:get_ascii="b"; 5:get_ascii="d"; 6:get_ascii="r"; 7:get_ascii="i"; endcase
                4'hA: case(char_pos) 0:get_ascii="M"; 1:get_ascii="a"; 2:get_ascii="n"; 3:get_ascii="g"; 4:get_ascii="l"; 5:get_ascii="o"; 6:get_ascii="r"; 7:get_ascii="e"; endcase
                4'hB: case(char_pos) 0:get_ascii="M"; 1:get_ascii="o"; 2:get_ascii="o"; 3:get_ascii="d"; 4:get_ascii="b"; 5:get_ascii="d"; 6:get_ascii="r"; 7:get_ascii="e"; endcase
                4'hC: case(char_pos) 0:get_ascii="U"; 1:get_ascii="j"; 2:get_ascii="i"; 3:get_ascii="r"; 4:get_ascii="e"; default:get_ascii=" "; endcase
                4'hD: case(char_pos) 0:get_ascii="D"; 1:get_ascii="h"; 2:get_ascii="a"; 3:get_ascii="r"; 4:get_ascii="m"; 5:get_ascii="s"; 6:get_ascii="t"; 7:get_ascii="l"; endcase
                4'hE: case(char_pos) 0:get_ascii="K"; 1:get_ascii="i"; 2:get_ascii="n"; 3:get_ascii="n"; 4:get_ascii="g"; 5:get_ascii="o"; 6:get_ascii="l"; 7:get_ascii="i"; endcase
                4'hF: case(char_pos) 0:get_ascii="C"; 1:get_ascii="h"; 2:get_ascii="e"; 3:get_ascii="r"; 4:get_ascii="k"; 5:get_ascii="a"; 6:get_ascii="d"; 7:get_ascii="y"; endcase
                default: get_ascii="?";
            endcase
        end
    endfunction

    reg [3:0] active_node;

    always @(posedge clk) begin
        if (rst) begin
            state <= 0; stack_ptr <= 0; tx_start <= 0; 
            char_idx <= 0; dist_print_step <= 0;
        end else begin
            tx_start <= 0; // Default off
            
            case(state)
                0: if (fsm_done) begin // Wait for solver to finish
                       curr_trace <= tgt_node;
                       prev_rd_addr <= tgt_node;
                       state <= 1;
                   end
                1: begin // Trace path backwards
                       stack[stack_ptr] <= curr_trace;
                       stack_ptr <= stack_ptr + 1;
                       if (curr_trace == src_node) state <= 2;
                       else begin
                           curr_trace <= prev_rd_data;
                           prev_rd_addr <= prev_rd_data;
                       end
                   end
                2: begin // Pop node from stack
                       if (stack_ptr > 0) begin
                           stack_ptr <= stack_ptr - 1;
                           active_node <= stack[stack_ptr - 1];
                           char_idx <= 0;
                           state <= 3; // Print town name
                       end else state <= 5; // Done popping, move to print distance
                   end
                3: begin // Print the 8 characters of the town name
                       if (!tx_busy && !tx_start) begin
                           tx_data <= get_ascii(active_node, char_idx[2:0]);
                           tx_start <= 1;
                           if (char_idx == 7) begin
                               if (stack_ptr > 0) state <= 4; // Print arrow
                               else state <= 2; // Loop to next node
                           end else char_idx <= char_idx + 1;
                       end
                   end
                4: begin // Print " -> " between nodes
                       if (!tx_busy && !tx_start) begin
                           if (char_idx == 8)      tx_data <= " ";
                           else if (char_idx == 9) tx_data <= "-";
                           else if (char_idx == 10) tx_data <= ">";
                           else if (char_idx == 11) tx_data <= " ";
                           
                           tx_start <= 1;
                           if (char_idx == 11) state <= 2; // Back to popping next node
                           else char_idx <= char_idx + 1;
                       end
                   end
                5: begin // Print the numeric integer distance
                       if (!tx_busy && !tx_start) begin
                           tx_start <= 1;
                           case (dist_print_step)
                               0: tx_data <= 8'h20; // Leading Space
                               // Print Hundreds (blank if zero)
                               1: tx_data <= (d_hund == 0) ? 8'h20 : (8'h30 + d_hund);
                               // Print Tens (blank if both hundreds and tens are zero)
                               2: tx_data <= (d_hund == 0 && d_tens == 0) ? 8'h20 : (8'h30 + d_tens);
                               // Print Ones
                               3: tx_data <= 8'h30 + d_ones; 
                               4: tx_data <= 8'h20; // Space
                               5: tx_data <= "k";
                               6: tx_data <= "m";
                               7: tx_data <= 8'h0D; // Carriage return
                               8: tx_data <= 8'h0A; // Line feed
                               9: begin
                                   tx_start <= 0;
                                   state <= 6; // Done printing
                               end
                               default: tx_data <= 8'h20;
                           endcase
                           
                           if (dist_print_step < 9) dist_print_step <= dist_print_step + 1;
                       end
                   end
                6: begin
                    // Halts here until reset. 
                end
            endcase
        end
    end
endmodule