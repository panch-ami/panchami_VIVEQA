
// =============================================================
// bram_adj_matrix.v  (refactored)
//
// Same interface, same synthesized result (a real block ROM via
// rom_style="block"), but the data is described as a list of
// EDGES instead of 256 individually typed addresses. A loop
// writes both directions of each edge automatically, so there's
// only one place to edit per road and no way for the two
// directions to drift out of sync.
//
// addr = row*16 + col. 8'hFF = no direct connection.
// =============================================================
`timescale 1ns / 1ps
module bram_adj_matrix #(
    parameter NODES  = 16,
    parameter DEPTH  = 256,
    parameter DATA_W = 8
)(
    input  wire              clk,
    input  wire              en,
    input  wire [3:0]        row_addr,
    input  wire [3:0]        col_addr,
    output reg  [DATA_W-1:0] weight_out
);

    localparam [DATA_W-1:0] NO_EDGE = 8'hFF;
    localparam NUM_EDGES = 32;

    (* rom_style = "block" *)
    reg [DATA_W-1:0] mem [0:DEPTH-1];

    // one row per road: {node_a, node_b, weight}
    // node names left as comments so this stays self-documenting
    reg [11:0] edge_table [0:NUM_EDGES-1]; // {a[3:0], b[3:0], weight[7:0]} packed as needed below
    reg [3:0]  edge_a [0:NUM_EDGES-1];
    reg [3:0]  edge_b [0:NUM_EDGES-1];
    reg [7:0]  edge_w [0:NUM_EDGES-1];

    integer i, j;

    initial begin
        // node    a    b    weight(km)
        edge_a[ 0]=4'h0; edge_b[ 0]=4'h1; edge_w[ 0]=8'd13; // Udupi - Brahmavar 
        edge_a[ 1]=4'h0; edge_b[ 1]=4'h2; edge_w[ 1]=8'd5;  // Udupi - Manipal 
        edge_a[ 2]=4'h0; edge_b[ 2]=4'h7; edge_w[ 2]=8'd21; // Udupi - Shirva  
        edge_a[ 3]=4'h0; edge_b[ 3]=4'h9; edge_w[ 3]=8'd25; // Udupi - Padubidri  
        edge_a[ 4]=4'h0; edge_b[ 4]=4'hF; edge_w[ 4]=8'd21; // Udupi - Cherkady 
        edge_a[ 5]=4'h1; edge_b[ 5]=4'hF; edge_w[ 5]=8'd11; // Brahmavar - Cherkady 
        edge_a[ 6]=4'h2; edge_b[ 6]=4'h3; edge_w[ 6]=8'd10; // Manipal - Hiriyadka
        edge_a[ 7]=4'h3; edge_b[ 7]=4'h4; edge_w[ 7]=8'd24; // Hiriyadka - Seethanadi 
        edge_a[ 8]=4'h3; edge_b[ 8]=4'h6; edge_w[ 8]=8'd24; // Hiriyadka - Karkala 
        edge_a[ 9]=4'h3; edge_b[ 9]=4'h7; edge_w[ 9]=8'd25; // Hiriyadka - Shirva
        edge_a[10]=4'h4; edge_b[10]=4'h5; edge_w[10]=8'd14; // Seethanadi - Agumbe 
        edge_a[11]=4'h4; edge_b[11]=4'h6; edge_w[11]=8'd35; // Seethanadi - Karkala 
        edge_a[12]=4'h6; edge_b[12]=4'h8; edge_w[12]=8'd17; // Karkala - Belman 
        edge_a[13]=4'h6; edge_b[13]=4'hB; edge_w[13]=8'd18; // Karkala - Moodbidre 
        edge_a[14]=4'h6; edge_b[14]=4'hC; edge_w[14]=8'd55; // Karkala - Ujire 
        edge_a[15]=4'h6; edge_b[15]=4'hF; edge_w[15]=8'd35; // Karkala - Cherkady 
        edge_a[16]=4'h7; edge_b[16]=4'h8; edge_w[16]=8'd9;  // Shirva - Belman 
        edge_a[17]=4'h8; edge_b[17]=4'hB; edge_w[17]=8'd24; // Belman - Moodbidre 
        edge_a[18]=4'h8; edge_b[18]=4'hE; edge_w[18]=8'd15; // Belman - Kinnigoli 
        edge_a[19]=4'h8; edge_b[19]=4'h3; edge_w[19]=8'd28; // Belman - Hiriyadka
        edge_a[20]=4'h9; edge_b[20]=4'hA; edge_w[20]=8'd32; // Padubidri - Manglore 
        edge_a[21]=4'h9; edge_b[21]=4'h7; edge_w[21]=8'd18; // Padubidri - Shirva 
        edge_a[22]=4'h9; edge_b[22]=4'h8; edge_w[22]=8'd12; // Padubidri - Belman 
        edge_a[23]=4'h9; edge_b[23]=4'hE; edge_w[23]=8'd15; // Padubidri - Kinnigoli
        edge_a[24]=4'hA; edge_b[24]=4'hB; edge_w[24]=8'd34; // Manglore - Moodbidre  
        edge_a[25]=4'hA; edge_b[25]=4'hC; edge_w[25]=8'd64; // Manglore - Ujire 
        edge_a[26]=4'hA; edge_b[26]=4'hE; edge_w[26]=8'd28; // Manglore - Kinnigoli 
        edge_a[27]=4'hB; edge_b[27]=4'hC; edge_w[27]=8'd43; // Moodbidre - Ujire 
        edge_a[28]=4'hB; edge_b[28]=4'hE; edge_w[28]=8'd19; // Moodbidre - Kinnigoli
        edge_a[29]=4'hC; edge_b[29]=4'hD; edge_w[29]=8'd8;  // Ujire - Dharmasthala 
        edge_a[30]=4'hF; edge_b[30]=4'h4; edge_w[30]=8'd25; // Cherkady to Seethanadi 
        edge_a[31]=4'hF; edge_b[31]=4'h3; edge_w[31]=8'd11; // Cherkady to Hiriyadka

        // fill everything with "no edge" first
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = NO_EDGE;

        // self-distance = 0
        for (i = 0; i < NODES; i = i + 1)
            mem[i*16 + i] = 8'h00;

        // write both directions of every real road, once each
        for (j = 0; j < NUM_EDGES; j = j + 1) begin
            mem[edge_a[j]*16 + edge_b[j]] = edge_w[j];
            mem[edge_b[j]*16 + edge_a[j]] = edge_w[j];
        end
    end

    wire [7:0] addr = {row_addr, col_addr};

    always @(posedge clk) begin
        if (en)
            weight_out <= mem[addr];
    end

endmodule