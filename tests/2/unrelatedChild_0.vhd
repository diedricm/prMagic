library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;


entity unrelatedChild_0 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Y : out STD_LOGIC);
end unrelatedChild_0;

architecture Behavioral of unrelatedChild_0 is
begin
    Y <= A XOR B;
end Behavioral;
