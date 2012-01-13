-------------------------------------------------------------------------------
-- Title      : bitwise delay
-- Project    : 
-------------------------------------------------------------------------------
-- File       : bitwise_delay_2.vhd
-- Author     : Oswald Berthold  <opt@sdfk.de>
-- Company    : 
-- Created    : 2011-11-23
-- Last update: 2011-12-21
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: delay a string of bits by specified amount of bits
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-11-23  1.0      x75	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity bitwise_delay_2 is
  
  generic (
    width : integer := 128;
    delay : integer := 15);

  Port (
    clk : in  STD_LOGIC;
    i_en : in  STD_LOGIC;
    i_ctrl : in  STD_LOGIC_VECTOR (width-1 downto 0);
    i_osz : in  STD_LOGIC;
    o_osz : out  STD_LOGIC;
    o_freq : out  STD_LOGIC_VECTOR (width-1 downto 0)
    );

end bitwise_delay_2;

architecture bhv of bitwise_delay_2 is

  signal mybuf : std_logic_vector(delay downto 0);

  attribute S : string;
  attribute S of clk:  signal is "true";
  attribute S of i_en:   signal is "true";
  attribute S of i_ctrl: signal is "true";
  attribute S of i_osz:  signal is "true";
  attribute S of o_osz:  signal is "true";
  attribute S of o_freq: signal is "true";
  
    
begin  -- bhv

  process(clk)
  begin
    if rising_edge(clk) then
      o_freq(delay downto 0) <= mybuf;
      o_freq(width-1 downto delay) <= i_ctrl((width-delay)-1 downto 0);
      mybuf <= i_ctrl(width-1 downto (width-delay)-1);
    end if;
  end process;

  o_osz <= '0';
  
end bhv;

