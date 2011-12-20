----------------------------------------------------------------------------------
-- 
-- Create Date: 10:22:55 06/23/2010 
-- Design Name: audio reconf data source wrapper
-- Module Name: dsrc - Behavioral 
-- Project Name: audio reconf 
-- Target Devices: xc5vfx70t
-- Tool versions: ise12
-- Description: data source wrapper pcore for use in EDK
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsrc is
  Port(
    clkin : in  STD_LOGIC;
    ctrl_in : in  STD_LOGIC_VECTOR (31 downto 0);  -- control
                                                   -- inputs from
                                                   -- software, was
                                                   -- reset
    -- GPIO lines
    buf_ctrl : out  STD_LOGIC_VECTOR (31 downto 0);
    debug : out  STD_LOGIC_VECTOR (31 downto 0);
    -- BRAM interface
    dbram_clk : out  STD_LOGIC;
    dbram_rst : out  STD_LOGIC;
    dbram_en : out  STD_LOGIC;
    dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
    -- AC97 CODEC signals
    AC97Reset_n : out std_logic;
    AC97Clk   : in  std_logic;          -- master clock for design
    Sync      : out std_logic;
    SData_Out : out std_logic;
    SData_In  : in  std_logic
  );

end dsrc;

architecture Behavioral of dsrc is
-- wrap actual component to enable its reconfiguration
  component dsrc_act is
--    Generic(
--      dblbufsize : std_logic_vector(15 downto 0) := X"0080" -- size of buffers
--    );
    Port(
      clkin : in  STD_LOGIC;
      rst : in  STD_LOGIC;
      -- misc. GPIO lines
      buf_ctrl : out  STD_LOGIC_VECTOR (31 downto 0);
      debug : out  STD_LOGIC_VECTOR (31 downto 0);
      -- BRAM interface
      dbram_clk : out  STD_LOGIC;
      dbram_rst : out  STD_LOGIC;
      dbram_en : out  STD_LOGIC;
      dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
      dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
      dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
      -- AC97 CODEC signals
      AC97Reset_n : out std_logic;
      AC97Clk   : in  std_logic;          -- master clock for design
      Sync      : out std_logic;
      SData_Out : out std_logic;
      SData_In  : in  std_logic
    );
  end component dsrc_act;

  -- signals / buffering (necessary for reconf?)
--	signal clkin_reg : std_logic;
--	signal rst_reg : std_logic;
  signal dbram_clk_reg : std_logic;
  signal dbram_rst_reg : std_logic;
  signal rst_reg : std_logic;
  
  signal buf_ctrl_reg : std_logic_vector(31 downto 0);
  signal debug_reg : std_logic_vector(31 downto 0);
  signal dbram_en_reg : std_logic;
  signal dbram_wre_reg : std_logic_vector(3 downto 0);
  signal dbram_addr_reg : std_logic_vector(31 downto 0);
  signal dbram_dout_reg : std_logic_vector(31 downto 0);

  signal ac97reset_n_reg : std_logic;
  signal ac97clk_reg   : std_logic;          -- master clock for design
  signal sync_reg      : std_logic;
  signal sdata_out_reg : std_logic;
  signal sdata_in_reg  : std_logic;
  
  
begin
  -- instantiate user logic
  dsrc_instance : dsrc_act
--    generic map(
--      dblbufsize => X"0080"
--      )
    port map(
    -- inputs
      clkin => clkin,
      rst => rst_reg,

    -- outputs
      -- GPIO lines
      debug => debug_reg,
      buf_ctrl => buf_ctrl_reg,
      -- BRAM interface
      dbram_clk => dbram_clk_reg,
      dbram_rst => dbram_rst_reg,
      
      dbram_en => dbram_en_reg,
      dbram_wre => dbram_wre_reg,
      dbram_addr => dbram_addr_reg,
      dbram_dout => dbram_dout_reg,
      
      -- AC97: all unregistered, since they are GCLK pins?
      -- unregistered made trouble with LED/blink earlier on
      AC97Reset_n => ac97reset_n_reg,   -- out
      AC97Clk => AC97Clk,               -- in, clk signal unbuffered
      Sync => sync_reg,                 -- out
      SData_Out => sdata_out_reg,       -- out
      SData_In => sdata_in_reg          -- in
      );
  -- buffer data lines
  reg_proc : process(clkin)
  begin
    if rising_edge(clkin) then
      --	clkin <= clkin_reg;
      --	rst <= rst_reg;
      --        dbram_clk <= dbram_clk_reg;
      -- inputs
      rst_reg <= ctrl_in(0);

      -- outputs
      debug <= debug_reg;
      buf_ctrl <= buf_ctrl_reg;
      
      dbram_en <= dbram_en_reg;
      dbram_wre <= dbram_wre_reg;
      dbram_addr <= dbram_addr_reg;
      dbram_dout <= dbram_dout_reg;

      ac97reset_n <= ac97reset_n_reg;   -- out
      sync <= sync_reg;                 -- out
      sdata_out <= sdata_out_reg;       -- out
      sdata_in_reg <= sdata_in;         -- in
      
    end if;
  end process reg_proc;
  -- ungetaktet
  dbram_clk <= clkin;               -- unbuffered
  dbram_rst <= ctrl_in(0);

end Behavioral;

