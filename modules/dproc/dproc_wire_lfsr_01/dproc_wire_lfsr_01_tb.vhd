--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:29:30 11/04/2010
-- Design Name:   
-- Module Name:   /vol/repl311-vol1/public/stud/oberthol/DPR/experiments/audio_reconf_1/resources/dproc/dproc_wire_lfsr_01/dproc_wire_lfsr_01_tb.vhd
-- Project Name:  dproc_wire_lfsr_01
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dproc_wire_lfsr_01
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY dproc_wire_lfsr_01_tb IS
END dproc_wire_lfsr_01_tb;

ARCHITECTURE behavior OF dproc_wire_lfsr_01_tb IS 
  
  -- Component Declaration for the Unit Under Test (UUT)
  
  COMPONENT dproc_wire_lfsr_01
    PORT(
      clkin : IN  std_logic;
      rst : IN  std_logic;
      data_in : IN  std_logic_vector(31 downto 0);
      ctrl_in : IN  std_logic;
      data_out : OUT  std_logic_vector(31 downto 0);
      ctrl_out : OUT  std_logic;
      debug_out : OUT  std_logic_vector(31 downto 0)
      );
  END COMPONENT;
  

  --Inputs
  signal clkin : std_logic := '0';
  signal rst : std_logic := '0';
  signal data_in : std_logic_vector(31 downto 0) := (others => '0');
  signal ctrl_in : std_logic := '0';

  --Outputs
  signal data_out : std_logic_vector(31 downto 0);
  signal ctrl_out : std_logic;
  signal debug_out : std_logic_vector(31 downto 0);

  -- Clock period definitions
  constant clkin_period : time := 10 ns;
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: dproc_wire_lfsr_01 PORT MAP (
    clkin => clkin,
    rst => rst,
    data_in => data_in,
    ctrl_in => ctrl_in,
    data_out => data_out,
    ctrl_out => ctrl_out,
    debug_out => debug_out
    );

  -- Clock process definitions
  clkin_process :process
  begin
    clkin <= '0';
    wait for clkin_period/2;
    clkin <= '1';
    wait for clkin_period/2;
  end process;
  

  -- Stimulus process
  stim_proc: process
  begin		
    -- hold reset state for 100 ns.
--    rst <= '1';
--    wait for 10 ns;
--    rst <= '0';

    wait for 20 ns;
    
    for i in 0 to 128 loop
      data_in <= X"00000000";
      ctrl_in <= '1';
      wait for 10 ns;
      ctrl_in <= '0';
      wait for 90 ns;
    end loop;  -- i


    -- insert stimulus here 

    wait;
  end process;

END;
