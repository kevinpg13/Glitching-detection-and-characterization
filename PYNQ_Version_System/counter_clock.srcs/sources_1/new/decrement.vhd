library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decrementButton is
    Port (
        clk     : in  STD_LOGIC;
        button  : in  STD_LOGIC;
        pulse   : out STD_LOGIC
    );
end decrementButton;

architecture Behavioral of decrementButton is
    signal debounced      : STD_LOGIC := '0';
    signal last_state     : STD_LOGIC := '0';
   
    component buttonDebouncer
        Port (
            clock     : in  STD_LOGIC;
            button    : in  STD_LOGIC;
            debounced : out STD_LOGIC
        );
    end component;

begin
 -- Instantiate Debouncer
    debouncer_inst : buttonDebouncer
        port map (
            clock     => clk,
            button    => button,
            debounced => debounced
        );
-- Register the last state of the debounced button
    process(clk)
    begin
        if rising_edge(clk) then
            last_state  <= debounced;
        end if;
    end process;

      -- Pulse goes high for one cycle on rising edge of debounced signal
    pulse <= debounced and not last_state;

end Behavioral;