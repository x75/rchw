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

entity dsrc_count1 is
  generic(
    buf_size : unsigned(15 downto 0) := X"0010" -- size of buffers
  );
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
end dsrc_count1;

architecture Behavioral of dsrc_count1 is
  signal count : unsigned(31 downto 0) := X"00000000";
  signal count2 : unsigned(31 downto 0) := X"00000000";
  signal gen_data : std_logic_vector(31 downto 0) := X"00000000";
  signal dbram_addr_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal dbram_dout_buf : std_logic_vector(31 downto 0) := X"00000000";
  -- signal state : std_logic_vector(1 downto 0) := "00";
  signal enwriter : std_logic := '0';

  -- double buffer bram writer
  component memwr_dbuf
    generic (
      buf_size : unsigned(15 downto 0));
    port (
      clk : in std_logic;
      rst : in std_logic;
      en  : in std_logic;
      data_in  : in  std_logic_vector(31 downto 0);
      addr_out : out std_logic_vector(31 downto 0);
      data_out : out std_logic_vector(31 downto 0);
      ctrl_out : out std_logic_vector(31 downto 0)
    );
  end component memwr_dbuf;
  
begin

  memwr_dbuf_i1 : memwr_dbuf
    generic map (
      buf_size => buf_size               -- / 4, 4-byte addressing -- X"0800"
    )
    port map (
      clk      => clkin,
      rst      => rst,
      en       => enwriter,
      data_in  => std_logic_vector(count2), -- gen_data,
      addr_out => dbram_addr_buf,
      data_out => dbram_dout_buf,
      ctrl_out => buf_ctrl
    );

  process(clkin,rst)
  begin
    if rst = '1' then
      count <= X"00000000";
      count2 <= X"00000000";
      debug <= X"00000003";
      -- buf_ctrl <= X"00000004";
      -- setup bram
      -- dbram_en <= '0';
      -- dbram_wre <= "0000";
      -- dbram_addr <= (others => '0');
      dbram_dout <= (others => '0');
    elsif rising_edge(clkin) then
      count <= count + 1;
      debug <= dbram_addr_buf; --std_logic_vector(count2(31 downto 1)) & enwriter;
      dbram_dout <= dbram_dout_buf;

      -- check state
      if count(9) = '1' then -- log(buf_size)/log(2)
        enwriter <= '1';
        count2 <= count2 + 1;
      else
        enwriter <= '0';
      end if;
            
    end if;
  end process;
  -- ungetaktet
  dbram_clk <= clkin;
  dbram_rst <= rst;

  dbram_en <= '1';
  dbram_wre <= "1111";

  dbram_addr <= dbram_addr_buf;
  
  -- gen_data <= std_logic_vector(count2);
  
  -- AC97 lines
  -- what are valid idle values?
  -- leave it open
  -- AC97Reset_n <= '1'; -- leave it alone
  -- Sync <=  '0';
  -- SData_Out <= '0';
  
end Behavioral;

