----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:16:09 08/12/2016 
-- Design Name: 
-- Module Name:    multiplier_mainCode - Behavioral 
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

entity multiplier_mainCode is port
(
num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic;
rdy : out std_logic
);

end multiplier_mainCode;

architecture Behavioral of multiplier_mainCode is

COMPONENT multiplier_core
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    underflow : OUT STD_LOGIC;
    overflow : OUT STD_LOGIC;
    invalid_op : OUT STD_LOGIC;
    rdy : OUT STD_LOGIC
  );
END COMPONENT;



signal underflow , invalid_op , overflow , errorS, rdyS2 , rdyS  : std_logic;
signal num1S , num2S , multiResult : std_logic_vector(7 downto 0);
begin
	process( reset ,clk)

variable errorV  : std_logic;
variable a, b : std_logic_vector(7 downto 0);

	begin
		if(reset ='1') then
			errorV:='0';
			a:= "00000000";
			b:="00000000";
			
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
				
				if(num2(6 downto 3) ="1111") then
					if(num2(2 downto 0)="111")then-- number pi
						b:= num2(7) & "1000100";
						errorV:= errorV or '0';
						elsif(num2(2 downto 0)="000")then
							b:= num2;
							errorV:= errorV or '0';
						else
						b:= num2;
						errorV:= '1'; -- NAN
					end if;
				else
					errorV:= errorV or '0';
					b:= num2;
				end if;	
		end if; -- if(reset)
						
		num1S<=a;
		num2S<=b;
		errorS <= errorV;
	end process;
	error<= errorS or  underflow or invalid_op or overflow;
	
	rdy<= rdyS;
	
	result<= multiResult;
your_instance_name : multiplier_core
  PORT MAP (
    a => num1S,
    b => num2S,
    clk => clk,
    sclr => reset,
    result => multiResult,
    underflow => underflow,
    overflow => overflow,
    invalid_op => invalid_op,
    rdy => rdyS
  );

end Behavioral;

