--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:56:19 11/11/2011
-- Design Name:   
-- Module Name:   /vol/repl311-vol1/public/stud/oberthol/DPR/experiments/modules/osz/osz_sys_1/top_tb.vhd
-- Project Name:  osz_sys_1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         i_en_osz : IN  std_logic;
         i_ctrl : IN  std_logic_vector(31 downto 0);
         o_osz : OUT  std_logic;
         o_freq : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal i_en_osz : std_logic := '0';
   signal i_ctrl : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal o_osz : std_logic;
   signal o_freq : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk => clk,
          rst => rst,
          i_en_osz => i_en_osz,
          i_ctrl => i_ctrl,
          o_osz => o_osz,
          o_freq => o_freq
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	

      -- wait for clk_period*10;

      -- insert stimulus here 
      i_en_osz <= '1';
      i_ctrl <= X"00000000";
      
      
      wait;
   end process;

END;
