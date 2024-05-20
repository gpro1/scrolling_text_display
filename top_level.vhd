library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
 port (
	i_clk_50	: in std_logic;
	io_sda	: inout std_logic;
	o_scl		: out std_logic
	);
end top_level;


architecture rtl of top_level is

signal i2c_clk					: std_logic := '0';
signal i2c_en					: std_logic := '0';
signal i2c_rdy					: std_logic	:= '0';
signal i2c_addr				: unsigned(7 downto 0) := (others => '0');
signal i2c_transmit_data 	: unsigned(7 downto 0) := (others => '0');
signal i2C_receive_data		: unsigned(7 downto 0) := (others => '0');




begin

i2c_driver: entity work.i2c_driver(rtl)
	port map (
		i_clk 			=> i2c_clk,
		i_en				=> i2c_en, --Must be pulse stretched
		i_bus_addr_rw 	=> i2c_addr, 
		i_bus_data		=> i2c_transmit_data,
		o_rdy				=> i2c_rdy, --Must be put through metastability ff
		o_data			=> i2c_receive_data,
		o_sda				=> io_sda,
		o_scl				=> o_scl
		);
		
display_driver: entity work.display_driver(rtl)
	port map (
		i_clk				=> i_clk_50,
		i_i2c_data		=> i2c_receive_data,
		i_i2c_rdy		=> i2c_rdy,
		o_i2c_en			=> i2c_en,
		o_i2c_addr_rw	=> i2c_addr
      o_i2c_data		=> i2c_transmit_data,

end rtl;