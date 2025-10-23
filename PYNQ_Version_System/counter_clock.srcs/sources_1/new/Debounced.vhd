-- buttonDebouncer.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity buttonDebouncer is
    Port (
        clock : in std_logic;
        button : in std_logic;
        debounced : out std_logic
    );
end buttonDebouncer;


architecture Debounce of buttonDebouncer is
    constant DEBOUNCE_TIME : integer := 5_000_000;-- 5,000,000 cycles/125MHz = 0.04seconds = 40ms
    signal counter : integer range 0 to DEBOUNCE_TIME := 0;
    signal button_stable : std_logic := '0';
    signal button_last : std_logic := '0';

begin
    process(clock)
    begin
        if rising_edge(clock) then
            if button = button_last then
                if counter < DEBOUNCE_TIME then
                    counter <= counter + 1;
                else
                    button_stable <= button;
                end if;
            else
                counter <= 0;
            end if;
            
            button_last <= button;
        end if;
    end process;
    
    debounced <= button_stable;
end Debounce;