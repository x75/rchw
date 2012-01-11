----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:28:22 11/11/2011 
-- Design Name: 
-- Module Name:    frequency_divider_1 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity frequency_divider_1 is
    Port ( clk : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           data: in STD_LOGIC;
           o_out : out  STD_LOGIC;
           o_inv : out  STD_LOGIC
           );
end frequency_divider_1;

architecture Behavioral of frequency_divider_1 is

  -- a = 100000000
  -- b =  50000000
  
  -- signal d, dInc, dN : std_logic_vector(7 downto 0);
  -- signal d, dInc, dN : signed(26 downto 0)  := signed(0);

  signal o_osz_0, o_osz_1 : std_logic;

  component freq_div_mod_1
    port (
      clk   : in  std_logic;            -- Clock
      enable  : in  std_logic;
      o_osz : out std_logic);
  end component;
begin

  freq_div_mod_1_inst_0 : freq_div_mod_1 port map (
    clk   => clk,
    enable  => enable,
    o_osz => o_osz_0
  );

  d <= enable; -- (others => '0');

  freq_div_mod_1_inst_1 : freq_div_mod_1 port map (
    clk   => clk,
    enable  => enable,
    o_osz => o_osz_1
    );

  o_out <= o_osz_0 and o_osz_1;
  o_inv <= not(o_osz_0 and o_osz_1);
  
  process(clk)
    begin
    end process;
  
end Behavioral;

