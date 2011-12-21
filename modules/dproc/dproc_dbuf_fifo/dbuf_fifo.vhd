LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dproc_dbuf_fifo is
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
end dproc_dbuf_fifo;

architecture bhv of dproc_dbuf_fifo is

  --signal cntbuf1 : unsigned(to_integer(buf_size-1) downto 0) := (others => '0');
  --signal cntbuf2 : unsigned(to_integer(buf_size-1) downto 0) := (others => '0');
  signal cntbuf1 : unsigned(31 downto 0) := (others => '0');
  signal cntbuf2 : unsigned(31 downto 0) := (others => '0');
  signal c1en : std_logic := '0';
  signal c2en : std_logic := '0';

  signal c1fn : std_logic := '0';
  signal c2fn : std_logic := '0';

  signal addr : unsigned(31 downto 0) := (others => '0');
  signal addr1 : unsigned(31 downto 0) := (others => '0');
  signal addr2 : unsigned(31 downto 0) := (others => '0');

begin  -- bhv

  ctrl1: process (clkin)
  begin  -- process ctrl
    if rising_edge(clkin) then  -- rising clock edge
      if ctrl_in = X"00000001" then
        c1fn <= '1';
        c2fn <= '0';
      elsif ctrl_in = X"00000002" then
        c1fn <= '0';
        c2fn <= '1';
      end if;
    end if;
  end process ctrl1;
  
  buf1: process (clkin)
    
    -- variable addrbuf : unsigned(47 downto 0) := X"000000000000";  -- buffer buf_size*2

  begin  -- process buf1
    if rising_edge(clkin) then
      
      if c1en = '0' and c1fn = '1' then
        cntbuf1 <= X"0000" & buf_size;
        c1en <= '1';
      elsif c2en = '0' and c2fn = '1' then
        cntbuf2 <= X"0000" & buf_size;
        c2en <= '1';
      elsif c1en = '1' then
        if cntbuf1 > 0 then
          cntbuf1 <= cntbuf1 - 4;
          addr <= buf_size - cntbuf1;
        else
          c1en <= '0';
          ctrl_out <= X"00000001";
        end if;
      elsif c2en = '1' then
        if cntbuf2 > 0 then
          cntbuf2 <= cntbuf2 - 4;
          -- addrbuf := 2 * buf_size;
          addr <= buf_size + buf_size - cntbuf2;
        else
          c2en <= '0';
          ctrl_out <= X"00000002";
        end if;
      else
        cntbuf1 <= (others => '0');
        cntbuf2 <= (others => '0');
      end if;
    end if;
  end process buf1;

--    begin  -- process buf1
--    if rising_edge(ctrl_in(0)) and c1en = '0' then
--      cntbuf1 <= X"0000" & buf_size;
--      c1en <= '1';
--    elsif rising_edge(ctrl_in(1)) and c2en = '0' then
--      cntbuf2 <= X"0000" & buf_size;
--      c2en <= '1';
--    elsif rising_edge(clkin) and c1en = '1' then
--      if cntbuf1 > 0 then
--        cntbuf1 <= cntbuf1 - 4;
--        addr <= buf_size - cntbuf1;
--      else
--        c1en <= '0';
--        ctrl_out <= X"00000001";
--      end if;
--    elsif rising_edge(clkin) and c2en = '1' then
--      if cntbuf2 > 0 then
--        cntbuf2 <= cntbuf2 - 4;
--        -- addrbuf := 2 * buf_size;
--        addr <= buf_size + buf_size - cntbuf2;
--      else
--        c2en <= '0';
--        ctrl_out <= X"00000002";
--      end if;
--    end if;
--  end process buf1;

  sbram_clk <= '0';
  sbram_rst <= '0';
  sbram_wre <= (others => '0');
  sbram_en  <= '1';

  dbram_clk <= '0';
  dbram_rst <= '0';
  dbram_wre <= (others => '1');
  dbram_en  <= '1';

  addr1 <= addr;
  debug <= std_logic_vector(addr1);

  sbram_addr <= std_logic_vector(addr);
  dbram_addr <= std_logic_vector(addr1);

  dbram_dout <= sbram_din;
  
end bhv;
