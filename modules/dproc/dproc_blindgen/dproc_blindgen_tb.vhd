--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:34:33 10/22/2010
-- Design Name:   
-- Module Name:   /vol/repl311-vol1/public/stud/oberthol/DPR/experiments/audio_reconf_1/resources/dproc/dproc_blindgen/dproc_blindgen_tb.vhd
-- Project Name:  dproc_blindgen
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dproc_blindgen
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
 
ENTITY dproc_blindgen_tb IS
END dproc_blindgen_tb;
 
ARCHITECTURE behavior OF dproc_blindgen_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dproc_blindgen
    PORT(
         clkin : IN  std_logic;
         ctrl_in : IN  std_logic_vector(31 downto 0);
         ctrl_out : OUT  std_logic_vector(31 downto 0);
         debug : OUT  std_logic_vector(31 downto 0);
         dbram_clk : OUT  std_logic;
         dbram_rst : OUT  std_logic;
         dbram_en : OUT  std_logic;
         dbram_wre : OUT  std_logic_vector(3 downto 0);
         dbram_addr : OUT  std_logic_vector(31 downto 0);
         dbram_dout : OUT  std_logic_vector(31 downto 0);
         sbram_clk : OUT  std_logic;
         sbram_rst : OUT  std_logic;
         sbram_en : OUT  std_logic;
         sbram_wre : OUT  std_logic_vector(3 downto 0);
         sbram_addr : OUT  std_logic_vector(31 downto 0);
         sbram_din : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clkin : std_logic := '0';
   signal ctrl_in : std_logic_vector(31 downto 0) := (others => '0');
   signal sbram_din : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal ctrl_out : std_logic_vector(31 downto 0);
   signal debug : std_logic_vector(31 downto 0);
   signal dbram_clk : std_logic;
   signal dbram_rst : std_logic;
   signal dbram_en : std_logic;
   signal dbram_wre : std_logic_vector(3 downto 0);
   signal dbram_addr : std_logic_vector(31 downto 0);
   signal dbram_dout : std_logic_vector(31 downto 0);
   signal sbram_clk : std_logic;
   signal sbram_rst : std_logic;
   signal sbram_en : std_logic;
   signal sbram_wre : std_logic_vector(3 downto 0);
   signal sbram_addr : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clkin_period : time := 10 ns;
   constant dbram_clk_period : time := 10 ns;
   constant sbram_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dproc_blindgen PORT MAP (
          clkin => clkin,
          ctrl_in => ctrl_in,
          ctrl_out => ctrl_out,
          debug => debug,
          dbram_clk => dbram_clk,
          dbram_rst => dbram_rst,
          dbram_en => dbram_en,
          dbram_wre => dbram_wre,
          dbram_addr => dbram_addr,
          dbram_dout => dbram_dout,
          sbram_clk => sbram_clk,
          sbram_rst => sbram_rst,
          sbram_en => sbram_en,
          sbram_wre => sbram_wre,
          sbram_addr => sbram_addr,
          sbram_din => sbram_din
        );

   -- Clock process definitions
   clkin_process :process
   begin
		clkin <= '0';
		wait for clkin_period/2;
		clkin <= '1';
		wait for clkin_period/2;
   end process;
 
   dbram_clk_process :process
   begin
		dbram_clk <= '0';
		wait for dbram_clk_period/2;
		dbram_clk <= '1';
		wait for dbram_clk_period/2;
   end process;
 
   sbram_clk_process :process
   begin
		sbram_clk <= '0';
		wait for sbram_clk_period/2;
		sbram_clk <= '1';
		wait for sbram_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
     -- hold reset state for 100 ns.
     -- wait for 100 ns;	

     -- wait for clkin_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
