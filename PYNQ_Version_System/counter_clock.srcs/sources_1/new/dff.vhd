library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_ff_async_reset is
    Port (
        D    : in  STD_LOGIC;      
        reset: in  STD_LOGIC;
        Q    : out STD_LOGIC
    );
end d_ff_async_reset;

architecture Behavioral of d_ff_async_reset is
begin
    process(D, reset)
    begin
        if reset = '1' then
            Q <= '0';
        else
            Q <= D;           
        end if;
    end process;
end Behavioral;