library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lshiftLEDs is
    Port ( trigger : in STD_LOGIC;
           leds : out STD_LOGIC_VECTOR (7 downto 0));
end lshiftLEDs;

architecture Behavioral of lshiftLEDs is
    signal ileds : std_logic_vector(7 downto 0) := "00000001";
begin

    leds <= ileds;

    process(trigger)
    begin
        if rising_edge(trigger) then
            ileds <= ileds(6 downto 0) & ileds(7);
        end if;
    end process;

end Behavioral;
