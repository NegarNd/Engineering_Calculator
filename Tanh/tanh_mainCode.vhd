----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:25:46 08/12/2016 
-- Design Name: 
-- Module Name:    tanh_mainCode - Behavioral 
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

entity tanh_mainCode is port
(
clk, reset:in std_logic;
phase : in std_logic_vector(7 downto 0);
tanh : out std_logic_vector(7 downto 0);
error : out std_logic
);
end tanh_mainCode;

architecture Behavioral of tanh_mainCode is

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

component divider_mainCode is port
(num1 , num2 : in std_logic_vector(7 downto 0);
clk , reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;

signal cosh , sinh , division : std_logic_vector(7 downto 0);
signal coshError , sinhError , dividerError : std_logic;
begin
	coshComponent : Cosh_mainCode port map(clk, reset , phase , cosh , coshError);
	sinhComponent : Sinh_mainCode port map(clk, reset , phase , sinh , sinhError);
	TanhdividerComponent : divider_mainCode port map(sinh , cosh , clk ,reset , tanh , dividerError);
	error<= dividerError or coshError or sinhError;


end Behavioral;

