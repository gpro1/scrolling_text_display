-------------------------------------------------------------------------------------
-- display_driver.vhd
--
-- Date: 05/20/2024
--
-- Engineer: Gregory Evans
--
-- Desc: 
--
--	A driver for the IS31FL3731 LED matrix driver. 

--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_driver is
 port (
	i_clk				: in std_logic;
	i_rst				: in std_logic;
	i_i2c_data		: in unsigned(7 downto 0); 
	i_i2c_rdy		: in std_logic;
	o_i2c_en			: out std_logic; 
	o_i2c_addr_rw	: out unsigned(7 downto 0);
	o_i2c_data		: out unsigned(7 downto 0)
	);
	
end entity;
	
architecture rtl of display_driver is

type t_display_state is (idle, select_fxn_reg, select_fxn_reg_1, boot_up_display, boot_up_display_1, finish_transmission, done);
signal r_state 		: t_display_state := idle;

signal r_i2c_rdy_1	: std_logic := '0';

begin

process(i_clk, i_rst)
begin

	if i_rst = '1' then
	
		r_state 			<= idle;
		o_i2c_addr_rw 	<= (others => '0');
		o_i2c_data		<= (others => '0');
		o_i2c_en			<= '0';

	elsif rising_edge(i_clk) then
	
		r_i2c_rdy_1 <= i_i2c_rdy;

		case r_state is
		
		when idle =>
		
			r_state 			<= select_fxn_reg;
			o_i2c_addr_rw  <=	x"74"; --Write
			o_i2c_data		<= x"FD"; --Write
			o_i2c_en 		<= '1';
		
		when select_fxn_reg =>
			
			if r_i2c_rdy_1 = '0' and i_i2c_rdy = '1' then
			
				o_i2c_data  <= x"0B";
				r_state 		<= select_fxn_reg_1;
				
			end if;
		
		when select_fxn_reg_1 =>
			
			if r_i2c_rdy_1 = '0' and i_i2c_rdy = '1' then
			
				o_i2c_en	<= '0';
				r_state	<= boot_up_display;
				
			end if;
			
		when boot_up_display =>
		
			o_i2c_en 	<= '1';
			o_i2c_data 	<= x"0A";
			r_state 		<= boot_up_display_1;
			
		when boot_up_display_1 =>
			
			if r_i2c_rdy_1 = '0' and i_i2c_rdy = '1' then
				
				o_i2c_data 	<= x"01";
				r_state 		<= finish_transmission;
			
			end if;
			
		when finish_transmission =>
		
			if r_i2c_rdy_1 = '0' and i_i2c_rdy = '1' then
				
				r_state 	<= done;
				o_i2c_en	<= '0';
				
			end if;
			
		when done =>
		
		when others =>
		
		
		end case;
		
	end if;

end process;
	



end rtl;