----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:11:11 11/11/2011 
-- Design Name: 
-- Module Name:    eval_pulse_count - Behavioral 
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

entity eval_pulse_count is
    Port ( clk : in  STD_LOGIC;
           i_en : in  STD_LOGIC;
           i_ctrl : in  STD_LOGIC_VECTOR (31 downto 0);
           i_osz : in  STD_LOGIC;
           o_osz : out  STD_LOGIC;
           o_freq : out  STD_LOGIC_VECTOR (31 downto 0));
end eval_pulse_count;

architecture Behavioral of eval_pulse_count is
  signal ref_count : unsigned(31 downto 0)   := X"00000000";
  signal pulse_count : unsigned(31 downto 0) := X"00000000";
  signal pulse_count_dup : unsigned(31 downto 0) := X"00000000";
begin

  ---- count clock cycles as reference for frequency
  ---- emit measured frequency after end of reference period
  --process(clk)
  --begin
  --  if rising_edge(clk) then
  --    -- if ref_count = "00000101111101011110000100000000" then
  --    if ref_count = "00000000000000000000000000011111" then
  --      ref_count <= X"00000000";
  --      pulse_count_dup <= X"00000000";
  --      o_freq <= std_logic_vector(pulse_count);
  --    else
  --      ref_count <= ref_count + 1;
  --      pulse_count_dup <= pulse_count;
  --    end if;
  --  end if;
  --end process;

  ---- count pulses
  --process(i_osz)
  --begin
  --  if rising_edge(i_osz) then
  --    pulse_count <= pulse_count_dup + 1;
  --  end if;
  --end process;

  process(clk)
  begin
    if rising_edge(clk) then
      ref_count <= ref_count + 1;
    end if;
  end process;

  process(i_osz)
  begin
    if rising_edge(i_osz) then
      o_freq <= std_logic_vector(ref_count);
    end if;
  end process;
  
  o_osz <= i_osz;

end Behavioral;
