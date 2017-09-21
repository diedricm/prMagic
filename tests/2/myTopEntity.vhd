library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity myTopEntity is
    Port (
        clk : in STD_LOGIC;
        rst : in std_logic;
        leds : out STD_LOGIC_VECTOR (7 downto 0));
end myTopEntity;

architecture Behavioral of myTopEntity is
    component rshiftLEDs is
    Port ( trigger : in STD_LOGIC;
           leds : out STD_LOGIC_VECTOR (7 downto 0));
    end component rshiftLEDs;
    
    component upcounter is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               rst_val : in STD_LOGIC_VECTOR (15 downto 0);
               trigger : out STD_LOGIC);
    end component upcounter;

    signal itrigger : std_logic;
begin

    --prmodule (lshiftLEDs);
    --prmodule (blinkingLEDs);
    leddriver: rshiftLEDs
    port map(
        trigger => itrigger,
        leds => leds
    );
    
    --prmodule (downcounter);
    triggercounter: upcounter
    port map(
        clk => clk,
        rst => rst,
        rst_val => X"DEAD",
        trigger => itrigger
    );

end Behavioral;
