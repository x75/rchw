--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:05:12 11/17/2010
-- Design Name:   
-- Module Name:   /vol/repl311-vol1/public/stud/oberthol/DPR/experiments/audio_reconf_1/resources/dproc/dproc_wire_fir16/dproc_wire_fir16_tb.vhd
-- Project Name:  dproc_wire_fir16
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dproc_wire_fir16
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
use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY dproc_wire_fir16_tb IS
END dproc_wire_fir16_tb;
 
ARCHITECTURE behavior OF dproc_wire_fir16_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dproc_wire_fir16
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
   uut: dproc_wire_fir16 PORT MAP (
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
     variable i1 : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(2**15-1, 16));
     variable i2 : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(-2**15, 16));
     variable i3 : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(2**12, 16));
     variable i4 : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(-2**8, 16));
     variable i5 : std_logic_vector(15 downto 0) := std_logic_vector(to_signed(-2**8, 16));
     
   begin		
     -- hold reset state for 100 ns.
     rst <= '1';
     wait for 20 ns;
     rst <= '0';

     for i in 0 to 15 loop
       data_in <= X"00000000";            -- 10000
       ctrl_in <= '1';
       wait for 10ns;
       ctrl_in <= '0';
       wait for 90ns;
     end loop;                          -- i

     --for i in 0 to 128 loop
     --  data_in <= std_logic_vector(to_unsigned(i, 16)) & std_logic_vector(to_unsigned(i, 16));
     --  ctrl_in <= '1';
     --  wait for 10 ns;
     --  ctrl_in <= '0';
     --  wait for 90 ns;
     --end loop;  -- i


     --data_in <= X"27102710";            -- 10000
     data_in <= i2 & i2;            -- 10000
     ctrl_in <= '1';
     wait for 10ns;
     ctrl_in <= '0';
     wait for 90ns;
     data_in <= i2 & i2;            -- 10000
     ctrl_in <= '1';
     wait for 10ns;
     ctrl_in <= '0';
     wait for 90ns;

     --for i in 0 to 5 loop
     --  data_in <= X"00000000";            -- 10000
     --  ctrl_in <= '1';
     --  wait for 10ns;
     --  ctrl_in <= '0';
     --  wait for 90ns;
     --end loop;                          -- i


     ---- data_in <= X"d8efd8ef";            -- -10000
     --data_in <= i2 & i2;            -- 10000
     --ctrl_in <= '1';
     --wait for 10ns;
     --ctrl_in <= '0';
     --wait for 90ns;
     --for i in 0 to 5 loop
     --  data_in <= X"00000000";            -- 10000
     --  ctrl_in <= '1';
     --  wait for 10ns;
     --  ctrl_in <= '0';
     --  wait for 90ns;
     --end loop;                          -- i


     --for i in 0 to 4 loop
     --  data_in <= std_logic_vector(to_signed(2**(i+8), 16)) & std_logic_vector(to_signed(2**(i+8), 16));
     --  ctrl_in <= '1';
     --  wait for 10ns;
     --  ctrl_in <= '0';
     --  wait for 90ns;
     --end loop;                          -- i

     for i in 0 to 100 loop
       data_in <= X"00000000";            -- 10000
       ctrl_in <= '1';
       wait for 10ns;
       ctrl_in <= '0';
       wait for 90ns;
     end loop;                          -- i

     wait;
   end process;

END;
