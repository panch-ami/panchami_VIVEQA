module async_4bit_up_pos_tb();
reg clk,rst;
wire [3:0]count;

async_4bit_up_pos dut(clk,rst,count);

always #5 clk=~clk;

initial begin
clk=1'b0;
rst=1'b0;
#12 rst=1'b1;
#12 rst=1'b0;
#500 $finish;
end
endmodule
