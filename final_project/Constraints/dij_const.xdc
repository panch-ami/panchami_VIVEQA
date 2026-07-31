set_property PACKAGE_PIN D13 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 41.667 [get_ports clk]

set_property PACKAGE_PIN B9 [get_ports rst_btn]
set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]

set_property PACKAGE_PIN A13 [get_ports {buttons[0]}]   ; # key 0
set_property PACKAGE_PIN F5  [get_ports {buttons[1]}]   ; # key 1
set_property PACKAGE_PIN E3  [get_ports {buttons[2]}]   ; # key 2
set_property PACKAGE_PIN F2  [get_ports {buttons[3]}]   ; # key 3
set_property PACKAGE_PIN A12 [get_ports {buttons[4]}]   ; # key 4
set_property PACKAGE_PIN D6  [get_ports {buttons[5]}]   ; # key 5
set_property PACKAGE_PIN D3  [get_ports {buttons[6]}]   ; # key 6
set_property PACKAGE_PIN F3  [get_ports {buttons[7]}]   ; # key 7
set_property PACKAGE_PIN A5  [get_ports {buttons[8]}]   ; # key 8
set_property PACKAGE_PIN C6  [get_ports {buttons[9]}]   ; # key 9
set_property PACKAGE_PIN D4  [get_ports {buttons[10]}]  ; # key A
set_property PACKAGE_PIN F4  [get_ports {buttons[11]}]  ; # key B
set_property PACKAGE_PIN B6  [get_ports {buttons[12]}]  ; # key C
set_property PACKAGE_PIN B5  [get_ports {buttons[13]}]  ; # key D
set_property PACKAGE_PIN C4  [get_ports {buttons[14]}]  ; # key E
set_property PACKAGE_PIN E5  [get_ports {buttons[15]}]  ; # key F
set_property IOSTANDARD LVCMOS33 [get_ports {buttons[*]}]

set_property PACKAGE_PIN G4 [get_ports lcd_rs]
set_property PACKAGE_PIN H3 [get_ports lcd_rw]
set_property PACKAGE_PIN E1 [get_ports lcd_e]
set_property PACKAGE_PIN G2 [get_ports {lcd_data[0]}]
set_property PACKAGE_PIN G1 [get_ports {lcd_data[1]}]
set_property PACKAGE_PIN H5 [get_ports {lcd_data[2]}]
set_property PACKAGE_PIN H4 [get_ports {lcd_data[3]}]
set_property PACKAGE_PIN J5 [get_ports {lcd_data[4]}]
set_property PACKAGE_PIN J4 [get_ports {lcd_data[5]}]
set_property PACKAGE_PIN H2 [get_ports {lcd_data[6]}]
set_property PACKAGE_PIN H1 [get_ports {lcd_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_rs lcd_rw lcd_e lcd_data[*]}]

set_property PACKAGE_PIN T3 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]
