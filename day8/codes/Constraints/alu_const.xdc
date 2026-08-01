## ====================================================================
## Slide Switches: Input A [3:0] (SS0 to SS3)
## ====================================================================
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports { A[0] }][cite: 1]
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports { A[1] }][cite: 1]
set_property -dict { PACKAGE_PIN G5  IOSTANDARD LVCMOS33 } [get_ports { A[2] }][cite: 1]
set_property -dict { PACKAGE_PIN A7  IOSTANDARD LVCMOS33 } [get_ports { A[3] }][cite: 1]

## ====================================================================
## Slide Switches: Input B [3:0] (SS4 to SS7)
## ====================================================================
set_property -dict { PACKAGE_PIN C7  IOSTANDARD LVCMOS33 } [get_ports { B[0] }][cite: 1]
set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports { B[1] }][cite: 1]
set_property -dict { PACKAGE_PIN B7  IOSTANDARD LVCMOS33 } [get_ports { B[2] }][cite: 1]
set_property -dict { PACKAGE_PIN A8  IOSTANDARD LVCMOS33 } [get_ports { B[3] }][cite: 1]

## ====================================================================
## 4x4 Matrix Keypad: button [15:0] (Keys 0-9, A-F)
## ====================================================================
set_property -dict { PACKAGE_PIN A13 IOSTANDARD LVCMOS33 } [get_ports { button[0] }]  ; # Key 0 -> ADD[cite: 1]
set_property -dict { PACKAGE_PIN F5  IOSTANDARD LVCMOS33 } [get_ports { button[1] }]  ; # Key 1 -> SUB[cite: 1]
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports { button[2] }]  ; # Key 2 -> AND[cite: 1]
set_property -dict { PACKAGE_PIN F2  IOSTANDARD LVCMOS33 } [get_ports { button[3] }]  ; # Key 3 -> OR[cite: 1]
set_property -dict { PACKAGE_PIN A12 IOSTANDARD LVCMOS33 } [get_ports { button[4] }]  ; # Key 4 -> A << B[cite: 1]
set_property -dict { PACKAGE_PIN D6  IOSTANDARD LVCMOS33 } [get_ports { button[5] }]  ; # Key 5 -> A >> B[cite: 1]
set_property -dict { PACKAGE_PIN D3  IOSTANDARD LVCMOS33 } [get_ports { button[6] }]  ; # Key 6 -> XOR[cite: 1]
set_property -dict { PACKAGE_PIN F3  IOSTANDARD LVCMOS33 } [get_ports { button[7] }]  ; # Key 7 -> NOT A[cite: 1]
set_property -dict { PACKAGE_PIN A5  IOSTANDARD LVCMOS33 } [get_ports { button[8] }]  ; # Key 8 -> Multiply[cite: 1]
set_property -dict { PACKAGE_PIN C6  IOSTANDARD LVCMOS33 } [get_ports { button[9] }]  ; # Key 9 -> Divide[cite: 1]
set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports { button[10] }] ; # Key A -> NAND[cite: 1]
set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports { button[11] }] ; # Key B -> A << 2[cite: 1]
set_property -dict { PACKAGE_PIN C5  IOSTANDARD LVCMOS33 } [get_ports { button[12] }] ; # Key C -> A >> 2[cite: 1]
set_property -dict { PACKAGE_PIN B5  IOSTANDARD LVCMOS33 } [get_ports { button[13] }] ; # Key D -> NOR[cite: 1]
set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVCMOS33 } [get_ports { button[14] }] ; # Key E -> A + 1[cite: 1]
set_property -dict { PACKAGE_PIN E5  IOSTANDARD LVCMOS33 } [get_ports { button[15] }] ; # Key F -> B + 1[cite: 1]

## ====================================================================
## User LEDs: out [7:0] (LED1 to LED8)
## ====================================================================
set_property -dict { PACKAGE_PIN D5  IOSTANDARD LVCMOS33 } [get_ports { out[0] }][cite: 1]
set_property -dict { PACKAGE_PIN A3  IOSTANDARD LVCMOS33 } [get_ports { out[1] }][cite: 1]
set_property -dict { PACKAGE_PIN B4  IOSTANDARD LVCMOS33 } [get_ports { out[2] }][cite: 1]
set_property -dict { PACKAGE_PIN A4  IOSTANDARD LVCMOS33 } [get_ports { out[3] }][cite: 1]
set_property -dict { PACKAGE_PIN E6  IOSTANDARD LVCMOS33 } [get_ports { out[4] }][cite: 1]
set_property -dict { PACKAGE_PIN C13 IOSTANDARD LVCMOS33 } [get_ports { out[5] }][cite: 1]
set_property -dict { PACKAGE_PIN C14 IOSTANDARD LVCMOS33 } [get_ports { out[6] }][cite: 1]
set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports { out[7] }][cite: 1]
