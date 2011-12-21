----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:50 10/21/2010 
-- Design Name: 
-- Module Name:    proc_delay - Behavioral 
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

entity proc_delay is
  Port (
    clk : in  STD_LOGIC;
    eni : in  STD_LOGIC;
    din : in  STD_LOGIC_VECTOR (31 downto 0);
    eno : out  STD_LOGIC;
    dout : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end proc_delay;

architecture Behavioral of proc_delay is
  signal enbuf1 : std_logic := '0';  -- 1 clk delay buffer
  signal enbuf2 : std_logic := '0';  -- 1 clk delay buffer
  signal dbuf1 : std_logic_vector(31 downto 0) := X"00000000";  -- 1 clk delay buffer
  -- shift registers
  signal ensr : std_logic_vector(0 to 7) := X"00";  -- enable shift reg
  type vectorsr is array(0 to 7) of std_logic_vector(31 downto 0);
  signal datasr : vectorsr := (others => X"00000000");  -- ...
  
begin

  delay_process : process(clk)
  begin
    if rising_edge(clk) then
--      enbuf1 <= eni;
--      enbuf2 <= enbuf1;
--      dbuf1 <= din;
--      dout <= dbuf1;
--      eno <= enbuf1;
      -- eno <= eni;
      -- dout <= din;

      for i in 0 to 6 loop
        ensr(i+1) <= ensr(i);
        datasr(i+1) <= datasr(i);
      end loop;  -- i in 0 to 6 loop
      
      ensr(0) <= eni;
      datasr(0) <= din;
      
      eno <= ensr(7);
      dout <= datasr(7);
    end if;
  end process;

end Behavioral;
