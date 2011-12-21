----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:13:47 10/28/2010 
-- Design Name: 
-- Module Name:    dproc_wrapper_to_bram - Behavioral 
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

entity dproc_wrapper_to_bram is
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
end dproc_wrapper_to_bram;

architecture Behavioral of dproc_wrapper_to_bram is
  component dproc_bram
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
  end component;

  -- signals
  signal rst_buf : std_logic := '0';
  signal data_in_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal ctrl_in_buf : std_logic := '0';

  signal ctrl_out_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal dbg_out_buf : std_logic_vector(31 downto 0) := X"00000000";

  signal dbram_en_buf : std_logic := '0';
  signal dbram_wre_buf : std_logic_vector(3 downto 0) := "0000";
  signal dbram_addr_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal dbram_dout_buf : std_logic_vector(31 downto 0) := X"00000000";
  
begin
  dproc_to_bram_instance : dproc_bram
    port map (
      clkin      => clkin,
      rst        => rst_buf,
      data_in    => data_in_buf,
      ctrl_in    => ctrl_in_buf,
      ctrl_out   => ctrl_out_buf,
      dbg_out    => dbg_out_buf,
      dbram_clk  => open,
      dbram_rst  => open,
      dbram_en   => dbram_en_buf,
      dbram_wre  => dbram_wre_buf,
      dbram_addr => dbram_addr_buf,
      dbram_dout => dbram_dout_buf
    );
  
  buf_process: process (clkin, rst)
  begin  -- process buf_process
    if rst = '0' then                   -- asynchronous reset (active low)
      rst_buf <= '1';
    elsif clkin'event and clkin = '1' then  -- rising clock edge
      rst_buf <= not rst;
      data_in_buf <= data_in;
      ctrl_in_buf <= ctrl_in;
      ctrl_out <= ctrl_out_buf;
      dbg_out <= dbg_out_buf;
      dbram_en <= dbram_en_buf;
      dbram_wre <= dbram_wre_buf;
      dbram_addr <= dbram_addr_buf;
      dbram_dout <= dbram_dout_buf;
      
    end if;
  end process buf_process;

  dbram_clk <= clkin;
  dbram_rst <= rst;
  
end Behavioral;

