    
library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity mult_gen is
  generic (
    n_g: natural := 4
  );
  port (
    a_i : in std_logic_vector(n_g - 1 downto 0);
    b_i : in std_logic_vector(n_g - 1 downto 0);
    s_o : out std_logic_vector(n_g * n_g - 1 downto 0)
  ) ;
end mult_gen;

architecture mult_gen_arch of mult_gen is

  signal partial_s : std_logic_vector(n_g * n_g - 1 downto 0); -- 4 * 4 = one partial for each operand b_i bit
  signal partial_sum_s : std_logic_vector(31 downto 0);
  signal partial_shifted_s : std_logic_vector(n_g * n_g * n_g - 1 downto 0); -- 16 * 4 = each partial is shifted on 16 bits
  signal extended_a_s : std_logic_vector(n_g * n_g - 1 downto 0);

  component adder_gen_n
  generic(
    nb_g : natural;
    no_g : natural
  );
  port(
    e_i : in std_logic_vector(n_g * no_g - 1 downto 0);
    c_i : std_logic;
    s_o : out std_logic_vector(n_g - 1 downto 0)
  );
  end component;

begin

  partial_products : for i in 0 to n_g-1 generate
    extended_a_s(n_g * (i + 1) - 1 downto n_g * i) <= (others => a_i(i));
    partial_s(n_g * (i + 1) - 1 downto n_g * i) <= extended_a_s (n_g * (i + 1) - 1 downto n_g * i) and b_i;
  end generate ; -- partial_products

  partial_shifts : for k in 0 to n_g-1 generate
    shift_0: if k = 0 generate
      partial_shifted_s(n_g-1 downto 0) <= partial_s(n_g-1 downto 0);
      partial_shifted_s(n_g * n_g -1 downto n_g) <= (others => '0');
    end generate; 

    shift_k: if k > 0 generate
        partial_shifted_s((n_g * n_g + 1) * k - 1 downto n_g * n_g * k) <= (others => '0');
        partial_shifted_s((n_g * n_g + 1) * k + n_g - 1 downto (n_g * n_g + 1) * k) <= partial_s(n_g * (k + 1) - 1 downto n_g * k);
        partial_shifted_s(n_g * n_g * (k + 1) - 1 downto (n_g * n_g + 1) * k + n_g) <= (others => '0');
    end generate; -- 
  end generate ; -- partial_shifts

  final_sum: adder_gen_n
  generic map(
    nb_g => n_g * n_g,
    no_g => n_g
  )

  port map(
    e_i => partial_shifted_s,
    c_i => '0',
    s_o => s_o
  );

end mult_gen_arch ; -- mult_gen_arch

configuration mult_gen_conf of mult_gen is
  for mult_gen_arch
      for all : adder_gen_n
          use configuration lib_rtl.adder_gen_n_conf;
      end for;
  end for;
end configuration; -- mult_gen_conf