library lib_rtl;
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use lib_rtl.all;

entity adder_gen is
    generic (
        n_g : natural := 4 -- number of bits
    );
    port (
        a_i : in std_logic_vector(n_g - 1 downto 0);
        b_i : in std_logic_vector(n_g - 1 downto 0);
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic_vector(n_g - 1 downto 0)
    );
end adder_gen;

-- structural architecture of the generic adder
architecture adder_gen_struct_arch of adder_gen is
    component full_adder
    port (
        a_i : in std_logic;
        b_i : in std_logic;
        c_i : in std_logic;
        c_o : out std_logic;
        s_o : out std_logic
      );
    end component;

    -- carry propagation signal
    signal c_s : std_logic_vector(n_g downto 0);

begin

    c_s(0) <= c_i;
    c_o <= c_s(n_g); 

    adder_g : for k in 0 to n_g-1 generate
        adder_k: full_adder
        port map(
            a_i => a_i(k),
            b_i => b_i(k),
            c_i => c_s(k),
            c_o => c_s(k + 1),
            s_o => s_o(k)
        );
    end generate; -- adder_g

end adder_gen_struct_arch ; -- adder_gen_struct_arch

-- behavioral architecture of the generic adder
architecture adder_gen_behav_arch of adder_gen is
    begin
    -- TODO : implement a carry in/out logic
    s_o <= std_logic_vector(unsigned(a_i) + unsigned(b_i));
    c_o <= '-';
end adder_gen_behav_arch ; -- adder_gen_behav_arch

configuration adder_gen_struct_conf of adder_gen is
    for adder_gen_struct_arch
        for adder_g
            for all : full_adder
                use configuration lib_rtl.full_adder_conf;
            end for;
        end for;
    end for;
end configuration; -- adder_gen_struct_conf

configuration adder_gen_behav_conf of adder_gen is
    for adder_gen_behav_arch
    end for;
end configuration; -- adder_gen_behav_conf