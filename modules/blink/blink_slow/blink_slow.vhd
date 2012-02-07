-- Reconfigurable Module implementation for LED blink module
-- low frequency

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity blink_slow is
  Port (
    clkin : in  STD_LOGIC;
    led : out  STD_LOGIC
  );
end blink_slow;

architecture Behavioral of blink_slow is
  signal count : unsigned(31 downto 0) := X"00000000";  -- counter
  
begin
  process(clkin)
  begin
    if rising_edge(clkin) then
      count <= count + 1;
    end if;
  -- bit 27 at 100MHz ~1.34 seconds
    led <= std_logic(count(26));
  end process;
  
end Behavioral;

