----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:32:43 08/16/2016 
-- Design Name: 
-- Module Name:    remainder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity remainder is port
(
num1 , num2 : in std_logic_vector(7 downto 0);
clk ,reset : in std_logic;
mode : out std_logic_vector(7 downto 0);
error : out std_logic
);
end remainder;

architecture Behavioral of remainder is

component divider_mainCode is port
(num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;


component Subtractor_mainCode is port 
(
num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;


component multiplier_mainCode is port
(
num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic;
rdy : out std_logic
);

end component;


COMPONENT FixedToFloat
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;


COMPONENT standardFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    underflow : OUT STD_LOGIC;
    overflow : OUT STD_LOGIC
  );
END COMPONENT;


signal dividR , multiR , floatingQuotient , subR: std_logic_vector(7 downto 0);
signal floating9bit  , fixedPointS  : std_logic_vector(8 downto 0);
signal dividE , underflow , overflow , multiE , multiRDY , subE: std_logic;

begin
	
	RemainderDivider : divider_mainCode port map(num1 , num2 , clk , reset , dividR , dividE );
	RemainderSub : subtractor_mainCode port map(num1 , multiR , clk, reset , subR , subE);
	RemainderMulti : multiplier_mainCode port map(num2 ,  floatingQuotient , clk, reset , multiR, multiE , multiRDY);
	process(dividR)
		variable fixedPoint : std_logic_vector(11 downto 0 );
		begin
			fixedPoint := "000000000000";
			
		-- convert the divider result to 12 bit signed fixed point with the format of 9,3
			fixedPoint(3 downto 0) := '1' & dividR(2 downto 0) ;
				if((to_integer(unsigned(dividR(6 downto 3))) -7) <0 ) then -- shift right
					for i in 1 to 16 loop
						if(i<= (7 - to_integer(unsigned(dividR(6 downto 3))))) then
							fixedPoint( 10 downto 0) := fixedPoint(11 downto 1);
							fixedPoint(11) :='0';
						end if;
					end loop;
				elsif((to_integer(unsigned(dividR(6 downto 3))) -7) >0 ) then-- shift right
					for i in 1 to 16 loop
						if(i<= (to_integer(unsigned(dividR(6 downto 3)))) -7) then
							fixedPoint( 11 downto 1) := fixedPoint(10 downto 0);
							fixedPoint(0) :='0';
						end if;
					end loop;
				end if;	
				
				if(dividR(7) = '1') then
					fixedPoint(11 downto 3) := not ( fixedPoint(11 downto 3)) +"000000001";
				end if;
					fixedPointS <= fixedPoint( 11 downto 3) ;
	end process;
	
	error <= underflow or overflow or subE or multiE or dividE;
	
FixedToFloatINST : FixedToFloat
  PORT MAP (
    a => fixedPointS,
    clk => clk,
    result => floating9bit
  );


standardFloatingINST : standardFloating
  PORT MAP (
    a => floating9bit,
    clk => clk,
    result => floatingQuotient,
    underflow => underflow,
    overflow => overflow
  );


end Behavioral;

