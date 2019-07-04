----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:43:05 06/27/2019 
-- Design Name: 
-- Module Name:    checkEnd - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity checkEnd is
	 
    Port ( clk : in std_logic;
		 state : in integer range 0 to 8;
		 finish : out  STD_LOGIC;
		 reset : in std_logic
	 );
end checkEnd;

architecture Behavioral of checkEnd is
begin

finish <= '1' when state = 8 else      --reach the goal
			 '1' when state = 4 else		--fall into the hole
			 '0';




 

end Behavioral;

