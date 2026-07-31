`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2026 11:04:49
// Design Name: 
// Module Name: bram_dist_visited
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// =============================================================
// bram_dist_visited.v
// Per-node Dijkstra state: distance[], visited[], prev[].
// =============================================================

`timescale 1ns / 1ps

module bram_dist_visited #(
    parameter NODES      = 16,
    parameter DIST_W     = 16,     
    parameter NODE_IDX_W = 4       
)(
    input  wire                      clk,
    input  wire                      rst,              

    input  wire                      dist_wr_en,
    input  wire [NODE_IDX_W-1:0]     dist_wr_addr,
    input  wire [DIST_W-1:0]         dist_wr_data,

    input  wire                      prev_wr_en,
    input  wire [NODE_IDX_W-1:0]     prev_wr_addr,
    input  wire [NODE_IDX_W-1:0]     prev_wr_data,

    input  wire                      visited_set_en,
    input  wire [NODE_IDX_W-1:0]     visited_set_addr,

    input  wire [NODE_IDX_W-1:0]     rd_addr,
    output wire [DIST_W-1:0]         dist_rd,
    output wire                      visited_rd,
    output wire [NODE_IDX_W-1:0]     prev_rd,

    output wire [NODES*DIST_W-1:0]   dist_flat,
    output wire [NODES-1:0]          visited_flat
);

    localparam [DIST_W-1:0]     DIST_INF  = {DIST_W{1'b1}};      // 16'hFFFF
    localparam [NODE_IDX_W-1:0] PREV_NONE = {NODE_IDX_W{1'b1}};  // 4'hF

    reg [DIST_W-1:0]     dist_mem    [0:NODES-1];
    reg                  visited_mem [0:NODES-1];
    reg [NODE_IDX_W-1:0] prev_mem    [0:NODES-1];

    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < NODES; i = i + 1) begin
                dist_mem[i]    <= DIST_INF;
                visited_mem[i] <= 1'b0;
                prev_mem[i]    <= PREV_NONE;
            end
        end else begin
            if (dist_wr_en)
                dist_mem[dist_wr_addr] <= dist_wr_data;
            if (visited_set_en)
                visited_mem[visited_set_addr] <= 1'b1;
            if (prev_wr_en)
                prev_mem[prev_wr_addr] <= prev_wr_data;
        end
    end

    assign dist_rd    = dist_mem[rd_addr];
    assign visited_rd = visited_mem[rd_addr];
    assign prev_rd    = prev_mem[rd_addr];

    genvar g;
    generate
        for (g = 0; g < NODES; g = g + 1) begin : FLATTEN
            assign dist_flat[(g+1)*DIST_W-1 -: DIST_W] = dist_mem[g];
            assign visited_flat[g] = visited_mem[g];
        end
    endgenerate

endmodule