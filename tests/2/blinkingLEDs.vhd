library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blinkingLEDs is
    Port ( trigger : in STD_LOGIC;
           leds : out STD_LOGIC_VECTOR (7 downto 0));
end blinkingLEDs;

architecture Behavioral of blinkingLEDs is
    signal ileds : std_logic_vector(7 downto 0) := "01010101";
begin

    leds <= ileds;

    process(trigger)
    begin
        if rising_edge(trigger) then
            ileds <= "11111111" XOR ileds;
        end if;
    end process;

end Behavioral;
