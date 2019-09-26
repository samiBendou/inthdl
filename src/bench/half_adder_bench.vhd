library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity half_adder_bench is
end half_adder_bench;

architecture half_adder_bench_arch of half_adder_bench is

    component half_adder
    port(
        a_i : in std_logic;
        b_i : in std_logic;
        cb_o : out std_logic;
        s_o : out std_logic
    );
    end component;

    signal a_s : std_logic := '0';
    signal b_s : std_logic := '1';
    signal cb_s : std_logic;
    signal s_s : std_logic;

    begin
        
        DUT : half_adder
        port map(
            a_i => a_s,
            b_i => b_s,
            s_o => s_s,
            cb_o => cb_s
            );
            
        a_s <= not a_s after 27 ns;
        b_s <= not b_s after 19 ns;
            
end half_adder_bench_arch; -- half_adder_bench_arch

configuration half_adder_bench_conf of half_adder_bench is
    for half_adder_bench_arch -- référence aux architectures
        for DUT : half_adder -- référence aux instances
            use entity lib_rtl.half_adder(half_adder_arch);
        end for;
    end for;
end configuration;