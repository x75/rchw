----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:26:59 11/11/2011 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           i_en_osz : in  STD_LOGIC;
           i_ctrl : in  STD_LOGIC_VECTOR (31 downto 0);
           o_osz : out  STD_LOGIC;
           o_freq : out  STD_LOGIC_VECTOR (31 downto 0)
     );
end top;

architecture Behavioral of top is

  component frequency_divider_1
    port (
      clk   : in  std_logic;
      i_en  : in  std_logic;            -- enable
      o_osz : out std_logic);           -- oscillator output signal
  end component;

  component frequency_divider_2
    port (
      clk   : in  std_logic;
      i_en  : in  std_logic;            -- enable
      o_osz : out std_logic);           -- oscillator output signal
  end component;

  component eval_pulse_count
    port ( clk : in  STD_LOGIC;
           i_en : in  STD_LOGIC;
           i_ctrl : in  STD_LOGIC_VECTOR (31 downto 0);
           i_osz : in  STD_LOGIC;
           o_osz : out  STD_LOGIC;
           o_freq : out  STD_LOGIC_VECTOR (31 downto 0)
     );
  end component;
  
  signal o_osz_i : std_logic;

  
begin
  osc1 : frequency_divider_2 port map (
    clk   => clk,
    i_en  => i_en_osz,
    o_osz => o_osz_i);

  eval1 : eval_pulse_count port map (
    clk    => clk,
    i_en   => i_en_osz,
    i_ctrl => i_ctrl,
    i_osz  => o_osz_i,
    o_osz  => o_osz,
    o_freq => o_freq);
  
  -- dummy value
  --o_freq <= X"00000000";

end Behavioral;

