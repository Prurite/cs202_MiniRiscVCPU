# Board id: xc7a35tcsg324-1

set_property IOSTANDARD LVCMOS33 [get_ports *]

set_property PACKAGE_PIN P17 [get_ports clk_hw]
set_property PACKAGE_PIN P15 [get_ports rst]

# Button: R
set_property PACKAGE_PIN R11 [get_ports Button]

# 0-6 C D E F G A B
set_property PACKAGE_PIN P5 [get_ports {Switches[7]}]
set_property PACKAGE_PIN P4 [get_ports {Switches[6]}]
set_property PACKAGE_PIN P3 [get_ports {Switches[5]}]
set_property PACKAGE_PIN P2 [get_ports {Switches[4]}]
set_property PACKAGE_PIN R2 [get_ports {Switches[3]}]
set_property PACKAGE_PIN M4 [get_ports {Switches[2]}]
set_property PACKAGE_PIN N4 [get_ports {Switches[1]}]
set_property PACKAGE_PIN R1 [get_ports {Switches[0]}]

set_property PACKAGE_PIN G2 [get_ports {an[7]}]
set_property PACKAGE_PIN C2 [get_ports {an[6]}]
set_property PACKAGE_PIN C1 [get_ports {an[5]}]
set_property PACKAGE_PIN H1 [get_ports {an[4]}]
set_property PACKAGE_PIN G1 [get_ports {an[3]}]
set_property PACKAGE_PIN F1 [get_ports {an[2]}]
set_property PACKAGE_PIN E1 [get_ports {an[1]}]
set_property PACKAGE_PIN G6 [get_ports {an[0]}]

set_property PACKAGE_PIN B4 [get_ports {seg[7]}]
set_property PACKAGE_PIN A4 [get_ports {seg[6]}]
set_property PACKAGE_PIN A3 [get_ports {seg[5]}]
set_property PACKAGE_PIN B1 [get_ports {seg[4]}]
set_property PACKAGE_PIN A1 [get_ports {seg[3]}]
set_property PACKAGE_PIN B3 [get_ports {seg[2]}]
set_property PACKAGE_PIN B2 [get_ports {seg[1]}]
set_property PACKAGE_PIN D5 [get_ports {seg[0]}]

set_property PACKAGE_PIN D4 [get_ports {seg1[7]}]
set_property PACKAGE_PIN E3 [get_ports {seg1[6]}]
set_property PACKAGE_PIN D3 [get_ports {seg1[5]}]
set_property PACKAGE_PIN F4 [get_ports {seg1[4]}]
set_property PACKAGE_PIN F3 [get_ports {seg1[3]}]
set_property PACKAGE_PIN E2 [get_ports {seg1[2]}]
set_property PACKAGE_PIN D2 [get_ports {seg1[1]}]
set_property PACKAGE_PIN H2 [get_ports {seg1[0]}]

set_property PACKAGE_PIN J2 [get_ports EcallWait]
set_property PACKAGE_PIN K2 [get_ports InputWait]