----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:39 10/28/2010 
-- Design Name: 
-- Module Name:    dproc_wire_identity - Behavioral 
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

entity dproc_wire_identity is
  Port (
    clkin : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    data_in : in  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_in : in  STD_LOGIC;
    data_out : out  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_out : out  STD_LOGIC;
    debug_out : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end dproc_wire_identity;

architecture Behavioral of dproc_wire_identity is
  signal data_buf : std_logic_vector(31 downto 0) := X"00000000";
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
      data_buf <= X"00000000";
    elsif rising_edge(clkin) and ctrl_in = '1' then
      data_buf <= data_in;
    end if;
  end process;

  data_out <= data_buf;
  ctrl_out <= ctrl_buf;
  debug_out <= data_buf;

end Behavioral;

