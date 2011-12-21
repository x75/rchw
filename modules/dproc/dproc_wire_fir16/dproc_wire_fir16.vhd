----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:39 10/28/2010 
-- Design Name: 
-- Module Name:    dproc_wire_fir16 - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_wire_fir16 is
  generic (
    width : integer := 16;              -- bit width of input
    owidth : integer := 16;             -- bit width of output
    filtlen : integer := 16;            -- filter length
    pipelen : integer := 3              -- length of pipeline
  );
  Port (
    clkin : in  STD_LOGIC;
    rst : in  STD_LOGIC;
    data_in : in  STD_LOGIC_VECTOR ((2*width)-1 downto 0);
    ctrl_in : in  STD_LOGIC;
    data_out : out  STD_LOGIC_VECTOR ((2*width)-1 downto 0);
    ctrl_out : out  STD_LOGIC;
    debug_out : out  STD_LOGIC_VECTOR ((2*width)-1 downto 0)
  );
end dproc_wire_fir16;

architecture Behavioral of dproc_wire_fir16 is
  constant ctrl_delay : integer := pipelen;

  type bit_sr is array (0 to ctrl_delay) of std_logic;

  component fir_gen
    generic (
      W1      : integer;
      W2      : integer;
      W3      : integer;
      W4      : integer;
      L       : integer;
      Mpipe   : integer);
    port (
      clk       : in  std_logic;
      --clk_audio : in std_logic;
      Load_x    : in  std_logic;
      x_in      : in  std_logic_vector(width-1 downto 0);
      c_in      : in  std_logic_vector(width-1 downto 0);
      y_out     : out std_logic_vector(owidth-1 downto 0));
  end component;
  
  signal din_buf1 : std_logic_vector(width-1 downto 0) := X"0000";
  signal din_buf2 : std_logic_vector(width-1 downto 0) := X"0000";
  signal dout_buf : std_logic_vector((2*width)-1 downto 0) := X"00000000";
  -- signal ctrl_buf : std_logic := '0';
  signal ctrl_buf : bit_sr;

  -- fir1 signals
  signal Load_x1 : std_logic;
  -- signal x_in1 : std_logic_vector(width-1 downto 0);
  signal c_in1 : std_logic_vector(width-1 downto 0);
  signal y_out1 : std_logic_vector(owidth-1 downto 0);

    -- fir2 signals
  signal Load_x2 : std_logic;
  -- signal x_in2 : std_logic_vector(width-1 downto 0);
  signal c_in2 : std_logic_vector(width-1 downto 0);
  signal y_out2 : std_logic_vector(owidth-1 downto 0);

begin
  fir1 : fir_gen generic map (
    W1    => width,
    W2    => 32,
    W3    => 33,
    W4    => owidth,
    L     => filtlen,
    Mpipe => pipelen)
    port map (
      clk    => ctrl_in, -- clkin,
      --clk_audio => ctrl_in,
      Load_x => Load_x1,
      --x_in   => data_in((2*width)-1 downto width), -- din_buf1, right channel
      x_in   => din_buf1, --right channel
      c_in   => c_in1,
      y_out  => y_out1
    );

  fir2 : fir_gen generic map (
    W1    => width,
    W2    => 32,
    W3    => 33,
    W4    => owidth,
    L     => filtlen,
    Mpipe => pipelen)
    port map (
      clk    => ctrl_in, --clkin,
      --clk_audio => ctrl_in,
      Load_x => Load_x2,
      --x_in   => data_in(width-1 downto 0), -- din_buf2, left channel
      x_in   => din_buf2, --left channel
      c_in   => c_in2,
      y_out  => y_out2
    );

  main: process (clkin, rst)
  begin  -- process main
    if rst = '1' then                     -- asynchronous reset (active low)
      for I in 0 to ctrl_delay-1 loop
        ctrl_buf(I) <= '0';
      end loop;  -- I
      c_in1 <= X"0000";
      c_in2 <= X"0000";
      din_buf1 <= X"0001";              -- need to be set /= 0, otherwise one
                                        -- of the firs does not get connected
                                        -- during synthesis
      din_buf2 <= X"0001";
      dout_buf <= X"00000000";
      data_out <= X"00000000";
      debug_out <= X"00000000";
    elsif clkin'event and clkin = '1' then  -- rising clock edge
      --if ctrl_in = '1' then
      for I in 0 to ctrl_delay-2 loop
        ctrl_buf(I) <= ctrl_buf(I+1);
      end loop;  -- I
      ctrl_buf(ctrl_delay-1) <= ctrl_in;
      ctrl_out <= ctrl_buf(0);
      --else
      --  ctrl_out <= '0';
      --end if;
      din_buf1 <= data_in((2*width)-1 downto width);
      din_buf2 <= data_in(width-1 downto 0);
      ---- reverse bits
      --for i in 0 to width-1 loop
      --  din_buf2(i) <= data_in(width-1-i);
      --end loop;  -- i
      c_in1 <= X"0000";
      c_in2 <= X"0000";
      dout_buf <= y_out1 & y_out2;
      data_out <= dout_buf;
      debug_out <= X"00010001"; --dout_buf;
      --data_out <= y_out1 & y_out2;
      --debug_out <= y_out1 & y_out2;
    end if;
  end process main;

end Behavioral;

