----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:58 10/28/2010 
-- Design Name: 
-- Module Name:    dproc_wrapper_wire - Behavioral 
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

entity dproc_wrapper_wire is
  Port (
    clkin : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    data_in : in  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_in : in  STD_LOGIC;
    data_out : out  STD_LOGIC_VECTOR (31 downto 0);
    ctrl_out : out  STD_LOGIC;
    debug_out : out  STD_LOGIC_VECTOR (31 downto 0)
  );
end dproc_wrapper_wire;

architecture Behavioral of dproc_wrapper_wire is

  -- wrapped component
  component dproc_wire
    Port (
      clkin : in  STD_LOGIC;
      rst : in  STD_LOGIC;
      data_in : in  STD_LOGIC_VECTOR (31 downto 0);
      ctrl_in : in  STD_LOGIC;
      data_out : out  STD_LOGIC_VECTOR (31 downto 0);
      ctrl_out : out  STD_LOGIC;
      debug_out : out  STD_LOGIC_VECTOR (31 downto 0)
    );
  end component;

  -- signals
  signal rst_buf : std_logic;
  signal data_in_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal ctrl_in_buf : std_logic := '0';
  signal data_out_buf : std_logic_vector(31 downto 0) := X"00000000";
  signal ctrl_out_buf : std_logic := '0';
  signal debug_out_buf : std_logic_vector(31 downto 0) := X"00000000";
  
begin
  dproc_instance : dproc_wire
    port map (
      clkin     => clkin,
      rst       => rst_buf,
      data_in   => data_in_buf,
      ctrl_in   => ctrl_in_buf,
      data_out  => data_out_buf,
      ctrl_out  => ctrl_out_buf,
      debug_out => debug_out_buf
    );

  buf_process: process (clkin, rst)
  begin  -- process buf_process
    if rst = '0' then               -- asynchronous reset (active low)
      rst_buf <= '1';
      data_in_buf <= X"00000000";
      ctrl_in_buf <= '0';
      data_out_buf <= X"00000000";
      ctrl_out_buf <= '0';
      debug_out_buf <= X"00000000";
    elsif clkin'event and clkin = '1' then  -- rising clock edge
      rst_buf <= rst;
      data_in_buf <= data_in;
      ctrl_in_buf <= ctrl_in;
      data_out <= data_out_buf;
      ctrl_out <= ctrl_out_buf;
      debug_out <= debug_out_buf;
    end if;
  end process buf_process;

end Behavioral;

