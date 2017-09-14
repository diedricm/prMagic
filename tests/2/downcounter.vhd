library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity downcounter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rst_val : in STD_LOGIC_VECTOR (15 downto 0);
           trigger : out STD_LOGIC);
end downcounter;

architecture Behavioral of downcounter is
    signal cnt : unsigned(15 downto 0);
begin

    trigger <= '1' when cnt = 0 else '0';

    process (clk, rst)
    begin
        if rst = '1' then
            cnt <= unsigned(rst_val);
        elsif rising_edge(clk) then
            cnt <= cnt - 1;
        end if;
    end process;
end Behavioral;
