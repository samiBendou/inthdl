library lib_rtl;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity adder_4 is
  port (
    a_i : in std_logic_vector(3 downto 0);
    b_i : in std_logic_vector(3 downto 0);
    c_i : in std_logic;
    c_o : out std_logic;
    s_o : out std_logic_vector(3 downto 0)
  ) ;
end adder_4;

architecture adder_4_arch of adder_4 is
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
    signal c_s : std_logic_vector(2 downto 0);
begin

    adder_0: full_adder
    port map(
        a_i => a_i(0),
        b_i => b_i(0),
        c_i => c_i,
        c_o => c_s(0),
        s_o => s_o(0)
    );

    adder_1: full_adder
    port map(
        a_i => a_i(1),
        b_i => b_i(1),
        c_i => c_s(0),
        c_o => c_s(1),
        s_o => s_o(1)
    );

    adder_2: full_adder
    port map(
        a_i => a_i(2),
        b_i => b_i(2),
        c_i => c_s(1),
        c_o => c_s(2),
        s_o => s_o(2)
    );
    
    adder_3: full_adder
    port map(
        a_i => a_i(3),
        b_i => b_i(3),
        c_i => c_s(2),
        c_o => c_o,
        s_o => s_o(3)
    );

end adder_4_arch ; -- adder_4_arch

configuration adder_4_conf of adder_4 is
    for adder_4_arch
        for all : full_adder
            use configuration lib_rtl.full_adder_conf;
        end for;
    end for;
end configuration; -- adder_4_conf