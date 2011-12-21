----------------------------------------------------------------------------------
-- 
-- Create Date: 10:22:55 06/23/2010 
-- Design Name: audio reconf data processing wrapper
-- Module Name: dproc_wrapper - Behavioral 
-- Project Name: audio reconf 
-- Target Devices: xc5vfx70t
-- Tool versions: ise12.1
-- Description: data processing wrapper pcore for use in PR EDK project
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

entity dproc_wrapper is
  Port(
    clkin : in  STD_LOGIC;
    -- GPIO lines
    ctrl_in : in  STD_LOGIC_VECTOR (31 downto 0);  -- control
                                                   -- inputs from
                                                   -- software, was
                                                   -- reset
    ctrl_out : out  STD_LOGIC_VECTOR (31 downto 0);
    debug : out  STD_LOGIC_VECTOR (31 downto 0);
    -- BRAM interface 1: destination
    dbram_clk : out  STD_LOGIC;
    dbram_rst : out  STD_LOGIC;
    dbram_en : out  STD_LOGIC;
    dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
    -- BRAM interface 2: source
    sbram_clk : out  STD_LOGIC;
    sbram_rst : out  STD_LOGIC;
    sbram_en : out  STD_LOGIC;
    sbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
    sbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
    sbram_din : in  STD_LOGIC_VECTOR (31 downto 0)
  );

end dproc_wrapper;

architecture Behavioral of dproc_wrapper is
-- wrap actual component to enable its reconfiguration
  component dproc_act is
    Port(
      clkin : in  STD_LOGIC;
      -- misc. GPIO lines
      ctrl_in : in  STD_LOGIC_VECTOR (31 downto 0);
      ctrl_out : out  STD_LOGIC_VECTOR (31 downto 0);
      debug : out  STD_LOGIC_VECTOR (31 downto 0);
      -- BRAM interface 1
      dbram_clk : out  STD_LOGIC;
      dbram_rst : out  STD_LOGIC;
      dbram_en : out  STD_LOGIC;
      dbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
      dbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
      dbram_dout : out  STD_LOGIC_VECTOR (31 downto 0);
      -- BRAM interface 2
      sbram_clk : out  STD_LOGIC;
      sbram_rst : out  STD_LOGIC;
      sbram_en : out  STD_LOGIC;
      sbram_wre : out  STD_LOGIC_VECTOR (3 downto 0);
      sbram_addr : out  STD_LOGIC_VECTOR (31 downto 0);
      sbram_din : in  STD_LOGIC_VECTOR (31 downto 0)
    );
  end component dproc_act;

  -- signals / buffering (necessary for reconf?)
--	signal clkin_reg : std_logic;
--	signal rst_reg : std_logic;
  signal dbram_clk_reg : std_logic;
  signal dbram_rst_reg : std_logic;
  
  signal ctrl_in_reg : std_logic_vector(31 downto 0);
  signal ctrl_out_reg : std_logic_vector(31 downto 0);
  signal debug_reg : std_logic_vector(31 downto 0);

  signal dbram_en_reg : std_logic;
  signal dbram_wre_reg : std_logic_vector(3 downto 0);
  signal dbram_addr_reg : std_logic_vector(31 downto 0);
  signal dbram_dout_reg : std_logic_vector(31 downto 0);

  signal sbram_clk_reg : std_logic;
  signal sbram_rst_reg : std_logic;
  signal sbram_en_reg : std_logic;
  signal sbram_wre_reg : std_logic_vector(3 downto 0);
  signal sbram_addr_reg : std_logic_vector(31 downto 0);
  signal sbram_din_reg : std_logic_vector(31 downto 0);

begin
  -- instantiate user logic
  dproc_instance : dproc_act

  port map(
    -- inputs
    clkin => clkin,

    -- outputs
    -- GPIO lines
    ctrl_in => ctrl_in_reg,
    ctrl_out => ctrl_out_reg,
    debug => debug_reg,

    -- BRAM interface output
    dbram_clk => dbram_clk_reg,
    dbram_rst => dbram_rst_reg,
    
    dbram_en => dbram_en_reg,
    dbram_wre => dbram_wre_reg,
    dbram_addr => dbram_addr_reg,
    dbram_dout => dbram_dout_reg,
    
    -- BRAM interface input
    sbram_clk => sbram_clk_reg,
    sbram_rst => sbram_rst_reg,
      
    sbram_en => sbram_en_reg,
    sbram_wre => sbram_wre_reg,
    sbram_addr => sbram_addr_reg,
    sbram_din => sbram_din_reg
    
    );
  
  -- buffer data lines
  reg_proc : process(clkin)
  begin
    if rising_edge(clkin) then
      -- ctrl_in_reg <= ctrl_in(0);
      ctrl_in_reg <= ctrl_in;

      -- outputs
      ctrl_out <= ctrl_out_reg;
      debug <= debug_reg;
      
      dbram_en <= dbram_en_reg;
      dbram_wre <= dbram_wre_reg;
      dbram_addr <= dbram_addr_reg;
      dbram_dout <= dbram_dout_reg;

      sbram_en <= sbram_en_reg;
      sbram_wre <= sbram_wre_reg;
      sbram_addr <= sbram_addr_reg;
      sbram_din_reg <= sbram_din;

    end if;
  end process reg_proc;
  -- ungetaktet
  dbram_clk <= clkin;               -- unbuffered
  dbram_rst <= ctrl_in(0);

  sbram_clk <= clkin;               -- unbuffered
  sbram_rst <= ctrl_in(0);

end Behavioral;

