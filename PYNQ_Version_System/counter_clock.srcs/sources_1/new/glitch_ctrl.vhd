library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity glitch_control_module is
    Port (
        clk           : in  STD_LOGIC;
        random_val    : in  unsigned(15 downto 0);
        glitch_active : in  STD_LOGIC;
        glitch_req    : buffer STD_LOGIC;
        request_new   : out STD_LOGIC;
        glitch_mode_val : out STD_LOGIC
    );
end glitch_control_module;

architecture Behavioral of glitch_control_module is
    signal glitch_counter : unsigned(15 downto 0) := (others => '0');
    signal stored_random  : unsigned(15 downto 0) := (others => '0');
    signal ready_for_new  : STD_LOGIC := '1';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Counter logic
            if glitch_counter = stored_random then
                glitch_counter <= (others => '0');  -- Reset counter on match
                glitch_req <= '1';                  -- Trigger glitch
            else
                glitch_counter <= glitch_counter + 1;
                glitch_req <= '0';
            end if;

            -- Load new random value when glitch is done
            if glitch_active = '0' and ready_for_new = '1' then
                stored_random    <= random_val;
                glitch_mode_val  <= random_val(0);
                ready_for_new    <= '0';  -- Prevent loading again too soon
            end if;

            -- Re-arm ready flag once glitch becomes active
            if glitch_active = '1' then
                ready_for_new <= '1';
            end if;
        end if;
    end process;

    -- Ask for new random value when glitch triggers
    request_new <= '1' when glitch_active = '1' and glitch_req = '1' else '0';

end Behavioral;
