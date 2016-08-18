----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:08 08/17/2016 
-- Design Name: 
-- Module Name:    powerOfTen - Behavioral 
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

entity powerOfTen is port
(
powerTen : in std_logic_vector(7 downto 0);
clk, reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end powerOfTen;

architecture Behavioral of powerOfTen is

component power is port
(
base : in std_logic_vector(7 downto 0);
power : in std_logic_vector(7 downto 0);
clk, reset : in std_logic;
result : out std_logic_vector(7 downto 0);
error : out std_logic
);
end component;



begin

powerINS : power port map("01010010" , powerTen , clk, reset , result ,error); 

end Behavioral;

