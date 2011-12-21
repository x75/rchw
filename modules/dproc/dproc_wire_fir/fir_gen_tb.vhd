--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:21:24 11/width-1/2010
-- Design Name:   
-- Module Name:   /vol/repl311-vol1/public/stud/oberthol/DPR/experiments/audio_reconf_1/resources/dproc/dproc_wire_fir/fir_gen_tb.vhd
-- Project Name:  dproc_wire_fir
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fir_gen
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--use ieee.STD_LOGIC_ARITH.all;
--use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fir_gen_tb IS
END fir_gen_tb;
 
ARCHITECTURE behavior OF fir_gen_tb IS 
  constant width : integer := 16;
  constant owidth : integer := width+2;
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT fir_gen
    generic (
      W1    : integer;
      W2    : integer;
      W3    : integer;
      W4    : integer;
      L     : integer;
      Mpipe : integer);
    PORT(
      clk : IN  std_logic;
      clk_audio : in std_logic;
      Load_x : IN  std_logic;
      x_in : IN  std_logic_vector(width-1 downto 0);
      c_in : IN  std_logic_vector(width-1 downto 0);
      y_out : OUT  std_logic_vector(owidth-1 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal clk : std_logic := '0';
  signal clk_audio : std_logic := '0';
  signal Load_x : std_logic := '0';
  signal x_in : std_logic_vector(width-1 downto 0) := (others => '0');
  signal c_in : std_logic_vector(width-1 downto 0) := (others => '0');

  --Outputs
  signal y_out : std_logic_vector(owidth-1 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;
  constant clk_audio_stretch : integer := 10;
  constant clk_audio_period : time := clk_audio_stretch * clk_period;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut : fir_gen generic map (
     W1    => width,
     W2    => 32,
     W3    => 33,
     W4    => owidth,
     L     => 4,
     Mpipe => 3)
     PORT MAP (
       clk => clk_audio, -- clk,
       clk_audio => clk_audio,
       Load_x => Load_x,
       x_in => x_in,
       c_in => c_in,
       y_out => y_out
     );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Clock process definitions
   clk_audio_process :process
   begin
     clk_audio <= '0';
     wait for clk_period * (clk_audio_stretch - 1);
     clk_audio <= '1';
     wait for clk_period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
     -- wait for 100 ns;	

     -- wait for clk_period*10;
      -- insert stimulus here
      -- ("ef6e" "1caf" "6b12" "3dd3")
     -- c_in <= X"00" & "01111100";               -- 124, 8 bit
     c_in <= X"3dd3";               -- 15827 15 bit
     wait for clk_audio_period;
     -- c_in <= X"00" & "11010110";               -- 214, 8 bit
     c_in <= X"6b12";               -- 27410, 15 bit
     wait for clk_audio_period;
     -- c_in <= X"00" & "00111001";               -- 57, 8 bit
     c_in <= X"1caf";               -- 7343, 15 bit
     wait for clk_audio_period;
     -- c_in <= "111011111";               -- -33, 8 bit
     c_in <= X"ef6e";                           -- -4241, 15 bit
     wait for clk_audio_period;
     c_in <= (others => '0');

     Load_x <= '1';
     wait for clk_audio_period*4;

     --x_in <= X"00" & "01100100";               -- 100
     --x_in <= X"7fff";               -- 100

     x_in <= std_logic_vector(to_signed(100, width));
     wait for clk_audio_period;
     x_in <= (others => '0');
     wait for clk_audio_period*4;
     
     x_in <= std_logic_vector(to_signed(-100, width));
     wait for clk_audio_period;
     x_in <= (others => '0');
     wait for clk_audio_period*4;
     

     --x_in <= X"00" & "01100100";               -- 100
     --x_in <= X"7fff";               -- 100
     x_in <= std_logic_vector(to_signed(2**(width-1)-1, width));
     wait for clk_audio_period*4;
     x_in <= (others => '0');
     
     wait;
   end process;

END;
