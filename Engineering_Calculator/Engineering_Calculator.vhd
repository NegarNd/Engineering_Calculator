----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:55 08/17/2016 
-- Design Name: 
-- Module Name:    Engineering_Calculator - Behavioral 
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

entity Engineering_Calculator is port
(
clk , reset : in std_logic;
num1 , num2  : in std_logic_vector(7 downto 0);
operation : std_logic_vector(4 downto 0);
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end Engineering_Calculator;

architecture Behavioral of Engineering_Calculator is


component Sin_mainCode is port(
 clk , reset: in  STD_LOGIC;
           phase : in  STD_LOGIC_VECTOR (7 downto 0);
           sin : out  STD_LOGIC_VECTOR (7 downto 0);
			  error : out STD_LOGIC
			  );
end component;

component Cos_mainCode is port (
clk , reset: in  STD_LOGIC;
           phase : in  STD_LOGIC_VECTOR (7 downto 0);
           cos : out  STD_LOGIC_VECTOR (7 downto 0);
			  error : out STD_LOGIC
			  );
end component;

component Tan_mainCode is port
(
clk, reset : in std_logic;
phase : in std_logic_vector(7 downto 0 );
tan : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component Sinh_mainCode is port
(
clk , reset  :in std_logic;
phase : in std_logic_vector(7 downto 0);
sinh : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component Cosh_mainCode is port
(
clk , reset  :in std_logic;
phase : in std_logic_vector(7 downto 0);
cosh : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component tanh_mainCode is port
(
clk, reset:in std_logic;
phase : in std_logic_vector(7 downto 0);
tanh : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component cot_mainCode is port
(
clk, reset : in std_logic;
phase : in std_logic_vector(7 downto 0 );
cot : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;



component adder_mainCode is port 
(
num1 , num2 : in std_logic_vector(7 downto 0);
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

component divider_mainCode is port
(num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component Factorial is port
(
x : std_logic_vector(7 downto 0);
clk , reset: in std_logic;
factorial : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;


component power is port
(
base : in std_logic_vector(7 downto 0);
power : in std_logic_vector(7 downto 0);
clk, reset : in std_logic;
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

component remainder is port
(
num1 , num2 : in std_logic_vector(7 downto 0);
clk ,reset : in std_logic;
mode : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component powerOfTen is port
(
powerTen : in std_logic_vector(7 downto 0);
clk, reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

component squareRoot_mainCode is port
(
num1: in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
squareRoot : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;


signal sinR , cosR , tanR , cotR , sinhR , coshR , tanhR , addR , subR ,multiR , dividR , rootR , factorialR ,  remainderR ,powerR , powerTenR: std_logic_vector(7 downto 0);
signal sinE , cosE ,  tanE , cotE , sinhE , coshE , tanhE , addE , subE ,multiE,dividE , rootE , factorialE ,  multiRdy , remainderE , powerE , powerTenE :std_logic;
signal resultS : std_logic_vector(7 downto 0);
begin

sinINST : sin_mainCode port map(clk, reset , num1 , sinR , sinE);
cosINST : cos_mainCode port map(clk, reset , num1 , cosR , cosE);
tanINST : tan_mainCode port map(clk, reset , num1 , tanR , tanE);
cotINST : cot_mainCode port map(clk, reset , num1 , cotR , cotE);
sinhINST : sinh_mainCode port map(clk, reset , num1 , sinhR , sinhE);
coshINST : cosh_mainCode port map(clk, reset , num1 , coshR , coshE);
tanhINST : tanh_mainCode port map(clk, reset , num1 , tanhR , tanhE);
addINST : adder_mainCode port map(num1 , num2 , clk, reset , addR,addE);
subINST : Subtractor_mainCode port map(num1 , num2 , clk, reset,subR,subE);
multiINST : multiplier_mainCode port map(num1 , num2 , clk, reset , multiR,multiE , multiRdy);
dividINST : divider_mainCode port map(num1,num2 , clk, reset,dividR, dividE);
remainderINST : remainder port map (num1 , num2 , clk, reset, remainderR, remainderE);
powerINST : power port map(num1 , num2 , clk, reset , powerR , powerE);
powerOfTenINST : powerOfTen port map(num1 , clk, reset , powerTenR, powerTenE);
rootINST : squareRoot_mainCode port map(num1,clk, reset, rootR, rootE);
factorialINST : factorial port map(num1, clk, reset, factorialR, factorialE);
	
	process(clk, reset)
	variable errorV : std_logic;
	begin
		if(reset ='1') then
				errorV := '0';
		elsif(clk'event and clk= '1') then
			
			case operation is 
				when "00000" =>
					resultS <= sinR;
					errorV := sinE;
				when "00001" =>
					resultS <=cosR ;
					errorV := cosE;
				when "00010" =>
					resultS <= tanR;
					errorV := tanE;
				when "00011" =>
					resultS <= cotR ;
					errorV := cotE;
				when "00100" =>
					resultS <=sinhR ;
					errorV := sinhE ;
				when "00101" =>
					resultS <=coshR ;
					errorV := coshE;
				when "00110" =>
					resultS <= tanhR;
					errorV := tanhE;
				when "00111" =>
					resultS <= addR;
					errorV := addE;
				when "01000" =>
					resultS <=subR ;
					errorV := subE;
				when "01001" =>
					resultS <=multiR ;
					errorV := multiE;
				when "01010" =>
					resultS <= dividR;
					errorV := dividE;
				when "01011" =>
					resultS <= remainderR ;
					errorV := remainderE;
				when "01100" =>
					resultS <=powerR ;
					errorV := powerE ;
				when "01101" =>
					resultS <= powerTenR ;
					errorV := powerTenE;
				when "01110" =>
					resultS <=rootR ;
					errorV := rootE;
				when "01111" =>
					resultS <=factorialR ;
					errorV := factorialE;
				when others =>
					errorV := '1';
		 end case;
		end if;
		 error<= errorV;
		 result <= resultS;
end process;
	
end Behavioral;

