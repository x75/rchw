----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:11:36 11/15/2010 
-- Design Name: 
-- Module Name:    my_mult - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.all;
--use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_mult is
  generic (
    my_widtha         : integer := 9;
    my_widthb         : integer := 9;
    my_pipeline       : integer := 3;
    my_representation : string  := "SIGNED";
    my_widthp         : integer := 18;
    my_widths         : integer := 18
  );
  Port (
    clock : in  STD_LOGIC;
    dataa : in  STD_LOGIC_VECTOR (my_widtha-1 downto 0);
    datab : in  STD_LOGIC_VECTOR (my_widthb-1 downto 0);
    result : out  STD_LOGIC_VECTOR (my_widthp-1 downto 0)
  );
end my_mult;

architecture struct of my_mult is
  subtype resdata is std_logic_vector(my_widthp-1 downto 0);

  type array_resdata is array (0 to my_pipeline-1) of resdata;
  
  signal result_buf : signed(my_widthp-1 downto 0);

  -- signal r : array_resdata;
begin
  mult: process (clock)
  begin  -- process mult
    if rising_edge(clock) then
      result_buf <= signed(dataa) * signed(datab);
--      result <= STD_LOGIC_VECTOR(dataa * datab);
--      for I in 0 to my_pipeline-2 loop
--        r(I) <= r(I+1);
--      end loop;  -- I
--      r(my_pipeline-1) <= STD_LOGIC_VECTOR(dataa * datab);
    end if;
  end process mult;
  
  result <= STD_LOGIC_VECTOR(result_buf);
--  result <= r(0);
  
end struct;
