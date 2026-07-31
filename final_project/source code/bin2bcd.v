`timescale 1ns / 1ps

module bin2bcd (
    input  wire [15:0] bin,
    output reg  [3:0]  thou,
    output reg  [3:0]  hund,
    output reg  [3:0]  tens,
    output reg  [3:0]  ones
);
    integer i;
    always @(bin) begin
        thou = 4'd0; hund = 4'd0; tens = 4'd0; ones = 4'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            if (thou >= 5) thou = thou + 3;
            if (hund >= 5) hund = hund + 3;
            if (tens >= 5) tens = tens + 3;
            if (ones >= 5) ones = ones + 3;
            
            thou = {thou[2:0], hund[3]};
            hund = {hund[2:0], tens[3]};
            tens = {tens[2:0], ones[3]};
            ones = {ones[2:0], bin[i]};
        end
    end
endmodule
