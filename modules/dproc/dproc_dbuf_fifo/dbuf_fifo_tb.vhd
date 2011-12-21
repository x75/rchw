-------------------------------------------------------------------------------
-- testbench
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

--use work.counter;

entity dbuf_fifo_tb is
end dbuf_fifo_tb;

architecture bhv of dbuf_fifo_tb is

-- Components
  component dproc_dbuf_fifo
    generic (
      buf_size : unsigned(15 downto 0) := X"0800"    -- buffer size
    );
    Port(
      clkin : in  STD_LOGIC;
      -- GPIO lines
      ctrl_in : in  STD_LOGIC_VECTOR (31 downto 0);  -- control inputs from
                                                     -- software, was reset
      ctrl_out : out  STD_LOGIC_VECTOR (31 downto 0);
      debug : out  STD_LOGIC_VECTOR (31 downto 0);
      -- BRAM interface
      dbram_clk : out  STD_LOGIC;
      dbram_rst : out  STD_LOGIC;
      dbram_en : out  STD_LOGIC;
      dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
      dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
      dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
      -- BRAM interface
      sbram_clk : out  STD_LOGIC;
      sbram_rst : out  STD_LOGIC;
      sbram_en : out  STD_LOGIC;
      sbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
      sbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
      sbram_din : in  STD_LOGIC_VECTOR (31 downto 0)
    );    
  end component;
  
  signal clkin : std_logic := '0';        -- clock
  signal ctrl_in :   std_logic_vector(31 downto 0);
  signal ctrl_out :   std_logic_vector(31 downto 0);
  signal debug :   std_logic_vector(31 downto 0);
  signal sbram_addr : std_logic_vector(31 downto 0);  -- source address
  signal sbram_din :  std_logic_vector(31 downto 0);  -- data in
  signal dbram_addr : std_logic_vector(31 downto 0);  -- destination address
  signal dbram_dout : std_logic_vector(31 downto 0);  -- data out
  signal sbram_en   : std_logic;                      -- source enable
  signal dbram_en   : std_logic;                      -- dest. enable
  signal sbram_wre  : std_logic_vector(3 downto 0);  -- dest. write enable
  signal dbram_wre  : std_logic_vector(3 downto 0);  -- dest. write enable

  constant clk_period : time := 10 ns;   -- clock period

  -- block ram
  type mem_array is array(0 to 511) of std_logic_vector(31 downto 0);
  signal ram : mem_array;

begin -- bhv
  uut : dproc_dbuf_fifo generic map (
    buf_size => X"0400"
  )
  port map (
    clkin       => clkin,
    ctrl_in => ctrl_in,
    ctrl_out => ctrl_out,
    debug => debug,
    sbram_addr => sbram_addr,
    sbram_din => sbram_din,
    dbram_addr => dbram_addr,
    dbram_dout => dbram_dout,
    sbram_en => sbram_en,
    dbram_en => dbram_en,
    dbram_wre => dbram_wre
  );

   -- Clock process definitions
   clk_process: process
   begin
		clkin <= '0';
		wait for clk_period/2;
		clkin <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
     -- init memory
     for i in 0 to 511 loop
       ram(i) <= std_logic_vector(to_unsigned(i, 32));
     end loop;  -- i

     -- hold reset state for 100ms.
     ctrl_in <= X"00000000";
     wait for clk_period*2.3;
     ctrl_in <= X"00000001";
   
     for i in 1 to 256 loop
       wait for clk_period;
       -- sbram_din <= std_logic_vector(to_unsigned(i, 32));
       sbram_din <= ram(to_integer(unsigned(sbram_addr))/4);
       -- wait for clkin_period;
     end loop;  -- i

     wait for 3177 ns;
     ctrl_in <= X"00000002";

     for i in 1 to 256 loop
       wait for clk_period;
       -- sbram_din <= std_logic_vector(to_unsigned(i, 32));
       sbram_din <= ram(to_integer(unsigned(sbram_addr))/4);
       -- wait for clkin_period;
     end loop;  -- i
     
-- insert stimulus here 
		--sigin <= X"0001";
      --wait for clk_period*20;
		--sigin <= X"0002";
      --wait for clk_period*20;
		--sigin <= X"8000";
      --wait for clk_period*20;
		--sigin <= X"FFFF";
      wait;
   end process;

end bhv;

