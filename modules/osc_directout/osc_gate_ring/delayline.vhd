library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity delayline is
  generic (
    linelength : integer := 50);
  Port ( sgnl
         : in STD_LOGIC;
         delayed_sgnl : out STD_LOGIC );
end delayline;

architecture Behavioral of delayline is
  component inverter
    port(a
         : in std_logic;
         a_not : out std_logic );
  end component;
  
  signal avector : STD_LOGIC_VECTOR (0 to linelength+1); -- 51 inverters
  attribute keep : integer;
  attribute keep of avector: signal is 1;
--used so the synthesizer
--doesn't throw away inverters
begin
  avector(0) <= sgnl; --signal goes through first inverter
  g1: for i in 0 to linelength generate --up to 50 because of the indexing
    invrt: inverter port map ( avector(i), avector(i+1) ); --move signals through inverters
  end generate g1;
  delayed_sgnl <= avector(linelength+1); --signal comes out last inverter
end Behavioral;
