library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity counter_4 is
    port ( 
        clk_i: in std_logic; -- clock input
        resetb_i: in std_logic; -- reset input 
        count_o: out std_logic_vector(3 downto 0) -- output 4-bit counter
     );
end counter_4;

architecture counter_4_arch of counter_4 is

signal count_s: natural range 0 to 15;

begin

count_up: process(clk_i,resetb_i)
begin
    if(resetb_i = '0') then
        count_s <= 0;
    elsif(clk_i'event and clk_i = '1') then
        if(count_s = 15) then
            count_s <= 0;
        else 
            count_s <= count_s + 1;
        end if;
    end if;
end process; --count_up
 count_o <= std_logic_vector(to_unsigned(count_s, count_o'length));

end counter_4_arch;