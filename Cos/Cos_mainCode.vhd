----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:17:38 08/10/2016 
-- Design Name: 
-- Module Name:    Cos_mainCode - Behavioral 
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

entity Cos_mainCode is port (
clk , reset: in  STD_LOGIC;
           phase : in  STD_LOGIC_VECTOR (7 downto 0);
           cos : out  STD_LOGIC_VECTOR (7 downto 0);
			  error : out STD_LOGIC
			  );
end Cos_mainCode;

architecture Behavioral of Cos_mainCode is

COMPONENT Cos_core
  PORT (
    phase_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    x_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC
  );
END COMPONENT;

COMPONENT convertToFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;


COMPONENT convToStandardFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal phaseSignal , cosFixedPoint , cosFloating: std_logic_vector( 7 downto 0);
signal cosFloating9bit : std_logic_vector(8 downto 0);
begin
	process(clk, reset )
		variable phaseV: std_logic_vector(7 downto 0);
		variable exponent : std_logic_vector(3 downto 0);
		variable errorV : std_logic;
		variable counter : integer;
		begin
				if(reset ='1') then
					phaseV:= "00000000";
					exponent := "0000";
					errorV := '0';
					counter := 1;
					elsif(clk'event and clk='1') then
					if(counter = 1) then
						if(phase(6 downto 0) = "0000000") then -- phase = 0
								errorV:='0';
								phaseV := "00000000";
					-- phase = number pi
					elsif(phase(6 downto 0) = "1111111") then
						if(phase(7) ='0') then -- +pi
						phaseV:= "01100100";
						elsif(phase(7) = '1') then -- -pi
							phaseV := "10011100";
						end if;
						--Nan or infinitie 
					elsif(phase(6 downto 3) = "1111") then
						errorV := '1';
						
								else
								errorV:= '0';
								phaseV:= "001" & phase(2 downto 0) & "00";
								exponent := phase(6 downto 3) - "0111";
								-- if exponent is bigger than 1 the result won't be correct
									if(to_integer(signed(exponent)) > 1)then
									errorV :='1';
									end if;
									
								-- exponent is negative so we should shift the phase to right
								if(exponent(3) ='1') then
									exponent := not(exponent) +"0001";
									for i in 1 to 16 loop
										if(i <= to_integer(unsigned(exponent))) then
											phaseV(6 downto 0) := phaseV(7 downto 1);
											phaseV(7):= '0';
										end if;
									end loop;
									
								-- exponent is Positive so we should shift the phase to left
							  elsif(exponent(3) ='0') then
									for i in 1 to 16 loop
										if(i <= to_integer(unsigned(exponent))) then
										phaseV(7 downto 1) := phaseV(6 downto 0);
										phaseV(0):= '0';
										end if;
									end loop;
							end if;
							
							if(phase(7) = '1') then
								phaseV := not(phaseV) +"00000001";
							end if;
						end if; -- phase = 0
						counter:= counter+1;
						end if; --counter
				end if;-- if reset				
				phaseSignal<= phaseV;
				error<= errorV;
				cos<= cosFloating;
				
	end process;
-- calculate cos using cordic
calculateCos : Cos_core
  PORT MAP (
    phase_in => phaseSignal,
    x_out => cosFixedPoint,
    clk => clk
  );
--converts the result of cordic to floating point with the format of 1,5,3 bit foe sign , exponent , fraction
convertFloatingCos :convertToFloating
  PORT MAP (
    a =>  cosFixedPoint,
    clk => clk,
    result => cosFloating9bit
  );

-- converts the floating point with the format of 1,5,3 to 1,4,3 bit for sign , exponent and fraction
standardFloatingCos :convToStandardFloating
  PORT MAP (
    a => cosFloating9bit,
    clk => clk,
    result => cosFloating
  );


end Behavioral;

