

library IEEE;
library lib_rtl;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use lib_rtl.all;

entity mult_4 is
  port (
    a_i : in std_logic_vector(3 downto 0);
    b_i : in std_logic_vector(3 downto 0);
    s_o : out std_logic_vector(15 downto 0)
  ) ;
end mult_4;

architecture mult_4_arch of mult_4 is

  signal partial_s : std_logic_vector(15 downto 0); -- 4 * 4 = one partial for each operand b_i bit
  signal partial_sum_s : std_logic_vector(31 downto 0);
  signal partial_shifted_s : std_logic_vector(63 downto 0); -- 16 * 4 = each partial is shifted on 16 bits
  signal extended_a_s : std_logic_vector(15 downto 0);

  component adder_gen
  generic(
    n_g : natural
  );
  port(
    a_i : in std_logic_vector(n_g - 1 downto 0);
    b_i : in std_logic_vector(n_g - 1 downto 0);
    c_i : std_logic;
    s_o : out std_logic_vector(n_g - 1 downto 0)
  );
  end component;
  
begin
  
  -- extended a_i signal
  extended_a_s(3 downto 0) <= (others => a_i(0));
  extended_a_s(7 downto 4) <= (others => a_i(1));
  extended_a_s(11 downto 8) <= (others => a_i(2));
  extended_a_s(15 downto 12) <= (others => a_i(3));

  -- partial products
  partial_s(3 downto 0) <= extended_a_s(3 downto 0) and b_i;
  partial_s(7 downto 4) <= extended_a_s(7 downto 4) and b_i;
  partial_s(11 downto 8) <= extended_a_s(11 downto 8) and b_i;
  partial_s(15 downto 12) <= extended_a_s(15 downto 12) and b_i;

  -- partial products shifted
  partial_shifted_s(3 downto 0) <= partial_s(3 downto 0);
  partial_shifted_s(15 downto 4) <= (others => '0');
  partial_shifted_s(20 downto 16) <= partial_s(7 downto 4) & '0';
  partial_shifted_s(31 downto 21) <= (others => '0');
  partial_shifted_s(37 downto 32) <= partial_s(11 downto 8) & "00";
  partial_shifted_s(47 downto 38) <= (others => '0');
  partial_shifted_s(54 downto 48) <= partial_s(15 downto 12) & "000";
  partial_shifted_s(63 downto 55) <= (others => '0');
  
  -- sum of partial products
  partial_sum_0: adder_gen
  generic map(
    n_g => 16
  )
  port map(
    a_i => partial_shifted_s(15 downto 0),
    b_i => partial_shifted_s(31 downto 16),
    c_i => '0',
    s_o => partial_sum_s(15 downto 0)
  );

  partial_sum_1: adder_gen
  generic map(
    n_g => 16
  )
  port map(
    a_i => partial_shifted_s(47 downto 32),
    b_i => partial_shifted_s(63 downto 48),
    c_i => '0',
    s_o => partial_sum_s(31 downto 16)
  );
  
  final_sum : adder_gen
  generic map(
    n_g => 16
  )
  port map(
    a_i => partial_sum_s(15 downto 0),
    b_i => partial_sum_s(31 downto 16),
    c_i => '0',
    s_o => s_o
  );

end mult_4_arch ; -- mult_4_arch

configuration mult_4_conf of mult_4 is
  for mult_4_arch
      for all : adder_gen
          use configuration lib_rtl.adder_gen_behav_conf;
      end for;
  end for;
end configuration; -- mult_4_conf