library IEEE;
library lib_rtl;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use lib_rtl.all;

entity full_adder is
  port (
    a_i : in std_logic;
    b_i : in std_logic;
    c_i : in std_logic;
    c_o : out std_logic;
    s_o : out std_logic
  ) ;
end full_adder;

architecture full_adder_arch of full_adder is
    signal s0_s : std_logic;
    signal cb0_s : std_logic;
    signal cb1_s : std_logic;

    component half_adder
    port (
        a_i : in std_logic;
        b_i : in std_logic;
        cb_o : out std_logic;
        s_o : out std_logic
    );
    end component;

begin

    half0: half_adder
    port map(
        a_i => a_i,
        b_i => b_i,
        cb_o => cb0_s,
        s_o => s0_s
    );

    half1: half_adder
    port map(
        a_i => s0_s,
        b_i => c_i,
        cb_o => cb1_s,
        s_o => s_o
    );

    c_o <= cb0_s nand cb1_s;

end full_adder_arch; -- full_adder_arch

configuration full_adder_conf of full_adder is
    for full_adder_arch
        for all : half_adder
            use entity lib_rtl.half_adder(half_adder_arch);
        end for;
    end for;
end configuration; -- full_adder_conf