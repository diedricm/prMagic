library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity avg_module_2 is
Port ( 
    clk : in std_logic;
    A : in unsigned(31 downto 0);
    Y : out unsigned(31 downto 0)
);
end avg_module_2;

architecture Behavioral of avg_module_2 is
    constant memdepth_base2 : integer := 16;
    type memory is array(NATURAL range <>) of unsigned(31 downto 0);
    signal mem : memory(2**memdepth_base2-1 downto 0) := (others => X"00000000");
    
    signal running_total : unsigned(32+memdepth_base2-1 downto 0) := (others => '0');
    
    signal headpointer : unsigned(memdepth_base2-1 downto 0) := (others => '1');
    signal tailpointer : unsigned(memdepth_base2-1 downto 0) := (others => '0');
begin 

    main: process(clk)
        variable longA, longB : unsigned(32+memdepth_base2-1 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            mem(to_integer(headpointer)) <= A;
            longA(31 downto 0) := A;
            longB(31 downto 0) := mem(to_integer(tailpointer));
            running_total <= running_total + longA - longB;
            Y <= running_total(running_total'HIGH-1 downto running_total'HIGH-32);
            
            headpointer <= headpointer + 1;
            tailpointer <= tailpointer + 1;
        end if;
    end process;

end Behavioral;

entity avg_module_2 is
Port ( 
    clk : in std_logic;
    A : in unsigned(31 downto 0);
    Y : out unsigned(31 downto 0)
);
end avg_module_2;