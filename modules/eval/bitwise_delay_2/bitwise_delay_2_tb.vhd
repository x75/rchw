LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity bitwise_delay_2_tb is
  generic (
    width : integer := 4;
    delay : integer := 2
  );
end bitwise_delay_2_tb;


architecture a of bitwise_delay_2_tb is

  
  component bitwise_delay_2
    generic (
      width : integer;
      delay : integer);

    Port ( clk : in  STD_LOGIC;
           i_en : in  STD_LOGIC;
           i_ctrl : in  STD_LOGIC_VECTOR (width-1 downto 0);
           i_osz : in  STD_LOGIC;
           o_osz : out  STD_LOGIC;
           o_freq : out  STD_LOGIC_VECTOR (width-1 downto 0));
  end component;

  --Inputs
  signal i_en : std_logic := '0';       -- enable
  signal i_ctrl : std_logic_vector(width-1 downto 0) := (others => '0');
  signal i_osz : std_logic := '0';       -- oscillator signal

 	--Outputs
  signal o_osz : std_logic := '0';      -- oscillator output signal
  signal o_freq : std_logic_vector(width-1 downto 0) := (others => '0');

  signal clk : std_logic;
  constant clk_period : time := 10 ns;

begin  -- a

uut : bitwise_delay_2
  generic map (
    width => width,
    delay => delay)
  port map (
    clk    => clk,
    i_en   => i_en,
    i_ctrl => i_ctrl,
    i_osz  => i_osz,
    o_osz  => o_osz,
    o_freq => o_freq);

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

      --wait for clk_period*10;

      i_en <= '1';
      --i_ctrl <= unsigned(1, width);
      i_ctrl <= "00000001";
      wait for clk_period;
      i_ctrl <= "00000101";
      wait for clk_period;
      i_ctrl <= "00001101";
      wait for clk_period;
      i_ctrl <= "00001001";
      
      -- insert stimulus here 
      wait;
   end process;


end a;
