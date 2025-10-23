library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    generic (
        DIVIDE_BY : integer := 2  -- Set this per instance
    );
    Port (
        clk_in   : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        clk_out  : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal counter : unsigned(31 downto 0) := (others => '0');
    signal toggle  : STD_LOGIC := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                counter <= (others => '0');
                toggle  <= '0';
            elsif counter = (DIVIDE_BY/2 - 1) then
                counter <= (others => '0');
                toggle  <= not toggle;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= toggle;
end Behavioral;
