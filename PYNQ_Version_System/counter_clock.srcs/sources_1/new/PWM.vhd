library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_generator is
    generic (
        COUNTER_WIDTH : integer := 24  -- Adjust based on period count
    );
    Port (
        clk        : in  STD_LOGIC;          -- Fast clock (e.g., 100-600 MHz)  
        period : in  unsigned(COUNTER_WIDTH-1 downto 0);            -- Total PWM period in clock cycles         
        duty_cycle : in  unsigned(COUNTER_WIDTH-1 downto 0);        -- How long output stays LOW
        pwm_out    : out STD_LOGIC                                  -- Output signal
    );
end pwm_generator;

architecture Behavioral of pwm_generator is
    signal counter : unsigned(COUNTER_WIDTH-1 downto 0) := (others => '0');
    
    begin

    process(clk)
    begin
        if rising_edge(clk) then
            if counter = period - 1 then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Output stays LOW during the glitch window (first duty_cycle cycles)
    pwm_out <= '0' when counter < duty_cycle else '1';

end Behavioral;