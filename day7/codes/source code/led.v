`timescale 1ns / 1ps
// code to switch on led using slide switches
// Create Date: 06/30/2026 03:05:56 PM

module led(switch,leds);
input [7:0]switch;
output [7:0]leds;
assign leds=switch;
endmodule
