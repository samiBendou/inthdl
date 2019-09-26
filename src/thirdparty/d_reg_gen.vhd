library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity d_reg_gen is

    generic (
        n_g : natural := 4
    );
  port (
    d_i : in std_logic_vector(n_g - 1 downto 0);
    clk_i : in std_logic;
    resetb_i : in std_logic;
    select_i : in std_logic;
    q_o : out std_logic_vector(n_g - 1 downto 0)
  );
end d_reg_gen;

architecture d_reg_gen_arch of d_reg_gen is

    signal q_s : std_logic_vector(n_g - 1 downto 0); 

begin

    update_reg : process( clk_i, resetb_i, select_i )
    begin
        if(resetb_i = '0') then
            q_s <= (others => '0');
        elsif(clk_i'event and clk_i = '1') then -- rising edge
            if(select_i = '1') then
                q_s <= d_i;
            end if;
        else
            -- A enlever après test
            q_s <= q_s;
        end if;
    end process ; -- update_reg

    q_o <= q_s;

end d_reg_gen_arch  ; -- d_reg_gen_arch    