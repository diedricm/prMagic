library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity avg_engine is
Port ( 
    clk : in std_logic;
    A : in unsigned(31 downto 0);
    Y : out unsigned(31 downto 0)
);
end avg_engine;

architecture Behavioral of avg_engine is
    component avg_module_1 is
    Port ( 
        clk : in std_logic;
        A : in unsigned(31 downto 0);
        Y : out unsigned(31 downto 0)
    );
    end component avg_module_1;
    component avg_module_2 is
    Port ( 
        clk : in std_logic;
        A : in unsigned(31 downto 0);
        Y : out unsigned(31 downto 0)
    );
    end component avg_module_2;

    signal Y_i1, Y_i2 : unsigned(31 downto 0);
begin

    Y <= Y_i1 when Y_i1 >= Y_i2 else Y_i2; 

    avg_simple: avg_module_1
    port map (
        clk => clk,
        A => A,
        Y => Y_i1
    );

	--PRMODULE anotherModule01
	--PRMODULE anotherModule02
	--PRMODULE anotherModule03
    myRegion01: avg_module_2
    port map (
        clk => clk,
        A => A,
        Y => Y_i2
    );

end Behavioral;