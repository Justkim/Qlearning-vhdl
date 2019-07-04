----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:36:03 06/27/2019 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
generic( n : INTEGER range 0 to 10000);
Port (     clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
			  rco : out  STD_LOGIC);

end counter;

architecture Behavioral of counter is
signal counter: INTEGER range 0 to 10000:=0;
signal rco_sig : std_logic := '0';
begin

process(clk)
begin
	if rising_edge(clk) then
		if reset='1' then
			counter<=0;
		else
			if counter=n-1 then
				counter<=0;
				rco_sig<='1';
			else
				counter<=counter+1;
				rco_sig<='0';
			end if;
		end if;
	end if;
	report "NN is" & integer'image(counter);
end process;

rco<= rco_sig;
	
end Behavioral;

