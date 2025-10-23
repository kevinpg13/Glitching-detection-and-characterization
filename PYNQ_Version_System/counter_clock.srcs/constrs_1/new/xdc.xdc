## This file is a general .xdc for the PYNQ-Z1 board Rev. C
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal 125 MHz

set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_in]


## LEDs
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports { ref_locked_led }];
set_property -dict { PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports { clean_locked_led }];

## Pmod JA (clock outputs + glitch signal)
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { reference_clk_out }];
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { corrupted_clk_out }];

## Pmod JB (glitch detect)
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { glitch_detect_out }];

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
