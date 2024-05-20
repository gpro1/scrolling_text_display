-------------------------------------------------------------------------------------
-- meta_ff.vhd
--
-- Date: 05/20/2024
--
-- Engineer: Gregory Evans
--
-- Desc: 
--
--	Double register to prevent metastability issues.
--
-- i_clk 			- The fast clock of the destination clock domain
-- i_data			- The slow data (clocked in a different domain than i_clk)
-- o_data			- Output data for the new clock domain

--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity meta_ff is
 port (
	i_clk		: in std_logic;
	i_data	: in std_logic;
	o_data	: out std_logic
	);
end entity;

architecture rtl of meta_ff is

signal r_data_1 : std_logic;

begin

process(i_clk) is
begin
	if rising_edge(i_clk) then
	
		r_data_1 <= i_data;
		o_data	<= r_data_1;	
	
	end if;
end process; 

end rtl;