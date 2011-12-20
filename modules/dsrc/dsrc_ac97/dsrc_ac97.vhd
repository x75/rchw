-------------------------------------------------------------------------------
-- Filename:        dsrc_ac97.vhd 
--
-- Description:     AC97 data source reconfigurable module, based on
--                  standalone.vhd by Mike Wirthlin, a Sample circuit for doing
--                  audio standalone
-- 
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--
-------------------------------------------------------------------------------
-- Author:          Oswald Berthold, Mike Wirthlin
-- Revision:        $Revision: 1.1 $
-- Date:            $Date: 2005/02/18 15:30:22 $
--
-- History:
--              - 20101005: re-init after reconfiguration not working yet,
--                          pushed onto later-stack
--              - 20101005: implement double-buffer interface
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity dsrc_ac97 is
  port (
    clkin : in std_logic;
    rst : in std_logic;
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
end dsrc_ac97;

--library opb_ac97_v2_00_a;
--use opb_ac97_v2_00_a.all;
--use opb_ac97_v2_00_a.ac97_if_pkg.all;

architecture imp of dsrc_ac97 is

  signal new_sample : std_logic;
  signal left_channel_0 : std_logic_Vector(15 downto 0) := "0000000000000000";
  signal right_channel_0 : std_logic_Vector(15 downto 0) := "0000000000000000";
  signal left_channel_1 : std_logic_Vector(15 downto 0) := "0000000000000000";
  signal right_channel_1 : std_logic_Vector(15 downto 0) := "0000000000000000";
  signal left_channel_2 : std_logic_Vector(15 downto 0) := "0000000000000000";
  signal right_channel_2 : std_logic_Vector(15 downto 0) := "0000000000000000";
  signal dual_channel_1 : std_logic_Vector(31 downto 0) := X"00000000"; -- "0000000000000000";
  signal leds_i : std_logic_vector(3 downto 0);

  signal clkin_cntr : unsigned(26 downto 0) := (others => '0');
  signal ac97clk_cntr : unsigned(26 downto 0) := (others => '0');

  signal debug_i : std_logic_vector(3 downto 0);
--  signal DEBUG : std_logic_vector(4 downto 0);
  signal reset_i : std_logic;

  signal ac97reset_n_i,sync_i,sdata_out_i : std_logic;

  -- BRAM address
  signal count : unsigned(31 downto 0) := X"00000000";

  -- memwriter double buffer
  -- shared variable dbram_addr_prtl : std_logic_vector(15 downto 0) := X"0000";  -- partial bram data: single channel
  -- shared variable dbram_dout_prtl : std_logic_vector(15 downto 0) := X"0000";  -- partial bram data: single channel
  
  -- components
  -- AC97 interface
  component ac97_if is
  port (
    ClkIn : in std_logic;
    Reset : in std_logic;
    
    -- All signals synchronous to ClkIn
    PCM_Playback_Left: in std_logic_vector(15 downto 0);
    PCM_Playback_Right: in std_logic_vector(15 downto 0);
    PCM_Playback_Accept: out std_logic;
    
    PCM_Record_Left: out std_logic_vector(15 downto 0);
    PCM_Record_Right: out std_logic_vector(15 downto 0);
    PCM_Record_Valid: out std_logic;

    Debug : out std_logic_vector(3 downto 0);
    
    AC97Reset_n : out std_logic;        -- AC97Clk
    
    -- CODEC signals (synchronized to AC97Clk)
    AC97Clk   : in  std_logic;
    Sync      : out std_logic;
    SData_Out : out std_logic;
    SData_In  : in  std_logic

    );
  end component ac97_if;

  -- double buffer bram writer
  component memwr_dbuf
    generic (
      buf_size : unsigned(15 downto 0));
    port (
      clk : in  STD_LOGIC;
      en  : in std_logic;
      data_in  : in  STD_LOGIC_VECTOR (31 downto 0);
      addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
      data_out : out  STD_LOGIC_VECTOR (31 downto 0);
      ctrl_out : out  STD_LOGIC_VECTOR (31 downto 0)
    );
  end component memwr_dbuf;
  
begin  
  ac97_if_I : ac97_if
  port map (
      ClkIn => clkin,
      Reset => reset_i,
    
      PCM_Playback_Left => left_channel_2,
      PCM_Playback_Right => right_channel_2,
      PCM_Playback_Accept => new_sample,

      PCM_Record_Left => left_channel_0,
      PCM_Record_Right => right_channel_0,
      PCM_Record_Valid => open,

      Debug => debug_i,
      
      AC97Reset_n => ac97reset_n_i,
      AC97Clk => AC97Clk,
      Sync => sync_i,
      SData_Out => sdata_out_i,
      SData_In => SData_in
    );

  memwr_dbuf_i1 : memwr_dbuf
    generic map (
      buf_size => X"0800"               -- / 4, 4-byte addressing
    )
    port map (
      clk      => clkin,
      en       => new_sample,
      data_in  => dual_channel_1,
      addr_out => dbram_addr,
      data_out => dbram_dout,
      ctrl_out => buf_ctrl
    );
  
  delay_PROCESS : process (clkin) is
  begin
    if clkin'event and clkin='1' and new_sample = '1' then
      left_channel_1 <= left_channel_0;
      right_channel_1 <= right_channel_0;

      dual_channel_1 <= right_channel_0 & left_channel_0;

      left_channel_2 <= left_channel_1;
      right_channel_2 <= right_channel_1;

      -- BRAM output additions
      count <= count + 1;
      -- debug <= X"00000003";
      -- buf_ctrl <= X"00000004";
      -- dbram_addr <= std_logic_vector(count);
      -- dbram_dout <= left_channel_2 & right_channel_2;
      -- dbram_dout <= left_channel_2 & count(15 downto 0);

    end if;
  end process;

  debug <= X"0000000" & "001" & new_sample;

  -- always enable
  dbram_en <= '1';
  dbram_wre <= "1111";

  -- ungetaktet
  -- reset_i <= not rst;
  reset_i <= rst;

  -- LED <= not debug_i;
  
  AC97Reset_n <= ac97reset_n_i;
  Sync <= sync_i;
  SData_Out <= sdata_out_i;
  
  dbram_clk <= clkin;
  dbram_rst <= rst;

  -- unused
--  DEBUG(0) <= AC97Clk;
--  DEBUG(1) <= AC97Reset_n_i;
--  DEBUG(2) <= Sync_i;
--  DEBUG(3) <= SData_Out_i;
--  DEBUG(4) <= SData_In;

end architecture imp;
