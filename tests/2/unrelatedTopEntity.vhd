library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unrelatedTopEntity is
    Port ( clk : in STD_LOGIC;
           A : in STD_LOGIC;
           B : in STD_LOGIC;
           Y : out STD_LOGIC);
end unrelatedTopEntity;

architecture Behavioral of unrelatedTopEntity is
    component unrelatedChild_0 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Y : out STD_LOGIC);
    end component unrelatedChild_0;

    signal iY : std_logic;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            Y <= iY;
        end if;
    end process;

	--prmodule (unrelatedChild_1); 
    child: unrelatedChild_0
    port map(
        A => A,
        B => B,
        Y => iY
    );

end Behavioral;
