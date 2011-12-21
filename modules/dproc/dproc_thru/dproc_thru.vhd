----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:58:32 10/21/2010 
-- Design Name: 
-- Module Name:    dproc_thru - Behavioral 
-- Project Name: 
-- Target Devices: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dproc_thru is
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
end dproc_thru;

architecture Behavioral of dproc_thru is

begin
  ctrl_out <= ctrl_in;
  -- dbram_clk <= sbram_clk;
  -- bullshit


end Behavioral;

