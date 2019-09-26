library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity half_adder is
  port (
    a_i : in std_logic;
    b_i : in std_logic;
    cb_o : out std_logic;
    s_o : out std_logic
  ) ;
end half_adder;

architecture half_adder_arch of half_adder is

  begin
    cb_o <= a_i nand b_i;
    s_o <= a_i xor b_i;

end half_adder_arch; -- half_adder_arch