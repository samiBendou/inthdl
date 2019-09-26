    
library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity adder_gen_n_bench is
end adder_gen_n_bench;

architecture adder_gen_n_bench_arch of adder_gen_n_bench is

    constant nb_c : natural := 4;
    constant no_c : natural := 3;

    component adder_gen_n
    generic (
        nb_g : natural;
        no_g : natural
    );
    port (
        e_i : in std_logic_vector(nb_g * no_g - 1 downto 0);
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic_vector(nb_g - 1 downto 0)
    );
    end component;

    
    component counter_gen
    generic (
        n_g : natural
    );
    port ( 
        clk_i: in std_logic;
        resetb_i: in std_logic;
        count_o: out std_logic_vector(n_g - 1 downto 0)
        );
    end component;


    signal clk_s : std_logic_vector(no_c - 1 downto 0) := (others => '0');
    signal resetb_s : std_logic_vector(no_c - 1 downto 0) := (others => '0');
    signal e_s : std_logic_vector(no_c * nb_c - 1 downto 0);
    signal c_is : std_logic := '0';
    signal c_os : std_logic;
    signal s_s : std_logic_vector(nb_c - 1 downto 0);

    begin
        resetb_s <= (others => '1') after 80 ns;
        clk_s(0) <= not clk_s(0) after 20 ns;
        clk_s(1) <= not clk_s(1) after (2 ** nb_c) * (40 ns);
        clk_s(2) <= not clk_s(2) after (2 ** (2 * nb_c)) * (40 ns);

        counter0: counter_gen
        generic map(
            n_g => nb_c
        )
        port map(
            clk_i => clk_s(0),
            resetb_i => resetb_s(0),
            count_o => e_s(nb_c - 1 downto 0)
            );

        counter1: counter_gen
        generic map(
            n_g => nb_c
        )
        port map(
            clk_i => clk_s(1),
            resetb_i => resetb_s(1),
            count_o => e_s(2 * nb_c - 1 downto nb_c)
            );

        counter2: counter_gen
        generic map(
            n_g => nb_c
        )
        port map(
            clk_i => clk_s(2),
            resetb_i => resetb_s(2),
            count_o => e_s(3 * nb_c - 1 downto 2 * nb_c)
            );
        
        DUT : adder_gen_n
        generic map(
            nb_g => nb_c,
            no_g => no_c
        )
        port map(
            e_i => e_s,
            c_i => c_is,
            c_o => c_os,
            s_o => s_s
            );
            
end adder_gen_n_bench_arch; -- adder_gen_n_bench_arch

configuration adder_gen_n_bench_conf of adder_gen_n_bench is
    for adder_gen_n_bench_arch
        for all : counter_gen
            use entity lib_rtl.counter_gen(counter_gen_arch);
        end for;
        for DUT : adder_gen_n
            use configuration lib_rtl.adder_gen_n_conf;
        end for;
    end for;
end configuration;