create_clock -period 41.667 -name sys_clk [get_ports clk]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports clk]

set_property -dict {PACKAGE_PIN A13  IOSTANDARD LVCMOS33} [rst]

set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports led[0]] 
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports led[1]]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports led[2]] 
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports led[3]]
