----------------------------------------------------------------------------------
-- Company: 
-- Engineer: oswald berthold
-- 
-- Create Date:    14:55:39 06/22/2010 
-- Design Name:    data source: counter
-- Module Name:    dsrc_db_writetest - Behavioral 
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

entity dsrc_db_writetest is
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
end dsrc_db_writetest;

architecture Behavioral of dsrc_db_writetest is
  signal count : unsigned(31 downto 0) := X"00000000";
  signal count2 : unsigned(31 downto 0) := X"00000000";
  signal dbram_addr_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal state : std_logic_vector(1 downto 0) := "00";
  signal enwriter : std_logic := '0';

  constant buf_size : unsigned(31 downto 0) := X"00000800";

begin

  process(clkin,rst)
  begin
    if rst = '1' then
      count <= X"00000000";
      debug <= X"00000003";
    elsif rising_edge(clkin) then
      if count < (2 * buf_size - 4) then
        count <= count + 4;
      else
        count <= (others => '0');
      end if;
      
      if count <= (buf_size - 4) then
        dbram_dout <= std_logic_vector(count + 1000);
        buf_ctrl <= X"00000002";
      else
        dbram_dout <= std_logic_vector(count + 2000);
        buf_ctrl <= X"00000001";
      end if;
        
      dbram_addr <= std_logic_vector(count);
      dbram_en <= '1';
      dbram_wre <= "1111";
      debug <= std_logic_vector(count);
      
    end if;
  end process;
  -- ungetaktet
  dbram_clk <= clkin;
  dbram_rst <= rst;


  -- dbram_addr <= dbram_addr_buf;
  
  -- AC97 lines
  -- what are valid idle values?
  -- leave it open
  -- AC97Reset_n <= '1'; -- leave it alone
  -- Sync <=  '0';
  -- SData_Out <= '0';
  
end Behavioral;

