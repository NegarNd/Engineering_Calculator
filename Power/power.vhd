----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:25:32 08/12/2016 
-- Design Name: 
-- Module Name:    power - Behavioral 
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

entity power is port
(
base : in std_logic_vector(7 downto 0);
power : in std_logic_vector(7 downto 0);
clk, reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end power;

architecture Behavioral of power is

component multiplier_mainCode is port
(
num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic;
rdy : out std_logic
);

end component;

component divider_mainCode is port
(num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;


signal num1 , num2 , multiResult, zeroResult , dividerResult: std_logic_vector(7 downto 0);
signal powerFixedPointS : std_logic_vector(10 downto 0);
signal multiplierError ,errorS , multiRdy, dividerError: std_logic;
signal count : integer;
begin
	Power_multi : multiplier_mainCode port map (num1 , num2 , clk, reset , multiResult, multiplierError ,multiRdy );
	Power_divider : divider_mainCode port map("00111000" ,base, clk , not(reset) , dividerResult , dividerError);

	process(clk,reset)
		variable powerResultV : std_logic_vector(7 downto 0);
		variable errorV : std_logic;
		begin
			if(reset = '1') then
				errorV:='0';
				elsif(clk'event and clk='1') then
					if(power= "00000000") then -- zero power
						errorV := '0';
						zeroResult<= "00111000";
						elsif(power(6 downto 3) = "1111") then -- NAN or infinitie power
							errorV := '1';
							elsif(( to_integer(unsigned(power(6 downto 3))) - 7) <0) then -- power isn't integer
								errorV := '1';
					end if; --if(power= "00000000")
			end if; -- if (reset)
		   errorS<= errorV;
	end process;

process(power)
variable powerFixedPointV : std_logic_vector(10 downto 0);
	begin
		 -- convert the floating point power to fixed point
		powerFixedPointV := "00000000000";
		powerFixedPointV(3 downto 0) := '1' & power(2 downto 0);
				for i in 1 to 16 loop
					if(i<=(to_integer(unsigned(power(6 downto 3)))-7)) then
							powerFixedPointV(10 downto 1) := powerFixedPointV(9 downto 0);
							powerFixedPointV(0) := '0';
					end if;
				end loop;
			powerFixedPointS <= powerFixedPointV;
end process;

	process(multiResult, reset,power, base)
		
		variable counter : integer;
	begin
		if(reset ='1') then
			counter := 1;
			if(power(7) = '0')then
						num1<=base;
					else
						num1<=dividerResult;
			end if;
				num2<="00111000";
		else
				if(counter = 1) then
				counter := counter +1;
				elsif(counter <= (to_integer(unsigned(powerFixedPointS(10 downto 3)))))then
				num2<=multiResult;
				counter:= counter+ 1;
				end if;
		end if;
		if(power="00000000") then
			result<= zeroResult;
			else
			result<=multiResult;
		end if;
	end process;

	
	error<= errorS or multiplierError or dividerError;

end Behavioral;

