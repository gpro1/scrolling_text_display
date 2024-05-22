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
signal i2c_pll_locked		: std_logic := '0';

signal display_rst			: std_logic := '1';

signal i2c_en_50				: std_logic := '0'; --system clock domain
signal i2c_en					: std_logic := '0'; --i2c clock domain

signal i2c_rdy_50				: std_logic := '0'; --system clock domain
signal i2c_rdy					: std_logic	:= '0'; --i2c clock domain

signal i2c_addr				: unsigned(7 downto 0) := (others => '0');
signal i2c_transmit_data 	: unsigned(7 downto 0) := (others => '0');
signal i2C_receive_data		: unsigned(7 downto 0) := (others => '0');

component i2c_clk_pll
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
end component;

component meta_ff
	port
	(
		i_clk			: in std_logic;
		i_data		: in std_logic;
		o_data		: out std_logic
	);
end component;

component pulse_stretch
	generic (
		g_FAST_CLK_FREQ	: natural := 1;
		g_SLOW_CLK_FREQ	: natural := 1
		);
	port 
	(
		i_clk_fast	: in std_logic;
		i_clk_slow 	: in std_logic;
		i_pulse		: in std_logic;
		o_pulse		: out std_logic
	);
end component;


begin


--Create I2C Clock
i2c_clk_gen: i2c_clk_pll
	port map (
		areset 	=> '0',
		inclk0 	=> i_clk_50,
		c0			=> i2c_clk,
		locked	=> i2c_pll_locked
		);

--Clock domain crossing
i2c_en_pulse_stretch: pulse_stretch
	generic map (
		g_FAST_CLK_FREQ => 50000000,
		g_SLOW_CLK_FREQ => 100000
		)
	port map (
		i_clk_fast 	=> i_clk_50,
		i_clk_slow 	=> i2c_clk,
		i_pulse		=> i2c_en_50,
		o_pulse		=> i2c_en
		);

--Clock domain crossing		
i2c_rdy_meta_ff: meta_ff
	port map (
		i_clk 	=> i_clk_50,
		i_data 	=>	i2c_rdy,
		o_data	=> i2c_rdy_50
		);

--I2C Driver
i2c_driver: entity work.i2c_driver(rtl)
	port map (
		i_clk 			=> i2c_clk,
		i_en				=> i2c_en, 
		i_bus_addr_rw 	=> i2c_addr, 
		i_bus_data		=> i2c_transmit_data, --Double-check for metastability issues
		o_rdy				=> i2c_rdy, 
		o_data			=> i2c_receive_data, --Double-check for metastability issues
		o_sda				=> io_sda,
		o_scl				=> o_scl
		);
		
--Display driver
display_driver: entity work.display_driver(rtl)
	port map (
		i_clk				=> i_clk_50,
		i_rst				=> display_rst,
		i_i2c_data		=> i2c_receive_data,
		i_i2c_rdy		=> i2c_rdy_50,
		o_i2c_en			=> i2c_en_50,
		o_i2c_addr_rw	=> i2c_addr,
      o_i2c_data		=> i2c_transmit_data
		);
		
display_rst <= '0' when i2c_pll_locked = '1' else '1';

end rtl;