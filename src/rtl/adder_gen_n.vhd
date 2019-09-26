library lib_rtl;
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use lib_rtl.all;


-- array adder
entity adder_gen_n is
    generic (
        nb_g : natural := 4; -- number of bits
        no_g : natural := 2 -- number of operands
    );
    port (
        e_i : in std_logic_vector(nb_g * no_g - 1 downto 0);
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic_vector(nb_g - 1 downto 0)
    );
end adder_gen_n;

architecture adder_gen_n_arch of adder_gen_n is
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

    -- partial sum of e_i
    signal partial_s : std_logic_vector(nb_g * (no_g - 1) - 1 downto 0);
begin

    s_o <= partial_s(nb_g * (no_g - 1) - 1 downto (nb_g) * (no_g - 2));

    adder_g : for k in 0 to no_g - 2 generate
        adder_0: if k = 0 generate
            adder_e: adder_gen
            generic map (
                n_g => nb_g
            )
            port map (
                a_i => e_i(nb_g - 1 downto 0),
                b_i => e_i(2 * nb_g - 1 downto nb_g),
                c_i => c_i,
                s_o => partial_s(nb_g - 1 downto 0)
            );
        end generate ; -- adder_0
        adder_k: if k > 0 generate
            adder_s: adder_gen
            generic map (
                n_g => nb_g
            )
            port map (
                a_i => e_i(nb_g * (k + 2) - 1 downto nb_g * (k + 1)),
                b_i => partial_s(nb_g * k - 1 downto nb_g * (k - 1)),
                c_i => c_i,
                s_o => partial_s(nb_g * (k + 1) - 1 downto nb_g * k)
            );
        end generate ; -- adder_k
    
    end generate ; -- adders

end adder_gen_n_arch ; -- adder_gen_n_arch


configuration adder_gen_n_conf of adder_gen_n is
    for adder_gen_n_arch
        for adder_g
            for adder_0
                for all : adder_gen
                    use configuration lib_rtl.adder_gen_behav_conf;
                end for;
            end for;
            for adder_k
            for all : adder_gen
                use configuration lib_rtl.adder_gen_behav_conf;
            end for;
        end for;
        end for;
    end for;
end configuration; -- adder_gen_n_conf