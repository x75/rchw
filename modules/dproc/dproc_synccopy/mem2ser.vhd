----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:34 10/19/2010 
-- Design Name: 
-- Module Name:    mem2ser - Behavioral 
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

entity mem2ser is
  Port (
    clk : in  STD_LOGIC;
    buf_i : in  STD_LOGIC;
    din : in  STD_LOGIC_VECTOR (31 downto 0);
    dout : out  STD_LOGIC_VECTOR (31 downto 0);
    addr : out  STD_LOGIC_VECTOR (31 downto 0)
    );
end mem2ser;

architecture Behavioral of mem2ser is

begin


end Behavioral;
