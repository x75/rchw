----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:09 11/15/2010 
-- Design Name: 
-- Module Name:    fir_gen - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_gen is
  generic(
    W1 : Integer := 9;                  -- input bit width
    W2 : Integer := 18;                 -- Multiplier bit width
    W3 : Integer := 19;                 -- Adder bit width = W2 +log2(L)-1
    W4 : Integer := 11;                 -- output bit width
    L : Integer := 4;                   -- filter length
    Mpipe : Integer := 3                -- Pipeline steps of multiplier
  );
  Port (
    clk : in  STD_LOGIC;
    --clk_audio : in STD_LOGIC;
    Load_x : in  STD_LOGIC;
    x_in : in  STD_LOGIC_VECTOR (W1-1 downto 0);
    c_in : in  STD_LOGIC_VECTOR (W1-1 downto 0);
    y_out : out  STD_LOGIC_VECTOR (W4-1 downto 0)
  );
end fir_gen;

architecture flex of fir_gen is
  subtype N1BIT is std_logic_vector(W1-1 downto 0);
  subtype N2BIT is std_logic_vector(W2-1 downto 0);
  subtype N3BIT is std_logic_vector(W3-1 downto 0);

  type ARRAY_N1BIT is array (0 to L-1) of N1BIT;
  type ARRAY_N2BIT is array (0 to L-1) of N2BIT;
  type ARRAY_N3BIT is array (0 to L-1) of N3BIT;

  signal x : N1BIT;
  signal y : N3BIT;
  signal c : ARRAY_N1BIT;               -- coefficient array
  signal p : ARRAY_N2BIT;               -- product array
  signal a : ARRAY_N3BIT;               -- adder array

  -- constant cc : ARRAY_N1BIT := (X"007C", X"00D6", X"0039", X"FFDE");
  -- constant cc : ARRAY_N1BIT := (X"3dd3", X"6b12", X"1caf", X"ef6e");
  constant cc : ARRAY_N1BIT := (others => X"0800"); -- (X"1000", X"1000", X"1000", X"1000");

  --for i in 0 to L-1 loop
  --  cc(i) <= std_logic_vector(to_signed(2048, W1));
  --end loop;
  
  component my_mult
    generic (
      my_widtha         : integer := 9;
      my_widthb         : integer := 9;
      my_pipeline       : integer := 3;
      my_representation : string  := "SIGNED";
      my_widthp         : integer := 18;
      my_widths         : integer := 18
      );
    Port (
      clock : in  STD_LOGIC;
      dataa : in  STD_LOGIC_VECTOR (my_widtha-1 downto 0);
      datab : in  STD_LOGIC_VECTOR (my_widthb-1 downto 0);
      result : out  STD_LOGIC_VECTOR (my_widthp-1 downto 0)
      );
  end component;
  
begin

  ---- load data or coefficient
  --Load: process
  --begin
  --  wait until clk = '1';
  --  if (Load_x = '0') then
  --    c(L-1) <= c_in;                   -- store coeff in register
  --    for I in L-2 downto 0 loop
  --      c(I) <= c(I+1);
  --    end loop;  -- I
  --  else
  --    x <= x_in;
  --  end if;
  --end process Load;

  SOP: process(clk, x_in, a)                     -- compute sum of products
  begin
    if rising_edge(clk) then
      for I in 0 to L-2 loop
        a(I) <= (p(I)(W2-1) & p(I)) + a(I+1);                     -- filter adds
      end loop;  -- I
      a(L-1) <= p(L-1)(W2-1) & p(L-1);
    end if;
    x <= x_in;                        -- assign input
    y <= a(0);
  end process SOP;

  -- instantiate L pipelined multiplier
  MulGen: for I in 0 to L-1 generate
    Muls: my_mult                     -- Multiply p(i) = c(i) * x
      generic map (
        my_widtha         => W1,
        my_widthb         => W1,
        my_pipeline       => Mpipe,
        my_representation => "SIGNED",
        my_widthp         => W2,
        my_widths         => W2
      )
      port map (
        clock  => clk,
        dataa  => x,
        datab  => cc(I),
        result => p(I)
      );
  end generate MulGen;

  y_out <= y(W3-1 downto W3-W4);

end flex;

