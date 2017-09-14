library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;


entity unrelatedChild_1 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Y : out STD_LOGIC);
end unrelatedChild_1;

architecture Behavioral of unrelatedChild_1 is
begin
    Y <= A AND B;
end Behavioral;
