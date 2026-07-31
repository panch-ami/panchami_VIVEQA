module neg_edge_id (clk, in, in_delay, out);
input clk, in;
output reg in_delay;
output out;

always @(posedge clk) begin
    in_delay <= in;
end

assign out = ~in & in_delay;   // in is now 0, but was 1 last cycle → falling edge
endmodule