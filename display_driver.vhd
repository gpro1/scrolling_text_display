library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_driver is
 port (
	i_clk				: in std_logic;
	o_i2c_en			: out std_logic; 
	o_i2c_addr_rw	: out unsigned(7 downto 0);
	o_i2c_data		: out unsigned(7 downto 0);
	);
	
architecture rtl of display_driver is


begin




end rtl;