----------------------------------------------------------------------------------
-- Company: 
-- Engineer: oswald berthold
-- 
-- Create Date:    14:55:39 06/22/2010 
-- Design Name:    data source: counter
-- Module Name:    dproc_copyadd - Behavioral 
-- Project Name:   audio_reconf
-- Target Devices: ml507 / xc5v70fxt-1-1xxx
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
use IEEE.STD_logic_arith.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_copyadd is
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
end dproc_copyadd;

architecture Behavioral of dproc_copyadd is
  signal count : unsigned(31 downto 0) := X"00000000";
  signal state : std_logic_vector(1 downto 0) := "00";
  signal d1 : std_logic_vector(31 downto 0) := X"00000000";  -- data vector 1
  
begin
  process(clkin)
  begin
--    if rst = '1' then
--      count <= X"00000000";
--      debug <= X"00000003";
--      buf_ctrl <= X"00000004";
--      -- setup bram
--      dbram_en <= '0';
--      dbram_wre <= "0000";
--      dbram_addr <= (others => '0');
--      dbram_dout <= (others => '0');
--    elsif rising_edge(clkin) then
    if rising_edge(clkin) then
      count <= count + 4;
      debug <= std_logic_vector(count);
      dbram_addr <= std_logic_vector(count);
      -- dbram_dout <= sbram_din and X"00000100";
      dbram_dout <= sbram_din;

      -- d1 <= sbram_din;
      
      sbram_wre <= "0000";
      sbram_addr <= std_logic_vector(count);
      
      -- check state
      if count(7) = '1' then
        ctrl_out <= X"00000002";
      else
        ctrl_out <= X"00000001";
      end if;
    end if;
  end process;
  -- ungetaktet
  sbram_en <= '1';
  dbram_en <= '1';
  dbram_wre <= "1111";
  
  dbram_clk <= clkin;
  dbram_rst <= '0'; -- rst;
  sbram_clk <= clkin;
  sbram_rst <= '0'; -- rst;
  
end Behavioral;

