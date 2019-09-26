library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity full_adder_bench is
end full_adder_bench;

architecture full_adder_bench_arch of full_adder_bench is

    component full_adder
    port(
        a_i : in std_logic;
        b_i : in std_logic;
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic
    );
    end component;

    signal a_s : std_logic := '0';
    signal b_s : std_logic := '1';
    signal c_is : std_logic := '0';
    signal c_os : std_logic;
    signal s_s : std_logic;

    begin
        
        DUT : full_adder
        port map(
            a_i => a_s,
            b_i => b_s,
            c_i => c_is,
            c_o => c_os,
            s_o => s_s
            );
            
        a_s <= not a_s after 27 ns;
        b_s <= not b_s after 19 ns;
        c_is <= not c_is after 11 ns;
            
end full_adder_bench_arch; -- full_adder_bench_arch

configuration full_adder_bench_conf of full_adder_bench is
    for full_adder_bench_arch
        for DUT : full_adder
            use configuration lib_rtl.full_adder_conf;
        end for;
    end for;
end configuration;