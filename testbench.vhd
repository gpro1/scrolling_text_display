library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity;

architecture rtl of testbench is

	signal clk_50 		: std_logic := '0';
	
	signal sda			: std_logic := '1';
	signal scl			: std_logic := '1';


begin

clk_50 	<= not clk_50 after 20 ns;

DUT: entity work.top_level(rtl)
	port map ( 
		i_clk_50 => clk_50,
		io_sda	=> sda,
		o_scl		=> scl
		);
		
stimulus: process 
begin

	
	wait;


end process;


end architecture;