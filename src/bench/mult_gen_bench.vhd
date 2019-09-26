library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity mult_gen_bench is
end mult_gen_bench;

architecture mult_gen_bench_arch of mult_gen_bench is

    constant n_c : natural := 4;

    component mult_gen
    generic(
        n_g : natural
    );
    port(
        a_i : in std_logic_vector(n_g - 1 downto 0);
        b_i : in std_logic_vector(n_g - 1 downto 0);
        s_o : out std_logic_vector(n_g * n_g - 1 downto 0)
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
    signal a_s : std_logic_vector(n_c - 1 downto 0);
    signal b_s : std_logic_vector(n_c - 1 downto 0);
    signal c_is : std_logic := '0';
    signal c_os : std_logic;
    signal s_s : std_logic_vector(n_c * n_c - 1 downto 0);

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
        
        DUT: mult_gen
        generic map (
            n_g => n_c
        )
        port map(
            a_i => a_s(n_c - 1 downto 0),
            b_i => b_s(n_c - 1 downto 0),
            s_o => s_s
        );

end mult_gen_bench_arch; -- mult_gen_bench_arch

configuration mult_gen_bench_conf of mult_gen_bench is
    for mult_gen_bench_arch
        for all : counter_4
            use entity lib_rtl.counter_4(counter_4_arch);
        end for;
        for DUT : mult_gen
            use configuration lib_rtl.mult_gen_conf;
        end for;
    end for;
end configuration;