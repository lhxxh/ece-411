## Generated SDC file "mp3.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"

## DATE    "Fri May  1 14:41:37 2020"

##
## DEVICE  "EP2AGX45DF25I3"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 10.000 -waveform { 0.000 5.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {clk}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[32]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[33]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[34]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[35]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[36]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[37]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[38]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[39]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[40]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[41]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[42]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[43]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[44]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[45]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[46]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[47]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[48]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[49]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[50]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[51]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[52]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[53]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[54]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[55]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[56]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[57]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[58]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[59]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[60]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[61]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[62]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rdata_from_physical_memory[63]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {resp_from_physical_memory}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {rst}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {addr_to_physical_memory[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {read_to_physical_memory}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[32]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[33]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[34]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[35]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[36]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[37]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[38]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[39]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[40]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[41]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[42]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[43]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[44]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[45]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[46]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[47]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[48]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[49]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[50]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[51]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[52]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[53]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[54]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[55]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[56]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[57]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[58]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[59]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[60]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[61]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[62]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {wdata_to_physical_memory[63]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.000 [get_ports {write_to_physical_memory}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

