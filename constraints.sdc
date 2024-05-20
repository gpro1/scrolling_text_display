

#*********************************************
# Clock Constraints 
#*********************************************

create_clock -period 20 [get_ports {i_clk_50}]
derive_clock_uncertainty