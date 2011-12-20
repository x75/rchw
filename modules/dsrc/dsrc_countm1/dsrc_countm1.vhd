----------------------------------------------------------------------------------
-- Company: 
-- Engineer: oswald berthold
-- 
-- Create Date:    14:55:39 06/22/2010 
-- Design Name:    data source: counter
-- Module Name:    dsrc_count1 - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsrc_countm1 is
--  Generic(
--    dblbufsize : std_logic_vector(15 downto 0) := X"0080" -- size of buffers
--    );
  Port(
    clkin : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    -- misc. GPIO lines
    buf_ctrl : out  STD_LOGIC_VECTOR (31 downto 0);
    debug : out  STD_LOGIC_VECTOR (31 downto 0);
    -- BRAM interface
    dbram_clk : out  STD_LOGIC;
    dbram_rst : out  STD_LOGIC;
    dbram_en : out  STD_LOGIC;
    dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
    -- AC97 CODEC signals
    AC97Reset_n : out std_logic;
    AC97Clk   : in  std_logic;          -- master clock for design
    Sync      : out std_logic;
    SData_Out : out std_logic;
    SData_In  : in  std_logic
    );
end dsrc_countm1;

architecture Behavioral of dsrc_countm1 is
  signal count : unsigned(31 downto 0) := X"00000000";
  signal state : std_logic_vector(1 downto 0) := "00";

begin
  process(clkin,rst)
  begin
    if rst = '1' then
      count <= X"00000000";
      debug <= X"00000001";
      buf_ctrl <= X"00000002";
      -- setup bram
      dbram_en <= '0';
      dbram_wre <= "0000";
      dbram_addr <= (others => '0');
      dbram_dout <= (others => '0');
    elsif rising_edge(clkin) then
      count <= count - 1;
      debug <= std_logic_vector(count);
      dbram_en <= '1';
      dbram_wre <= "1111";
      dbram_addr <= std_logic_vector(count);  -- actually: high - count
      dbram_dout <= std_logic_vector(count);
      -- check state
      if count(7) = '1' then
        buf_ctrl <= X"00000001";
      else
        buf_ctrl <= X"00000000";
      end if;
    end if;
  end process;
  -- ungetaktet
  dbram_clk <= clkin;
  dbram_rst <= rst;
  -- AC97 lines
  -- what are valid idle values?
  AC97Reset_n <= '1';
  Sync <= '0';
  SData_Out <= '0';

end Behavioral;
