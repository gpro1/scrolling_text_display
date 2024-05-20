-------------------------------------------------------------------------------------
-- pulse_stretch.vhd
--
-- Date: 05/20/2024
--
-- Engineer: Gregory Evans
--
-- Desc: 
--
--	Pulse stretching with configurable stretching parameters. Useful when crossing a pulse 
-- from a fast to a slow clock domain. 

--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_stretch is
 generic (
	g_FAST_CLK_FREQ	: natural := 0;
	g_SLOW_CLK_FREQ	: natural := 0
	);
 port (
	i_clk_fast	: in std_logic;
	i_clk_slow 	: in std_logic;
	i_pulse		: in std_logic;
	o_pulse		: out std_logic
	); 
end entity;

architecture rtl of pulse_stretch is

constant c_STRETCH_RATIO 	: natural := g_fAST_CLK_FREQ/g_sLOW_CLK_FREQ * 2;

signal r_count					: integer range 0 to 8 := 0; 
signal w_stretched			: std_logic := '0';

COMPONENT meta_ff
	PORT
	(
		i_clk			:	 IN STD_LOGIC;
		i_data		:	 IN STD_LOGIC;
		o_data		:	 OUT STD_LOGIC
	);
END COMPONENT;


begin

--Stretch pulse in fast domain
process (i_clk_fast) is
begin

	if rising_edge(i_clk_fast) then
	
		if i_pulse = '1' then
			r_count <= c_sTRETCH_RATIO;
		elsif r_count > 0 then
			r_count <= r_count - 1;
		end if;
		
	end if;
	
end process;

w_stretched <= '1' when r_count > 0 else '0';

--Handle metastability
meta_ff_1: meta_ff port map ( i_clk 	=> i_clk_slow,
										i_data	=> w_stretched,
										o_data	=> o_pulse );
										

end rtl;