--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:10:13 10/19/2010
-- Design Name:   
-- Module Name:   /vol/repl311-vol1/public/stud/oberthol/DPR/experiments/audio_reconf_1/resources/dproc/dproc_synccopy/dproc_synccopy_tb.vhd
-- Project Name:  dproc_synccopy
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dproc_synccopy
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
--use ieee.std_logic_arith.all;
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY dproc_synccopy_tb IS
END dproc_synccopy_tb;
 
ARCHITECTURE behavior OF dproc_synccopy_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
  COMPONENT dproc_synccopy
    generic (
      buf_size : unsigned(15 downto 0) := X"0400"    -- buffer size
      );
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

  -- block ram
  type mem_array is array(0 to 1023) of std_logic_vector(31 downto 0);
  signal ram : mem_array;

  -- Clock period definitions
  constant clkin_period : time := 10 ns;
  constant dbram_clk_period : time := 10 ns;
  constant sbram_clk_period : time := 10 ns;

  constant incr : std_logic_vector(31 downto 0) := X"00000001";
  
BEGIN
  
  -- Instantiate the Unit Under Test (UUT)
  uut: dproc_synccopy
    generic map (
      buf_size => X"0800"               -- / 4, 4-byte addressing
    )
    PORT MAP (
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
  
--  -- block ram processes
--  -- infer block RAM
--  wr_p: process(CLK)
--  begin
--    if rising_edge(CLK) then
--      if s_write_Strobe = '1' then
--        ram(to_integer(Address)) <= Data_in;
--      end if;
--    end if;
--  end process wr_p;
--  rd_p: process(CLK)
--  begin
--    if rising_edge(CLK) then
--      rd_addr_ram <= Address;
--    end if;
--  end process rd_p;
--  Data_Out <= ram(to_integer(rd_addr_ram));
  
  -- Stimulus process
  stim_proc: process
  begin		
    -- init memory
    for i in 0 to 1023 loop
      ram(i) <= std_logic_vector(to_unsigned(i, 32));
    end loop;  -- i

    -- init state
    ctrl_in <= X"00000000";
    wait for 20 ns;

    -- testing asynchronous start
    ctrl_in <= X"00000001";
    for i in 1 to 37 loop
      wait for clkin_period;
      -- sbram_din <= std_logic_vector(to_unsigned(i, 32));
      sbram_din <= ram(to_integer(unsigned(sbram_addr))/4);
      -- wait for clkin_period;
    end loop;  -- i

    wait for 80 ns;

    
    for j in 1 to 4 loop
      -- start action
      ctrl_in <= X"00000002";
      for i in 1 to 511 loop
        wait for clkin_period;
        -- sbram_din <= std_logic_vector(to_unsigned(i, 32));
        sbram_din <= ram(to_integer(unsigned(sbram_addr))/4);
        -- wait for clkin_period;
      end loop;  -- i

      wait for 80 ns;
      
      ctrl_in <= X"00000001";
      for i in 1 to 511 loop
        -- sbram_din <= std_logic_vector(to_unsigned(i, 32));
        wait for clkin_period;
        sbram_din <= ram(to_integer(unsigned(sbram_addr))/4);
      end loop;  -- i

      wait for 87 ns;
      
    end loop;  -- j

    
--    sbram_din <= X"00000001";
--    wait for clkin_period;
--    sbram_din <= X"00000002";
--    wait for clkin_period;
--    sbram_din <= X"00000003";
--    wait for clkin_period;
--    sbram_din <= X"00000003";
--    wait for clkin_period;
--    sbram_din <= X"00000004";
--    wait for clkin_period;
--    sbram_din <= X"00000005";
--    wait for clkin_period;
--    sbram_din <= X"00000006";
--    wait for clkin_period;
--    sbram_din <= X"00000007";
--    wait for clkin_period;
--    sbram_din <= X"00000008";
--    wait for clkin_period;
--    sbram_din <= X"00000009";
--    wait for clkin_period;
--    sbram_din <= X"0000000a";
--    wait for clkin_period;
--    sbram_din <= X"0000000b";
--    wait for clkin_period;
--    sbram_din <= X"0000000c";
--    wait for clkin_period;
--    sbram_din <= X"0000000d";
--    wait for clkin_period;
--    sbram_din <= X"0000000e";
--    wait for clkin_period;
--    sbram_din <= X"0000000f";
--    wait for clkin_period;
--    sbram_din <= X"00000010";
--    wait for clkin_period;

--    wait for 35ns;

--    ctrl_in <= X"00000002";
--    -- sbram_din <= X"00000000";

--    sbram_din <= X"00000001";
--    wait for clkin_period;
--    sbram_din <= X"00000002";
--    wait for clkin_period;
--    sbram_din <= X"00000003";
--    wait for clkin_period;
--    sbram_din <= X"00000003";
--    wait for clkin_period;
--    sbram_din <= X"00000004";
--    wait for clkin_period;
--    sbram_din <= X"00000005";
--    wait for clkin_period;
--    sbram_din <= X"00000006";
--    wait for clkin_period;
--    sbram_din <= X"00000007";
--    wait for clkin_period;
--    sbram_din <= X"00000008";
--    wait for clkin_period;
--    sbram_din <= X"00000009";
--    wait for clkin_period;
--    sbram_din <= X"0000000a";
--    wait for clkin_period;
--    sbram_din <= X"0000000b";
--    wait for clkin_period;
--    sbram_din <= X"0000000c";
--    wait for clkin_period;
--    sbram_din <= X"0000000d";
--    wait for clkin_period;
--    sbram_din <= X"0000000e";
--    wait for clkin_period;
--    sbram_din <= X"0000000f";
--    wait for clkin_period;
--    sbram_din <= X"00000010";
--    wait for clkin_period;

--    -- insert stimulus here 

    wait;
  end process;

END;
