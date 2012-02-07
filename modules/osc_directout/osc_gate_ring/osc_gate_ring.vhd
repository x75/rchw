-- ring oscillator with ring of inverter gates (1-LUT)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity osc_gate_ring is
    Port ( clk : in  STD_LOGIC;
           i_en : in  STD_LOGIC;
           o_osz : out  STD_LOGIC;
           o_osz_drct : out STD_LOGIC;
           o_trig_rcnf : out STD_LOGIC);
end osc_gate_ring;


architecture Behavioral of osc_gate_ring is
  signal delayline_input : std_logic;
  signal delayline_output : std_logic;
  signal triggered : std_logic := '0';  -- triggered?
  
  component delayline
    generic (
      linelength : integer);
    port (
      sgnl         : in  std_logic;
      delayed_sgnl : out std_logic);
  end component;

  attribute S : string;
  attribute S of i_en: signal is "true";
  attribute S of o_osz: signal is "true";

begin
  delayline_inst : delayline
    generic map (
      linelength => 4)
    port map (
      sgnl         => delayline_input,
      delayed_sgnl => delayline_output);

  --process (clk)
  --begin
  --  --wait until clk'event and clk = '1';
  --  if clk'event and clk = '1' then
  --    if triggered = '0' then
  --      o_trig_rcnf <= '1';
  --      triggered <= '1';               -- disable retrigger forever
  --    else
  --      o_trig_rcnf <= '0';
  --    end if;
  --  end if;
  --  -- clock B tick whenever d(24) is zero
  --end process;
  o_trig_rcnf <= '0';
  
  delayline_input <= delayline_output and i_en;
  --delayline_output <= delayed_sgnl;
  o_osz <= delayline_output;

  OBUF_inst1 : OBUF
    generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
    port map (
      O => o_osz_drct,     -- Buffer output (connect directly to top-level port)
      I => delayline_output      -- Buffer input 
      );
  
end Behavioral;
