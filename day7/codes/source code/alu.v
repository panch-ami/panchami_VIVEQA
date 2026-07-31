`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2026 10:41:35
// Design Name: 
// Module Name: alu
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

module alu (
    input  [3:0] A,        // 4-bit slide switch input A
    input  [3:0] B,        // 4-bit slide switch input B
    input  [15:0] button,  // 16-bit one-hot button inputs
    output reg [7:0] out   // 8-bit output (to accommodate A * B)
);

    always @(*) begin
        case(button)
            16'd1:     out = A + B;                      // 1:  ADD
            16'd2:     out = A - B;                      // 2:  SUB
            16'd4:     out = A & B;                      // 3:  AND
            16'd8:     out = A | B;                      // 4:  OR
            16'd16:    out = A << B;                     // 5:  A << B
            16'd32:    out = A >> B;                     // 6:  A >> B
            16'd64:    out = A ^ B;                      // 7:  A ^ B (XOR)
            16'd128:   out = ~A;                         // 8:  ~A (NOT A)
            16'd256:   out = A * B;                      // 9:  A x B (Multiply)
            16'd512:   out = (B != 0) ? (A / B) : 8'd0;  // 10: A / B (Div with 0-check)
            16'd1024:  out = ~(A & B);                   // 11: ~(A & B) (NAND)
            16'd2048:  out = A << 2;                     // 12: A << 2
            16'd4096:  out = A >> 2;                     // 13: A >> 2
            16'd8192:  out = ~(A | B);                   // 14: ~(A | B) (NOR)
            16'd16384: out = A + 1;                      // 15: A + 1
            16'd32768: out = B + 1;                      // 16: B + 1
            default:   out = 8'd0;                       // Default catch to prevent latches
        endcase
    end

endmodule