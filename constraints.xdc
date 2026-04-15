## System Clock
#   goes into the clock divider
set_property PACKAGE_PIN L18 [get_ports sysclk_125mhz]
set_property IOSTANDARD LVCMOS33 [get_ports sysclk_125mhz]

## LEDs [LED7 : LED0]
#   L3  L2  L1  R1  R2  R3
#
set_property PACKAGE_PIN Y9  [get_ports {led[0]}]; # R3
set_property PACKAGE_PIN Y8  [get_ports {led[1]}]; # R2
set_property PACKAGE_PIN V7  [get_ports {led[2]}]; # R1
set_property PACKAGE_PIN W7  [get_ports {led[3]}]; # L1
set_property PACKAGE_PIN V10 [get_ports {led[4]}]; # L2
set_property PACKAGE_PIN W12 [get_ports {led[5]}]; # L3
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

## Push Buttons [B3 : B0]
#   B3  B2  B1  B0
#
set_property PACKAGE_PIN U12 [get_ports {btn[0]}]; # Left Turn Signal
set_property PACKAGE_PIN V12 [get_ports {btn[1]}]; # Right Turn Signal
set_property PACKAGE_PIN U7 [get_ports {btn[2]}]; # Brake
set_property PACKAGE_PIN Y6 [get_ports {btn[3]}]; # Hazard
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]

## Seven Segment Display
#   Bus order: ssegout[7:0] = [a b c d e f g dp]
#
set_property PACKAGE_PIN J20 [get_ports {sseg_an[3]}];     
set_property PACKAGE_PIN J18 [get_ports {sseg_an[2]}];
set_property PACKAGE_PIN H20 [get_ports {sseg_an[1]}];
set_property PACKAGE_PIN K19 [get_ports {sseg_an[0]}];
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[*]}]

set_property PACKAGE_PIN K20 [get_ports {ssegout[0]}]; # dp
set_property PACKAGE_PIN L19 [get_ports {ssegout[1]}]; # g
set_property PACKAGE_PIN H18 [get_ports {ssegout[2]}]; # f
set_property PACKAGE_PIN M20 [get_ports {ssegout[3]}]; # e
set_property PACKAGE_PIN K21 [get_ports {ssegout[4]}]; # d
set_property PACKAGE_PIN K18 [get_ports {ssegout[5]}]; # c
set_property PACKAGE_PIN H17 [get_ports {ssegout[6]}]; # b
set_property PACKAGE_PIN H19 [get_ports {ssegout[7]}]; # a
set_property IOSTANDARD LVCMOS33 [get_ports {ssegout[*]}]

## Hazard Switch
set_property PACKAGE_PIN SD [get_ports hazard_switch]
set_property IOSTANDARD LVCMOS33 [get_ports hazard_switch]




