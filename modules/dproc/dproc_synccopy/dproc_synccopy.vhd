----------------------------------------------------------------------------------
-- Company: 
-- Engineer: oswald berthold
-- 
-- Create Date:    14:55:39 06/22/2010 
-- Design Name:    data source: counter
-- Module Name:    dproc_synccopy - Behavioral 
-- Project Name:   audio_reconf
-- Target Devices: ml507 / xc5v70fxt-1-1xxx
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
-- use IEEE.STD_LOGIC_arith.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_synccopy is
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
end dproc_synccopy;

architecture Behavioral of dproc_synccopy is
--  signal count : unsigned(31 downto 0) := X"00000000";
  signal addr_src : unsigned(31 downto 0) := X"00000000";
  signal addr_dst : unsigned(31 downto 0) := X"00000000";
  signal state : std_logic_vector(2 downto 0) := "000";
--  signal d1 : unsigned(31 downto 0) := X"00000000";  -- data vector 1
  signal stream_pre : std_logic_vector(31 downto 0) := X"00000000";  -- THE signal
  signal stream_post : std_logic_vector(31 downto 0) := X"00000000";  -- THE OTHER
                                                                  -- signal
  signal enable_pre : std_logic := '0';     -- enable processing, new data available
  signal enable_post : std_logic := '0';     -- enable processing, new data available

--  constant buf_size : unsigned(15 downto 0) := X"0800";  -- buffer size

  -- delay component
  component proc_delay
    port (
      clk  : in  std_logic;                       -- clock
      eni  : in  std_logic;                       -- enable in
      din  : in  std_logic_vector(31 downto 0);   -- data in
      eno  : out std_logic;                       -- enable out
      dout : out std_logic_vector(31 downto 0));  -- data out
  end component;
  
begin
  -- component instantiation
  p01 : proc_delay
    port map (
      clk  => clkin,
      eni  => enable_pre,
      din  => stream_pre,
      eno  => enable_post,
      dout => stream_post
    );
  
  process(clkin)
  begin
--    if rst = '1' then
--      count <= X"00000000";
--      debug <= X"00000003";
--      buf_ctrl <= X"00000004";
--      -- setup bram
--      dbram_en <= '0';
--      dbram_wre <= "0000";
--      dbram_addr <= (others => '0');
--      dbram_dout <= (others => '0');
--    elsif rising_edge(clkin) then

    -- set aggregate state
    -- state <= state and (ctrl_in(0) & "11");
    
    if rising_edge(clkin) then

      -- read from source + serialize
      case state is
--        when "100" =>
--          null;                         -- nyscht
        when "000" =>                   -- initial state, max visit 1
          if(ctrl_in = X"00000001") then
            addr_src <= (others => '0'); -- reset addr
            state <= "001";
            enable_pre <= '0';
          elsif(ctrl_in = X"00000002") then
            addr_src <= X"0000" & buf_size;       -- reset addr
            state <= "001";
            enable_pre <= '0';
          end if;
        when "001" =>
          addr_src <= addr_src + 4;
          enable_pre <= '1';
          -- if ctrl_in = X"00000001" then
          if addr_src = (buf_size - 8) then
            state <= "010";
          -- end if;
          -- elsif ctrl_in = X"00000002" then
          elsif addr_src >= (2 * buf_size - 8) then
            state <= "011";
          end if;
          -- end if;
        when "010" =>
          if ctrl_in = X"00000002" then
            addr_src <= X"0000" & buf_size;        -- reset addr
            state <= "001";
            enable_pre <= '1';
          else
            enable_pre <= '0';
          end if;
        when "011" =>
          if ctrl_in = X"00000001" then
            addr_src <= (others => '0');  -- reset addr
            state <= "001";
            enable_pre <= '1';
          else
            enable_pre <= '0';
          end if;
        when others => null;
      end case;

      -- -- local 1-cycle delay
      -- stream_post <= stream_pre;
      -- enable_post <= enable_pre;      
      
      -- do processing + write to destination
      if enable_post = '1' then
      -- if enable_pre = '1' then
        dbram_dout <= stream_post;
        -- dbram_dout <= stream_pre;
        addr_dst <= addr_dst + 4;

        if addr_dst = (buf_size - 4) then
          -- ctrl_out <= X"00000001";
          -- stream_pre <= X"00000002";
        elsif addr_dst >= (2 * buf_size - 4) then
          -- ctrl_out <= X"00000002";
          -- stream_pre <= X"00000001";
          addr_dst <= (others => '0');
        end if;

      end if;

      if addr_dst = (buf_size - 4) then
        ctrl_out <= X"00000001";
        -- set write enable 0?
      elsif addr_dst = (2 * buf_size - 4) then
        ctrl_out <= X"00000002";
        -- set write enable 0?
      end if;

      debug <= std_logic_vector(addr_src);

--      -- check state
--      if count(7) = '1' then
--        ctrl_out <= X"00000002";
--      else
--        ctrl_out <= X"00000001";
--      end if;
    end if;
  end process;
  -- ungetaktet
  dbram_clk <= clkin;
  dbram_rst <= '0'; -- rst;
  sbram_clk <= clkin;
  sbram_rst <= '0'; -- rst;

  dbram_en <= '1';
  dbram_wre <= "1111";

  sbram_en <= '1';
  sbram_wre <= "0000";

  stream_pre <= sbram_din;

  sbram_addr <= std_logic_vector(addr_src);
  dbram_addr <= std_logic_vector(addr_dst);

  
end Behavioral;

