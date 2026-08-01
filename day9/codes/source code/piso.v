module PISO (
    input        clk,
    input        rst,
    input  [3:0] data_in,
    input        load,
    input        shift,
    output reg   data_out
);

    reg [3:0] data_reg;
    reg [1:0] cnt;
    reg       shift_d;
    wire      pos_shift;

    always @(posedge clk) begin
        if (rst) begin
            data_out <= 1'b0;
            cnt      <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            if (load) begin
                data_reg <= data_in;
                cnt      <= 2'b0; // FIX: Reset counter when loading new data
            end else if (pos_shift) begin
                data_out <= data_reg[cnt];
                cnt      <= cnt + 1'b1;
            end
        end
    end

    // Edge detector for single-pulse shift triggering
    always @(posedge clk) begin
        if (rst) begin
            shift_d <= 1'b0;
        end else begin
            shift_d <= shift;
        end
    end

    assign pos_shift = ~shift_d & shift;

endmodule
