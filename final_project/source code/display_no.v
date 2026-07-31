`timescale 1ns / 1ps

module display_no(
    input  wire [15:0] button, // 16-bit one-hot input from matrix
    output reg  [3:0]  led     // 4-bit binary output (Node ID)
);

    always @(*) begin
        case(button)
            16'd1:     led = 4'd0;  // Node 0: Udupi
            16'd2:     led = 4'd1;  // Node 1: Brahmavar
            16'd4:     led = 4'd2;  // Node 2: Manipal
            16'd8:     led = 4'd3;  // Node 3: Hiriyadka
            16'd16:    led = 4'd4;  // Node 4: Seethanadi
            16'd32:    led = 4'd5;  // Node 5: Agumbe
            16'd64:    led = 4'd6;  // Node 6: Karkala
            16'd128:   led = 4'd7;  // Node 7: Shirva
            16'd256:   led = 4'd8;  // Node 8: Belman
            16'd512:   led = 4'd9;  // Node 9: Padubidri
            16'd1024:  led = 4'd10; // Node A: Manglore     
            16'd2048:  led = 4'd11; // Node B: Moodbidre  
            16'd4096:  led = 4'd12; // Node C: Ujire
            16'd8192:  led = 4'd13; // Node D: Dharmasthala
            16'd16384: led = 4'd14; // Node E: Kinnigoli
            16'd32768: led = 4'd15; // Node F: Cherkady
            default:   led = 4'd0;
        endcase
    end
endmodule