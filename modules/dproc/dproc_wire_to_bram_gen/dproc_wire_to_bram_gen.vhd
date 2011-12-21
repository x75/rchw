----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:06:50 10/22/2010 
-- Design Name: 
-- Module Name:    dproc_wire_to_bram_gen - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_wire_to_bram_gen is
  generic (
    buf_size : unsigned(15 downto 0) := X"0800"    -- buffer size
  );
  Port(
    -- clock, reset
    clkin : in  STD_LOGIC;
    rst : in std_logic;

    -- inputs
    data_in : in  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_in : in  STD_LOGIC;

    -- outputs
    ctrl_out : out std_logic_vector(31 downto 0);
    dbg_out : out std_logic_vector(31 downto 0);  -- debug
    dbram_clk : out  STD_LOGIC;
    dbram_rst : out  STD_LOGIC;
    dbram_en : out  STD_LOGIC;
    dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end dproc_wire_to_bram_gen;

architecture Behavioral of dproc_wire_to_bram_gen is

  signal addr_dst : unsigned(31 downto 0) := X"00000000";
  signal data_buf : unsigned(31 downto 0) := X"00000000";

begin
  process(clkin,rst)
  begin
    if rst = '1' then
      addr_dst <= X"00000000";
    elsif rising_edge(clkin) and ctrl_in = '1' then
      addr_dst <= addr_dst + 4;
      data_buf <= addr_dst;
      -- ctrl line
      if addr_dst = (buf_size - 4) then
        ctrl_out <= X"00000001";
      elsif addr_dst >= (2 * buf_size - 4) then
        ctrl_out <= X"00000002";
        -- reset addr counter
        addr_dst <= X"00000000";
      end if;
    end if;
    
  end process;

  dbg_out <= std_logic_vector(addr_dst);
  dbram_clk <= '0';
  dbram_rst <= '0';
  dbram_addr <= std_logic_vector(addr_dst);
  dbram_dout <= std_logic_vector(data_buf);
  dbram_en <= '1';
  dbram_wre <= "1111";
  
  
end Behavioral;
