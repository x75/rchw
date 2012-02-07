-- Reconfigurable Module implementation for LED blink module
-- high frequency

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity blink_fast is
  Port (
    clkin : in  STD_LOGIC;
    led : out  STD_LOGIC
  );
end blink_fast;

architecture Behavioral of blink_fast is
  signal count : unsigned(31 downto 0) := X"00000000";  -- counter
  
begin
  process(clkin)
  begin
    if rising_edge(clkin) then
      count <= count + 1;
    end if;
    -- bit 23 at 100MHz ~0.08 seconds
    led <= std_logic(count(22));
  end process;
  
end Behavioral;
