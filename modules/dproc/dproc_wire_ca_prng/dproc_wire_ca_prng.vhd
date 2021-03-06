----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:39 10/28/2010 
-- Design Name: 
-- Module Name:    dproc_wire_ca_prng - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_wire_ca_prng is
  generic (
    width : integer := 16  -- bit width of output
  );
  Port (
    clkin : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    data_in : in  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_in : in  STD_LOGIC;
    data_out : out  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_out : out  STD_LOGIC;
    debug_out : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end dproc_wire_ca_prng;

architecture Behavioral of dproc_wire_ca_prng is

  component ca_prng
    port (
      clk               : in  std_logic;
      reset_n           : in  std_logic;
      init_pattern_data : in  std_logic_vector(31 downto 0);
      load_init_pattern : in  std_logic;
      next_pattern      : in  std_logic;
      update_rule       : in  std_logic_vector(7 downto 0);
      load_update_rule  : in  std_logic;
      prng_data         : out std_logic_vector(31 downto 0));
  end component;
  
  signal din_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal dout_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal ctrl_buf : std_logic := '0';

  -- lfsr signals
  signal set_seed : std_logic := '0';
  signal seed : std_logic_vector(width-1 downto 0) := (0 => '1',others => '0');
  signal rand_out_buf : std_logic_vector(width-1 downto 0);

begin

  ca_prng_inst: ca_prng
    port map (
      clk => clkin,
      reset_n => reset_n_buf,
      init_pattern_data => init_pattern_data_buf,
      load_init_pattern => load_init_pattern_buf,
      next_pattern => next_pattern_buf,
      update_rule => update_rule_buf,
      load_update_rule => load_update_rule_buf,
      prng_data => prng_data_buf
    );

  ctrl : process(clkin,rst)
  begin
    if rst = '1' then
      ctrl_buf <= '0';
      set_seed <= '1';
      dout_buf <= X"00000000";
      data_out <= X"00000000";
      debug_out <= X"00000000";
    elsif rising_edge(clkin) then
      ctrl_buf <= ctrl_in;
      set_seed <= '0';
      dout_buf <= rand_out_buf & rand_out_buf;
      data_out <= dout_buf;
      debug_out <= dout_buf;
      ctrl_out <= ctrl_buf;
    end if;
  end process;
  
--  data: process(clkin,rst)
--  begin
--    if rst = '1' then
--    -- elsif rising_edge(clkin) and ctrl_in = '1' then
--    elsif rising_edge(clkin) then
--    end if;
--  end process;

  -- seed <= X"0001";
  seed <= data_in(15 downto 0);
  
end Behavioral;

