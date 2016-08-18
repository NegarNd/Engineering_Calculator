----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:50 08/13/2016 
-- Design Name: 
-- Module Name:    squareRoot_mainCode - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity squareRoot_mainCode is port
(
num1: in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
squareRoot : out std_logic_vector(7 downto 0);
error : out std_logic
);
end squareRoot_mainCode;

architecture Behavioral of squareRoot_mainCode is

COMPONENT squareRoot_core
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    invalid_op : OUT STD_LOGIC
  );
END COMPONENT;


signal underflow , invalid_op , errorS : std_logic;
signal num1S : std_logic_vector(7 downto 0);
begin

process(clk, reset)

variable errorV  : std_logic;
variable a, b : std_logic_vector(7 downto 0);

	begin
		if(reset ='1') then
			errorV:='0';
			elsif(clk'event and clk='1') then
				if(num1(6 downto 3) ="1111") then -- number pi
					if(num1(2 downto 0)="111")then
						a:= num1(7) & "1000100";
						errorV:='0';
						elsif(num1(2 downto 0)="000")then
							a:= num1;
							errorV:= '0';
						else
						a:= num1;
						errorV:= '1'; -- NAN
					end if;
				else
					errorV:='0';
					a:= num1;
				end if;
				
		end if; -- if(reset)
						
		num1S<=a;
		errorS <= errorV;
	end process;
	error<= errorS or invalid_op ;



your_instance_name : squareRoot_core
  PORT MAP (
    a => num1S,
    clk => clk,
    sclr => reset,
    result => squareRoot,
    invalid_op => invalid_op
  );

end Behavioral;

