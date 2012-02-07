-- wrap a very simple blink module for use in an EDK
-- based microprocessor project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blink is
  Port(
    clkin : in  STD_LOGIC;              -- clock it
    led : out  STD_LOGIC                -- single bit LED output
  );
end blink;

architecture Behavioral of blink is
  component blink_act
    port (
      clkin : in  std_logic;              -- clock
      led : out std_logic);             -- LED driver
  end component;

  signal led_reg : std_logic := '0';    -- LED register
  
begin
  -- user logic
  blink_instance : blink_act
    port map (
      clkin => clkin,                   -- clock is unregistered
      led => led_reg
    );

  reg_proc : process(clkin)
  begin
    if rising_edge(clkin) then
      led <= led_reg;                   -- transfer to output port
    end if;
  end process reg_proc;
  
end Behavioral;
