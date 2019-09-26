    
library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity adder_gen_struct_bench is
end adder_gen_struct_bench;

architecture adder_gen_struct_bench_arch of adder_gen_struct_bench is

    constant n_c : natural := 4;
    constant b_period_c : natural := 40 * n_c;

    component adder_gen
    generic (
        n_g : natural
    );
    port (
        a_i : in std_logic_vector(n_g - 1 downto 0);
        b_i : in std_logic_vector(n_g - 1 downto 0);
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic_vector(n_g - 1 downto 0)
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

    signal clk0_s : std_logic := '0';
    signal clk1_s : std_logic := '0';
    signal reset0b_s : std_logic := '0';
    signal reset1b_s : std_logic := '0';
    signal a_s : std_logic_vector(n_c - 1 downto 0);
    signal b_s : std_logic_vector(n_c - 1 downto 0);
    signal c_is : std_logic := '0';
    signal c_os : std_logic;
    signal s_s : std_logic_vector(n_c - 1 downto 0);

    begin
        reset0b_s <= '0', '1' after 80 ns;
        reset1b_s <= '0', '1' after 80 ns;
        clk0_s <= not clk0_s after 20 ns;
        clk1_s <= not clk1_s after (2 ** n_c) * (40 ns);

        counter0: counter_gen
        generic map(
            n_g => n_c
        )
        port map(
            clk_i => clk0_s,
            resetb_i => reset0b_s,
            count_o => a_s
            );

        counter1: counter_gen
        generic map(
            n_g => n_c
        )
        port map(
            clk_i => clk1_s,
            resetb_i => reset1b_s,
            count_o => b_s
            );
        
        DUT : adder_gen
        generic map(
            n_g => n_c
        )
        port map(
            a_i => a_s,
            b_i => b_s,
            c_i => c_is,
            c_o => c_os,
            s_o => s_s
            );
            
end adder_gen_struct_bench_arch; -- adder_gen_struct_bench_arch

configuration adder_gen_struct_bench_conf of adder_gen_struct_bench is
    for adder_gen_struct_bench_arch
        for all : counter_gen
            use entity lib_rtl.counter_gen(counter_gen_arch);
        end for;
        for DUT : adder_gen
            use configuration lib_rtl.adder_gen_struct_conf;
        end for;
    end for;
end configuration;