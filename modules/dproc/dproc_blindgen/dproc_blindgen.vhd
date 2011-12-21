----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:06:50 10/22/2010 
-- Design Name: 
-- Module Name:    dproc_blindgen - Behavioral 
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

entity dproc_blindgen is
  generic (
    buf_size : unsigned(15 downto 0) := X"0800"    -- buffer size
  );
  Port(
    clkin : in  STD_LOGIC;
    -- GPIO lines
    ctrl_in : in  STD_LOGIC_VECTOR (31 downto 0);  -- control inputs from
                                                   -- software, was reset
    ctrl_out : out  STD_LOGIC_VECTOR (31 downto 0);
    debug : out  STD_LOGIC_VECTOR (31 downto 0);
    -- BRAM interface
    dbram_clk : out  STD_LOGIC;
    dbram_rst : out  STD_LOGIC;
    dbram_en : out  STD_LOGIC;
    dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
    -- BRAM interface
    sbram_clk : out  STD_LOGIC;
    sbram_rst : out  STD_LOGIC;
    sbram_en : out  STD_LOGIC;
    sbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    sbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    sbram_din : in  STD_LOGIC_VECTOR (31 downto 0)
    
    );
end dproc_blindgen;

architecture Behavioral of dproc_blindgen is

    signal addr_dst : unsigned(31 downto 0) := X"00000000";
    signal sbram_din_dump : std_logic_vector(31 downto 0) := X"00000000";
    signal ctrl_in_dump : std_logic_vector(31 downto 0) := X"00000000";


begin
  process(clkin)
  begin
    if rising_edge(clkin) then
      addr_dst <= addr_dst + 4;
      if addr_dst >= buf_size then
        dbram_dout <= std_logic_vector(addr_dst + 2000);
      else
        dbram_dout <= std_logic_vector(addr_dst + 1000);
      end if;
      if addr_dst >= (2 * buf_size - 4) then
        addr_dst <= (others => '0');
      end if;
      dbram_addr <= std_logic_vector(addr_dst);
      dbram_en <= '1';
      dbram_wre <= "1111";
      debug <= std_logic_vector(addr_dst);
      
    end if;
    
  end process;
  dbram_clk <= '0';
  dbram_rst <= '0';
  sbram_clk <= '0';
  sbram_rst <= '0';
  sbram_en <= '0';
  sbram_wre <= "0000";
  sbram_addr <= X"00000000";
  ctrl_out <= X"00000001";
  
  sbram_din_dump <= sbram_din;
  ctrl_in_dump <= ctrl_in;
  
end Behavioral;

