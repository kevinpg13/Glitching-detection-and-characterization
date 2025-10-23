library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity STAGES is
    Port (
        start_pulse : in  STD_LOGIC;
        co_taps : out STD_LOGIC_VECTOR(0 to 255)
    );
end STAGES;

architecture Structural of STAGES is

    signal co : STD_LOGIC_VECTOR(255 downto 0 );
    signal s     : STD_LOGIC_VECTOR(3 downto 0); --:= (others => '1');
    signal di    : STD_LOGIC_VECTOR(3 downto 0); --:= (others => '0');
    

    attribute RLOC : string;
    attribute KEEP : string;
    attribute DONT_TOUCH : string;

    attribute KEEP of co : signal is "true";
    attribute DONT_TOUCH of co : signal is "true";

    

begin

    s  <= (others => '1');  -- S = "1111" permanentemente
    di <= (others => '0');  -- DI = "0000" permanentemente

-- Bloque 0
  C0 : CARRY4
    port map (
      CI     => '0',
      CYINIT => start_pulse,
      DI     => di,
      S      => s,
      CO     => co(3 downto 0),
      O      => open
    );

  -- Bloques 1..63
  gen_chain : for k in 1 to 63 generate
    constant lo : integer := 4*k; -- índice inferior del bloque k
    constant hi : integer := lo+3; -- índice superior del bloque k
  begin
    Ck : CARRY4
      port map (
        CI     => co(lo-1),         -- co(4*k - 1) = co(4*(k-1)+3)
        CYINIT => '0',
        DI     => di,
        S      => s,
        CO     => co(hi downto lo),
        O      => open
      );
  end generate;

  co_taps <= co;
end Structural;