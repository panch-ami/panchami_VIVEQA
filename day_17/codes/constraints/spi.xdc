set_property PACKAGE_PIN D13 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 41.667 [get_ports clk]

set_property PACKAGE_PIN J16 [get_ports seg_cs]
set_property IOSTANDARD LVCMOS33 [get_ports seg_cs]

# Segment Clock
set_property PACKAGE_PIN H12 [get_ports seg_clk]
set_property IOSTANDARD LVCMOS33 [get_ports seg_clk]

# Segment Data In
set_property PACKAGE_PIN J15 [get_ports seg_din]
set_property IOSTANDARD LVCMOS33 [get_ports seg_din]
