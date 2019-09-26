    
library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity adder_4_bench is
end adder_4_bench;

architecture adder_4_bench_arch of adder_4_bench is

    component adder_4
    port(
        a_i : in std_logic_vector(3 downto 0);
        b_i : in std_logic_vector(3 downto 0);
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic_vector(3 downto 0)
    );
    end component;

    component counter_4
    port ( 
        clk_i: in std_logic;
        resetb_i: in std_logic;
        count_o: out std_logic_vector(3 downto 0)
     );

    end component;

    signal clk0_s : std_logic := '0';
    signal clk1_s : std_logic := '0';
    signal reset0b_s : std_logic := '0';
    signal reset1b_s : std_logic := '0';
    signal a_s : std_logic_vector(3 downto 0);
    signal b_s : std_logic_vector(3 downto 0);
    signal c_is : std_logic := '0';
    signal c_os : std_logic;
    signal s_s : std_logic_vector(3 downto 0);

    begin

        reset0b_s <= '0', '1' after 80 ns;
        reset1b_s <= '0', '1' after 80 ns;

        clk0_s <= not clk0_s after 20 ns;
        clk1_s <= not clk1_s after 640 ns; -- 640 = 2^4 * 40ns

        counter0: counter_4
        port map(
            clk_i => clk0_s,
            resetb_i => reset0b_s,
            count_o => a_s
        );

        counter1: counter_4
        port map(
            clk_i => clk1_s,
            resetb_i => reset1b_s,
            count_o => b_s
        );
        
        DUT: adder_4
        port map(
            a_i => a_s(3 downto 0),
            b_i => b_s(3 downto 0),
            c_i => c_is,
            c_o => c_os,
            s_o => s_s
        );

end adder_4_bench_arch; -- adder_4_bench_arch

configuration adder_4_bench_conf of adder_4_bench is
    for adder_4_bench_arch
        for all : counter_4
            use entity lib_rtl.counter_4(counter_4_arch);
        end for;
        for DUT : adder_4
            use configuration lib_rtl.adder_4_conf;
        end for;
    end for;
end configuration;