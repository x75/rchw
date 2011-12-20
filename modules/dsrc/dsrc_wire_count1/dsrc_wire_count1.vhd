----------------------------------------------------------------------------------
-- Company: 
-- Engineer: oswald berthold
-- 
-- Create Date:    14:55:39 06/22/2010 
-- Design Name:    data source: counter
-- Module Name:    dsrc_count1 - Behavioral 
-- Project Name:   audio_reconf
-- Target Devices: ml507 / xc5v70fxt-1-1xxx
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsrc_wire_count1 is
  port (
    clkin : in std_logic;
    rst : in std_logic;
    -- misc. GPIO lines
    data_out : out  std_logic_vector (31 downto 0);
    ctrl_out : out  std_logic;
    debug_out : out  std_logic_vector (31 downto 0);
    -- AC97 CODEC signals
    AC97Reset_n : out std_logic;
    AC97Clk   : in  std_logic;          -- master clock for design
    Sync      : out std_logic;
    SData_Out : out std_logic;
    SData_In  : in  std_logic
    );
end dsrc_wire_count1;

architecture Behavioral of dsrc_wire_count1 is
  signal c1, c2 : unsigned(31 downto 0) := X"00000000";
  signal enable : std_logic := '0';
  
begin

  process(clkin,rst)
  begin
    if rst = '1' then
      c1 <= X"00000000";
      c2 <= X"00000000";
    elsif rising_edge(clkin) then
      c1 <= c1 + 1;

      -- freq. division
      if c1(11) = '1' then
        enable <= '1';
        c2 <= c2 + 1;
      else
        enable <= '0';
      end if;
    end if;
  end process;

  data_out <= std_logic_vector(c2);
  ctrl_out <= enable;
  debug_out <= std_logic_vector(c2);
  
  -- ungetaktet

  -- AC97 lines
  -- what are valid idle values?
  -- leave it open
  -- AC97Reset_n <= '1'; -- leave it alone
  -- Sync <=  '0';
  -- SData_Out <= '0';
  
end Behavioral;

