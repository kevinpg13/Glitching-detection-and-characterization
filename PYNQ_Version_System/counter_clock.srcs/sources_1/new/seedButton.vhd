library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seedButton is
    Port (
        clock            : in  STD_LOGIC;
        button           : in  STD_LOGIC;
        debounced_button : out STD_LOGIC  -- Will stay '1' after first press
    );
end seedButton;

architecture Behavioral of seedButton is
    signal button_debounced     : STD_LOGIC := '0';
    signal last_button_state    : STD_LOGIC := '0';
    signal latch_once           : STD_LOGIC := '0';

    component buttonDebouncer
        Port (
            clock     : in STD_LOGIC;
            button    : in STD_LOGIC;
            debounced : out STD_LOGIC
        );
    end component;
begin

    debouncer_inst : buttonDebouncer
        port map (
            clock     => clock,
            button    => button,
            debounced => button_debounced
        );

    process(clock)
    begin
        if rising_edge(clock) then
            if latch_once = '0' and button_debounced = '1' and last_button_state = '0' then
                latch_once <= '1';  -- Only latch on first rising edge
            end if;
            last_button_state <= button_debounced;
        end if;
    end process;

    debounced_button <= latch_once;

end Behavioral;