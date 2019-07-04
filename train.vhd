----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:41:21 06/18/2019 
-- Design Name: 
-- Module Name:    train - Behavioral 
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
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity train is
    Port (
			  clk: in STD_LOGIC;
			  reset: in std_logic;
			  cur_state: out integer range 0 to 8;
			  stop : out std_logic;
			  finish1: out std_logic);
end train;

architecture Behavioral of train is

component checkEnd
	
    Port ( clk : in std_logic;
		state : in integer range 0 to 8;
	   finish : out  STD_LOGIC;
		reset : in std_logic
	 );
end component;

component counter is
generic( n : INTEGER range 0 to 10000 := 100);
Port (     clk : in  STD_LOGIC;
			  reset : in  STD_LOGIC;
			  rco : out  STD_LOGIC);
end component;

component logic is
port (clk: in STD_LOGIC;
		stop: in STD_LOGIC;
		out_state : out integer range 0 to 8);
end component;

signal end_sig : std_logic:='0';
signal rco : std_logic:='0';
signal cur_state_sig : integer range 0 to 8 := 0;

begin

u1: logic port map(clk,rco,cur_state_sig);
u2: checkEnd port map(clk=>clk, state=>cur_state_sig,finish=>end_sig, reset=>reset);
u3:counter generic map (8) port map(end_sig, reset, rco);


cur_state <= cur_state_sig;
stop <= rco;
finish1 <= end_sig;

end Behavioral;

