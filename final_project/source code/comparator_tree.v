// =============================================================
// comparator_tree.v
// Parallel minimum-finder using a binary reduction tree.
// =============================================================

`timescale 1ns / 1ps

module comparator_tree #(
    parameter NODES      = 16,
    parameter DIST_W     = 16,
    parameter NODE_IDX_W = 4               
)(
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    start,
    input  wire [NODES*DIST_W-1:0] dist_flat,
    input  wire [NODES-1:0]        visited_flat,

    output reg                     done,
    output reg                     found,
    output reg  [DIST_W-1:0]       min_dist,
    output reg  [NODE_IDX_W-1:0]   min_idx
);

    localparam CAND_W = 1 + DIST_W + NODE_IDX_W;   // {valid, dist, idx}
    localparam [DIST_W-1:0] DIST_INF = {DIST_W{1'b1}};

    localparam S_IDLE   = 2'd0,
               S_LOAD   = 2'd1,
               S_REDUCE = 2'd2,
               S_LATCH  = 2'd3;

    reg [1:0] state;
    reg [CAND_W-1:0] cand [0:NODES-1];
    reg [$clog2(NODES)+1:0] active_cnt;

    integer k;

    function [CAND_W-1:0] pick_min;
        input [CAND_W-1:0] a, b;
        reg a_valid, b_valid;
        reg [DIST_W-1:0] a_dist, b_dist;
        begin
            a_valid = a[CAND_W-1];
            b_valid = b[CAND_W-1];
            a_dist  = a[CAND_W-2 -: DIST_W];
            b_dist  = b[CAND_W-2 -: DIST_W];

            if (!a_valid && !b_valid)
                pick_min = {1'b0, DIST_INF, {NODE_IDX_W{1'b0}}};
            else if (a_valid && !b_valid)
                pick_min = a;
            else if (!a_valid && b_valid)
                pick_min = b;
            else
                pick_min = (a_dist <= b_dist) ? a : b;
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            state      <= S_IDLE;
            done       <= 1'b0;
            found      <= 1'b0;
            min_dist   <= DIST_INF;
            min_idx    <= {NODE_IDX_W{1'b0}};
            active_cnt <= 0;
        end else begin
            done <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (start)
                        state <= S_LOAD;
                end

                S_LOAD: begin
                    for (k = 0; k < NODES; k = k + 1)
                        cand[k] <= { ~visited_flat[k],
                                     dist_flat[(k+1)*DIST_W-1 -: DIST_W],
                                     k[NODE_IDX_W-1:0] };
                    active_cnt <= NODES;
                    state <= S_REDUCE;
                end

                S_REDUCE: begin
                    if (active_cnt > 1) begin
                        for (k = 0; k < NODES/2; k = k + 1) begin
                            if (k < active_cnt >> 1)
                                cand[k] <= pick_min(cand[2*k], cand[2*k+1]);
                        end
                        active_cnt <= active_cnt >> 1;
                        if ((active_cnt >> 1) <= 1)
                            state <= S_LATCH;
                    end
                end

                S_LATCH: begin
                    found    <= cand[0][CAND_W-1];
                    min_dist <= cand[0][CAND_W-2 -: DIST_W];
                    min_idx  <= cand[0][NODE_IDX_W-1:0];
                    done     <= 1'b1;
                    state    <= S_IDLE;
                end
            endcase
        end
    end

endmodule