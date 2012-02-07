----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:35:39 07/22/2010 
-- Design Name: 
-- Module Name:    blink_fast_nr - Behavioral 
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blink_static is
  Port (
    clk : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    led : out  STD_LOGIC
  );
end blink_static;

architecture Behavioral of blink_static is
  signal count : unsigned(31 downto 0) := X"00000000";  -- counter
  
begin
  process(clk,rst)
  begin
--    if rst = '1' then
--      count <= X"00000000";
--    elsif rising_edge(clk) then
    if rising_edge(clk) then
      count <= count + 1;
    end if;
    led <= std_logic(count(23));
  end process;
  
end Behavioral;

