--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:15:17 06/22/2010
-- Design Name:   
-- Module Name:   /vol/fob-vol3/nebenf02/oberthol/SE_hwsv/DPR/experiments/audio_reconf_1/dsrc/dsrc_count1_tb.vhd
-- Project Name:  dsrc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dsrc_count1
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
-- that these types always be used for the dsrc_count1-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY dsrc_count1_tb IS
END dsrc_count1_tb;
 
ARCHITECTURE behavior OF dsrc_count1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dsrc_count1
    PORT(
         clkin : IN  std_logic;
         rst : IN  std_logic;
         buf_ctrl : OUT  std_logic_vector(31 downto 0);
         debug : OUT  std_logic_vector(31 downto 0);
         dbram_clk : OUT  std_logic;
         dbram_rst : OUT  std_logic;
         dbram_en : OUT  std_logic;
         dbram_wre : OUT  std_logic_vector(3 downto 0);
         dbram_addr : OUT  std_logic_vector(31 downto 0);
         dbram_dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clkin : std_logic; -- := '0';
   signal rst : std_logic; -- := '0';

 	--Outputs
   signal buf_ctrl : std_logic_vector(31 downto 0);
   signal debug : std_logic_vector(31 downto 0);
   signal dbram_clk : std_logic;
   signal dbram_rst : std_logic;
   signal dbram_en : std_logic;
   signal dbram_wre : std_logic_vector(3 downto 0);
   signal dbram_addr : std_logic_vector(31 downto 0);
   signal dbram_dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10ns;
   constant dbram_clk_period : time := 10ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dsrc_count1 PORT MAP (
          clkin => clkin,
          rst => rst,
          buf_ctrl => buf_ctrl,
          debug => debug,
          dbram_clk => dbram_clk,
          dbram_rst => dbram_rst,
          dbram_en => dbram_en,
          dbram_wre => dbram_wre,
          dbram_addr => dbram_addr,
          dbram_dout => dbram_dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clkin <= '0';
		wait for clk_period/2;
		clkin <= '1';
		wait for clk_period/2;
   end process;
 
   dbram_clk_process :process
   begin
		dbram_clk <= '0';
		wait for dbram_clk_period/2;
		dbram_clk <= '1';
		wait for dbram_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 20 ns;
		rst <= '0';

--      wait for clk_period*10;

      -- insert stimulus here 
--		wait for clk_period*8;
      wait;
   end process;

END;
