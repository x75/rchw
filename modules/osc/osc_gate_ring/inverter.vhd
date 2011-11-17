library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity inverter is
  Port ( a
         : in STD_LOGIC;
         a_not : out STD_LOGIC );
end inverter;
architecture Behavioral of inverter is
begin
  a_not <= not(a); --inverter
end Behavioral;
