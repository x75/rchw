----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:02:06 07/22/2010 
-- Design Name: 
-- Module Name:    blink - Behavioral 
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

entity blink is
  Port(
    clkin : in  STD_LOGIC;
--    rst : in  STD_LOGIC;
    led : out  STD_LOGIC
  );
end blink;

architecture Behavioral of blink is
  component blink_act
    port (
      clkin : in  std_logic;              -- clock
--      rst : in  std_logic;              -- reset
      led : out std_logic);             -- LED driver
  end component;

  signal led_reg : std_logic := '0';    -- LED register
  
begin
  -- user logic
  blink_instance : blink_act
    port map (
      clkin => clkin,
--      rst => rst,
-- changed 20100729
      led => led_reg
--      led => led
    );

-- changed 20100729
  reg_proc : process(clkin)
    begin
      if rising_edge(clkin) then
        led <= led_reg;
      end if;
    end process reg_proc;
    
end Behavioral;

