----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:00:35 10/28/2010 
-- Design Name: 
-- Module Name:    dsrc_wrapper_wire - Behavioral 
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

entity dsrc_wrapper_wire is
  port (
    clkin : in std_logic;
    rst : in std_logic;
    -- misc. GPIO lines
    data_out : out  std_logic_vector (31 downto 0);
    ctrl_out : out  std_logic;
    debug_out : out  std_logic_vector (31 downto 0);
    -- AC97 CODEC signals
    AC97Reset_n : out std_logic;
    AC97Clk   : in  std_logic;          -- master clock for design
    Sync      : out std_logic;
    SData_Out : out std_logic;
    SData_In  : in  std_logic
    );
end dsrc_wrapper_wire;

architecture Behavioral of dsrc_wrapper_wire is

  component dsrc_wire
    port (
      clkin : in std_logic;
      rst : in std_logic;
      -- misc. GPIO lines
      data_out : out  std_logic_vector (31 downto 0);
      ctrl_out : out  std_logic;
      debug_out : out  std_logic_vector (31 downto 0);
      -- AC97 CODEC signals
      AC97Reset_n : out std_logic;
      AC97Clk   : in  std_logic;          -- master clock for design
      Sync      : out std_logic;
      SData_Out : out std_logic;
      SData_In  : in  std_logic
    );
  end component;

  signal rst_buf : std_logic := '0';
  signal data_out_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal ctrl_out_buf : std_logic := '0';
  signal debug_out_buf : std_logic_vector(31 downto 0) := X"00000000";

  signal ac97reset_n_buf : std_logic := '0';
  signal ac97clk_buf : std_logic := '0';
  signal sync_buf : std_logic := '0';
  signal sdata_out_buf : std_logic := '0';
  signal sdata_in_buf : std_logic := '0';
  
begin
  dsrc_wrapper_instance : dsrc_wire
    port map (
      clkin       => clkin,
      rst         => rst_buf,
      data_out    => data_out_buf,
      ctrl_out    => ctrl_out_buf,
      debug_out   => debug_out_buf,
      AC97Reset_n => ac97reset_n_buf,
      AC97Clk     => AC97Clk,
      Sync        => sync_buf,
      SData_Out   => sdata_out_buf,
      SData_In    => sdata_in_buf
    );
    
  buf_process: process (clkin,rst)
  begin  -- process buf_process
    if rst = '0' then
      data_out_buf <= X"00000000";
      ctrl_out_buf <= '0';
      debug_out_buf <= X"00000000";
      -- ac97reset_n_buf <= '0';
      -- sync_buf <= '0';
      -- sdata_out_buf <= '0';
    elsif rising_edge(clkin) then
      
      data_out <= data_out_buf;
      ctrl_out <= ctrl_out_buf;
      debug_out <= debug_out_buf;

      AC97Reset_n <= ac97reset_n_buf;
      Sync <= sync_buf;
      SData_Out <= sdata_out_buf;
      sdata_in_buf <= SData_In;
      
    end if;
  end process buf_process;

  rst_buf <= not rst;

end Behavioral;

