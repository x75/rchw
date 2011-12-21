----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:39 10/28/2010 
-- Design Name: 
-- Module Name:    dproc_wire_fixedgain - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_wire_fixedgain is
  Port (
    clkin : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    data_in : in  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_in : in  STD_LOGIC;
    data_out : out  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_out : out  STD_LOGIC;
    debug_out : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end dproc_wire_fixedgain;

architecture Behavioral of dproc_wire_fixedgain is
  signal data_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal s1 : signed(15 downto 0) := X"0000";
  signal s2 : signed(15 downto 0) := X"0000";
  signal s3 : signed(31 downto 0) := X"00000000";
  signal s4 : signed(31 downto 0) := X"00000000";
  signal s5 : std_logic_vector(15 downto 0) := X"0000";
  signal s6 : std_logic_vector(15 downto 0) := X"0000";
  signal ctrl_buf : std_logic := '0';
  
begin

  ctrl : process(clkin,rst)
  begin
    if rst = '1' then
      ctrl_buf <= '0';
    elsif rising_edge(clkin) then
      ctrl_buf <= ctrl_in;
    end if;
  end process;
  
  data: process(clkin,rst)
  begin
    if rst = '1' then
      data_buf <= X"00010001";
      s1 <= X"0001";
      s2 <= X"0001";
      s3 <= X"00000001";
      s4 <= X"00000001";
      s5 <= X"0001";
      s6 <= X"0001";
    elsif rising_edge(clkin) and ctrl_in = '1' then
      s1 <= signed(data_in(31 downto 16));
      s3 <= s1 * to_signed(2**13, 16);  -- divide by 4
      s2 <= signed(data_in(15 downto 0));
      s4 <= s2 * to_signed(2**13, 16);   -- divide by 4
      s5 <= std_logic_vector(s3(31 downto 16));
      s6 <= std_logic_vector(s4(31 downto 16));
      data_buf <= s5 & s6;
    end if;
  end process;

  data_out <= s5 & s6; --data_buf;
  ctrl_out <= ctrl_buf;
  debug_out <= data_buf;

end Behavioral;
