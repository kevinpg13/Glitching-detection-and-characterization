set_property SRC_FILE_INFO {cfile:c:/Users/andre/OneDrive/Desktop/Sistema/counter_clock.gen/sources_1/ip/ila_0/ila_v6_2/constraints/ila.xdc rfile:../counter_clock.gen/sources_1/ip/ila_0/ila_v6_2/constraints/ila.xdc id:1 order:EARLY scoped_inst:UART_Transfer_i/clock_out_top_0/U0/ila_inst/U0} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/andre/OneDrive/Desktop/Sistema/counter_clock.gen/sources_1/bd/UART_Transfer/ip/UART_Transfer_processing_system7_0_0/UART_Transfer_processing_system7_0_0.xdc rfile:../counter_clock.gen/sources_1/bd/UART_Transfer/ip/UART_Transfer_processing_system7_0_0/UART_Transfer_processing_system7_0_0.xdc id:2 order:EARLY scoped_inst:UART_Transfer_i/processing_system7_0/inst} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/andre/OneDrive/Desktop/Sistema/counter_clock.gen/sources_1/bd/UART_Transfer/ip/UART_Transfer_rst_ps7_0_100M_0/UART_Transfer_rst_ps7_0_100M_0.xdc rfile:../counter_clock.gen/sources_1/bd/UART_Transfer/ip/UART_Transfer_rst_ps7_0_100M_0/UART_Transfer_rst_ps7_0_100M_0.xdc id:3 order:EARLY scoped_inst:UART_Transfer_i/rst_ps7_0_100M/U0} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/andre/OneDrive/Desktop/Sistema/counter_clock.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../counter_clock.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:4 order:EARLY scoped_inst:UART_Transfer_i/clock_out_top_0/U0/u_pll_slow/inst} [current_design]
set_property SRC_FILE_INFO {cfile:c:/Users/andre/OneDrive/Desktop/Sistema/counter_clock.gen/sources_1/ip/clk_wiz_1_1/clk_wiz_1.xdc rfile:../counter_clock.gen/sources_1/ip/clk_wiz_1_1/clk_wiz_1.xdc id:5 order:EARLY scoped_inst:UART_Transfer_i/clock_out_top_0/U0/u_pll_fast/inst} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/andre/OneDrive/Desktop/Sistema/counter_clock.srcs/constrs_1/new/xdc.xdc rfile:../counter_clock.srcs/constrs_1/new/xdc.xdc id:6} [current_design]
current_instance UART_Transfer_i/clock_out_top_0/U0/ila_inst/U0
set_property src_info {type:SCOPED_XDC file:1 line:108 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -quiet -type CDC -id {CDC-10} -user ila -tags "1191969" -description "CDC-10 waiver for DDR Calibration logic" -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*CLK} -of_objects [get_cells -hierarchical -filter {NAME =~*u_trig/N_DDR_TC.N_DDR_TC_INST[*].U_TC/allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/u_srl_drive}]] -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*u_trig/N_DDR_TC.N_DDR_TC_INST[*].U_TC/allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/I_IS_TERMINATION_SLICE_W_OUTPUT_REG.DOUT_O_reg}]]
set_property src_info {type:SCOPED_XDC file:1 line:112 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -internal -quiet -type CDC -id {CDC-10} -user system_ila -tags "1196835" -description "CDC-10 waiver for DDR Calibration logic" -scope -from [get_pins -quiet -filter {REF_PIN_NAME=~*CLK} -of_objects [get_cells -hierarchical -filter {NAME =~*u_trig/N_DDR_TC.N_DDR_TC_INST[*].U_TC/allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/u_srl_drive}]] -to [get_pins -quiet -filter {REF_PIN_NAME=~*D} -of_objects [get_cells -hierarchical -filter {NAME =~*u_trig/N_DDR_TC.N_DDR_TC_INST[*].U_TC/allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/I_WHOLE_SLICE.G_SLICE_IDX[*].U_ALL_SRL_SLICE/I_IS_TERMINATION_SLICE_W_OUTPUT_REG.DOUT_O_reg}]]
current_instance
current_instance UART_Transfer_i/processing_system7_0/inst
set_property src_info {type:SCOPED_XDC file:2 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_fpga_0 0.3
current_instance
current_instance UART_Transfer_i/rst_ps7_0_100M/U0
set_property src_info {type:SCOPED_XDC file:3 line:50 export:INPUT save:INPUT read:READ} [current_design]
create_waiver -type CDC -id {CDC-11} -user "proc_sys_reset" -desc "Timing uncritical paths" -tags "1171415" -scope -internal -to [get_pins -quiet -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~ */ACTIVE_LOW_AUX.ACT_LO_AUX/GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to}]]
current_instance
current_instance UART_Transfer_i/clock_out_top_0/U0/u_pll_slow/inst
set_property src_info {type:SCOPED_XDC file:4 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.080
current_instance
current_instance UART_Transfer_i/clock_out_top_0/U0/u_pll_fast/inst
set_property src_info {type:SCOPED_XDC file:5 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
current_instance
set_property src_info {type:XDC file:6 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports { ref_locked_led }];
set_property src_info {type:XDC file:6 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports { clean_locked_led }];
set_property src_info {type:XDC file:6 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { reference_clk_out }];
set_property src_info {type:XDC file:6 line:17 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { corrupted_clk_out }];
set_property src_info {type:XDC file:6 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { glitch_signal_out }];
set_property src_info {type:XDC file:6 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST } [get_ports { glitch_detect_out }];
set_property src_info {type:XDC file:6 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property src_info {type:XDC file:6 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property src_info {type:XDC file:6 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
set_property src_info {type:XDC file:6 line:26 export:INPUT save:INPUT read:READ} [current_design]
connect_debug_port dbg_hub/clk [get_nets clk]
