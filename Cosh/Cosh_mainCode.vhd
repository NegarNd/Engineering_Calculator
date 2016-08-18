----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:13 08/12/2016 
-- Design Name: 
-- Module Name:    Cosh_mainCode - Behavioral 
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

entity Cosh_mainCode is port
(
clk , reset  :in std_logic;
phase : in std_logic_vector(7 downto 0);
cosh : out std_logic_vector(7 downto 0);
error : out std_logic
);
end Cosh_mainCode;

architecture Behavioral of Cosh_mainCode is

COMPONENT cosh_core
  PORT (
    phase_in : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    x_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
    clk : IN STD_LOGIC
  );
END COMPONENT;

COMPONENT convToFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;

COMPONENT convertStandardFloating
  PORT (
    a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    clk : IN STD_LOGIC;
    result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    underflow : OUT STD_LOGIC;
    overflow : OUT STD_LOGIC
  );
END COMPONENT;

signal phaseSignal , coshFixedPoint : std_logic_vector(12 downto 0);
signal floating9bit : std_logic_vector(8 downto 0);
signal standardFloating : std_logic_vector(7 downto 0);
signal errorS , underflow , overflow: std_logic;

begin
	process(clk, reset) 
		variable phaseV: std_logic_vector(12 downto 0);
		variable exponent : std_logic_vector(3 downto 0);
		variable errorV : std_logic;
		variable counter : integer;
		begin
			if(reset = '1') then
					phaseV:= "0000000000000";
					exponent := "0000";
					errorV := '0';
					counter := 1;	
				elsif(clk'event and clk ='1') then
				if(counter = 1) then
					if(phase(6 downto 0) = "0000000") then -- phase = 0
								errorV:='0';
								phaseV := "0000000000000";
					-- phase is NAN or infinitie
					elsif(phase(6 downto 3) = "1111") then
						errorV := '1';
					-- out of range
					elsif((to_integer(unsigned(phase(6 downto 3))) -7)>= 0) then 
						errorV := '1';
					else
						phaseV:= "001" & phase(2 downto 0) & "0000000";
						for i in 1 to 32 loop
							if(i<=(7 - to_integer(unsigned(phase(6 downto 3))))) then
								phaseV(11 downto 0) := phaseV(12 downto 1);
								phaseV(12):= '0';
							end if;
						end loop;
						if(phase(7) = '1') then
								phaseV := not(phaseV) +"0000000000001";
							end if;
					end if;
					counter := counter+1;
				end if; --counter
			end if; -- reset
				errorS <= errorV;
				phaseSignal <= phaseV;
				cosh <= standardFloating;
	end process;
	error<= errorS or underflow or overflow;
 
calculateCosh : cosh_core
  PORT MAP (
    phase_in => phaseSignal,
    x_out => coshFixedPoint,
    clk => clk
  );


convFloatingcosh : convToFloating
  PORT MAP (
    a => coshFixedPoint,
    clk => clk,
    result => floating9bit
  );

standardFloatingCosh :  convertStandardFloating
  PORT MAP (
    a => floating9bit,
    clk => clk,
    result => standardFloating,
    underflow => underflow,
    overflow => overflow
  );

end Behavioral;

