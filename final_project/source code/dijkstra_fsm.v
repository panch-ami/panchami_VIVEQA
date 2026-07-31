`timescale 1ns / 1ps

module dijkstra_fsm (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire  [3:0] src_node,
    input  wire  [3:0] tgt_node,
    
    output reg         tree_start,
    input  wire        tree_done,
    input  wire        tree_found,
    input  wire [15:0] tree_min_dist,
    input  wire  [3:0] tree_min_idx,
    
    output reg   [3:0] adj_row,
    output reg   [3:0] adj_col,
    input  wire  [7:0] adj_weight,
    
    output reg         dist_wr_en,
    output reg   [3:0] dist_wr_addr,
    output reg  [15:0] dist_wr_data,
    output reg         visited_set_en,
    output reg   [3:0] visited_set_addr,
    output reg         prev_wr_en,
    output reg   [3:0] prev_wr_addr,
    output reg   [3:0] prev_wr_data,
    input  wire [15:0] dist_rd,
    
    output reg         fsm_done,
    output reg  [15:0] min_dist     // Added: Outputs final distance to top
);

    reg [2:0] state;
    reg [3:0] curr_node;
    reg [3:0] neighbor_idx;

    always @(posedge clk) begin
        if (rst) begin
            state <= 0; fsm_done <= 0; dist_wr_en <= 0;
            visited_set_en <= 0; prev_wr_en <= 0; tree_start <= 0;
            min_dist <= 0;
        end else begin
            dist_wr_en <= 0; visited_set_en <= 0; prev_wr_en <= 0; tree_start <= 0;
            
            case (state)
                0: begin // IDLE
                    if (start) begin
                        dist_wr_en <= 1;
                        dist_wr_addr <= src_node;
                        dist_wr_data <= 0;
                        state <= 1; // Go to FIND_MIN
                    end
                end
                1: begin // FIND_MIN
                    tree_start <= 1;
                    state <= 2;
                end
                2: begin // WAIT_MIN
                    if (tree_done) begin
                        if (!tree_found || tree_min_idx == tgt_node) begin
                            min_dist <= tree_min_dist; // Capture final distance
                            state <= 6; // DONE
                        end else begin
                            curr_node <= tree_min_idx;
                            visited_set_en <= 1;
                            visited_set_addr <= tree_min_idx;
                            neighbor_idx <= 0;
                            state <= 3; // FETCH_ADJ
                        end
                    end
                end
                3: begin // FETCH_ADJ
                    adj_row <= curr_node;
                    adj_col <= neighbor_idx;
                    state <= 4; // BRAM latency wait
                end
                4: begin // WAIT_ADJ
                    state <= 5; // dist_rd is combinational based on adj_col, wait 1 tick
                end
                5: begin // RELAX
                    if (adj_weight != 8'hFF && (tree_min_dist + adj_weight < dist_rd)) begin
                        dist_wr_en <= 1; dist_wr_addr <= neighbor_idx;
                        dist_wr_data <= tree_min_dist + adj_weight;
                        prev_wr_en <= 1; prev_wr_addr <= neighbor_idx;
                        prev_wr_data <= curr_node;
                    end
                    if (neighbor_idx == 15) state <= 1; // Checked all, find next min
                    else begin
                        neighbor_idx <= neighbor_idx + 1;
                        state <= 3;
                    end
                end
                6: begin // DONE
                    fsm_done <= 1;
                end
            endcase
        end
    end
endmodule