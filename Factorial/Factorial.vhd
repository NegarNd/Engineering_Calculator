----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:19:00 08/09/2016 
-- Design Name: 
-- Module Name:    Factorial - Behavioral 
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

entity Factorial is port
(
x : std_logic_vector(7 downto 0);
clk , reset: in std_logic;
factorial : out std_logic_vector(7 downto 0);
error : out std_logic
);
end Factorial;

architecture Behavioral of Factorial is

COMPONENT convertToFixedPoint
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );
END COMPONENT;


COMPONENT fixedToFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT StandardFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    underflow : OUT STD_LOGIC;
    overflow : OUT STD_LOGIC
  );
END COMPONENT;

signal fixedPoint : std_logic_vector(4 downto 0);
signal fixedpointResult , factorialS: std_logic_vector(7 downto 0);
signal floating9bit : std_logic_vector(8 downto 0);
signal overflow , underflow : std_logic;
begin

process( reset ,clk)
	variable errorV  : std_logic;
	variable  counter , multiResult : integer;
	variable fixedPointV :std_logic_vector(4 downto 0);
	variable fixedpointResultV : std_logic_vector(7 downto 0);
		begin
			if(reset ='1') then
				errorV :='0';
				counter := 1;
				multiResult:=1;
				elsif(clk'event and clk='1') then
						
					if(x(6 downto 3) = "1111") then --the number is pi, infinitie or NAN
						errorV :='1';
						elsif((to_integer(unsigned(x(6 downto 3))) -7 ) <1 ) then
							errorV:='1';
							elsif((to_integer(unsigned(x(6 downto 3))) -7 ) >2 ) then
							errorV:='1';
							elsif(fixedPoint(0) ='1') then -- number has a fraction
							errorV :='1';
							elsif(x(6 downto 0) = "0000000") then -- 0!
							factorial <= x(7) & "0111000";	
							
								else
									if(fixedPoint(4) = '1') then
										fixedPointV := not(fixedPoint) + "00001";
										else
										fixedPointV := fixedPoint;
									end if;
									
									if(to_integer(unsigned(fixedPointV(4 downto 1))) > 5) then
										errorV:='1';
									end if;
									for i in 1 to 16 loop
										if(counter <= to_integer(unsigned(fixedPointV(4 downto 1))))
											then
											multiResult := multiResult * counter;
											counter := counter + 1;
										end if;
									end loop;
								fixedpointResultV := std_logic_vector(to_unsigned(multiResult , 8));
								if(x(4) = '1') then
									fixedpointResultV := not(fixedpointResult) +"00000001";
								end if;
						end if;
				end if;
			error<= errorV or underflow or overflow;
			fixedpointResult<= fixedpointResultV ;
			factorial<= factorialS;
			
end process;
convToFixed : convertToFixedPoint
  PORT MAP (
    a => x,
    clk => clk,
    result => fixedPoint
  );

fixedToFloatingINST2 : fixedToFloating
  PORT MAP (
    a => fixedpointResult, 
    clk => clk,
    result => floating9bit
  );

StandardFloatingINST2 : StandardFloating
  PORT MAP (
    a => floating9bit,
    clk => clk,
    result => factorialS,
    underflow => underflow,
    overflow => overflow
  );

end behavioral;