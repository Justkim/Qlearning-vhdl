-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  
  library ieee_proposed;
use ieee_proposed.float_pkg.all;

  ENTITY train_tb_1 IS
  END train_tb_1;

  ARCHITECTURE behavior OF train_tb_1 IS 

  
  COMPONENT train is
    Port (
			  clk: in STD_LOGIC;
			  reset: in std_logic;
			  cur_state: out integer range 0 to 8;
			  stop : out  STD_LOGIC;
			  	finish1 : out std_logic
			  );
end COMPONENT;

          SIGNAL clk:  std_logic:='0';
			 signal reset :std_logic:='1';
          SIGNAL cur_state :  integer;
          signal stop : std_logic;
			 signal finish1 : std_logic;

  BEGIN

  -- Component Instantiation
          uut: train PORT MAP(clk,reset,cur_state,stop,finish1
          );
			 
			 
			clk<= not clk after 50ns;
			reset<='0' after 100ns;
			
			
			


 

  END;
