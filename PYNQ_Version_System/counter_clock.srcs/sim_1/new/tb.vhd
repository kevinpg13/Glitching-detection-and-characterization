library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clk_300mhz is
end tb_clk_300mhz;

architecture Behavioral of tb_clk_300mhz is
    signal clk : std_logic;
    component clk_300mhz
        Port ( clk_out : out STD_LOGIC );
    end component;
begin
    uut: clk_300mhz
        port map (
            clk_out => clk
        );

    process
    begin
        wait for 100 ns; -- Simulate for 100 ns
        assert false report "Simulation finished" severity failure;
    end process;
end Behavioral;
