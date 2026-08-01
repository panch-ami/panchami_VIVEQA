module T_FF(clk,rst,T,Q,Qb);
input clk,rst;
input T;
output reg Q;
output Qb;

always @(posedge clk)begin
	if(rst) Q<=1'b0;
        else if(T) Q <=~Q;
        else Q <=Q;
end

assign Qb =~Q;
endmodule
