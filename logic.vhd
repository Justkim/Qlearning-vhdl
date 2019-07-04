----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:06 06/27/2019 
-- Design Name: 
-- Module Name:    logic - Behavioral 
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
use ieee.math_real.uniform;
use ieee.math_real.floor;

use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
library ieee_proposed;
use ieee_proposed.float_pkg.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic is
port (clk: in STD_LOGIC;
		stop: in STD_LOGIC;
		out_state : out integer range 0 to 8
		);
end logic;



architecture Behavioral of logic is

type array_grid is array (0 to 8) of float(8 downto -23);
type q_array is array (0 to 35) of float( 8 downto -23);
type actions_type is array (0 to 8) of std_logic_vector(0 to 3);


signal w: float (8 downto -23);
signal rewards: array_grid;
signal actions: actions_type;

constant landa: float(8 downto -23):= to_float(0.99,w);
constant alpha: float(8 downto -23):= to_float(0.5,w);



procedure get_max_q(q: in q_array; state: in integer; actions: in STD_LOGIC_VECTOR(3 downto 0);max_q: out float(8 downto -23);best_action: out integer ) is 
variable max_temp : float(8 downto -23) := q(state*4);
begin
for j in actions'range loop
	report "actions: " & std_logic'image(actions(j));
end loop;

for i in 0 to 3 loop
 if actions(3-i)='1' then 
 report "action checked: " & integer'image(i);
 if max_temp<=q(state*4 + i) then 
	max_temp:=q(state*4 + i);
	best_action:=i;
	end if;
end if;
end loop;
max_q := max_temp;
end procedure;



procedure get_next_state(cur_state: in integer;action: in integer; next_state: out integer) is 
variable temp_next_state : integer range 0 to 8;

begin

	if cur_state = 0 then
		if action = 0 then
			temp_next_state := 3;
		else
			if action = 3 then
				temp_next_state := 1;
			end if;
		end if;
	end if;	
	
	if cur_state = 2 then
		if action = 0 then
			temp_next_state := 5;
		else
			if action = 2 then
				temp_next_state := 1;
			end if;
		end if;
	end if;
	
	if cur_state = 6 then
		if action = 1 then
			temp_next_state := 3;
		else
			if action = 3 then
				temp_next_state := 7;
			end if;
		end if;	
	end if;

	if cur_state = 1 then
		if action = 0 then
			temp_next_state := 4;
		else
			if action = 3 then
				temp_next_state := 2;
			else
				if action = 2 then
					temp_next_state := 0;
				end if;
			end if;
		end if;
	end if;

	if cur_state = 3 then
		if action = 0 then
			temp_next_state := 6;
		else
			if action = 3 then
				temp_next_state := 4;
			else
				if action = 1 then
					temp_next_state := 0;
				end if;
			end if;
		end if;
	end if;
	
	if cur_state = 5 then
		if action = 0 then
			temp_next_state := 8;
		else
			if action = 2 then
				temp_next_state := 4;
			else
				if action = 1 then
					temp_next_state := 2;
				end if;
			end if;
		end if;
	end if;
	
	if cur_state = 7 then
		if action = 2 then
			temp_next_state := 6;
		else
			if action = 1 then
				temp_next_state := 4;
			else
				if action = 3 then
					temp_next_state := 8;
				end if;
			end if;
		end if;
	end if;

	if cur_state = 4 then
		if action = 0 then
			temp_next_state := 7;
		else
			if action = 1 then
				temp_next_state := 1;
			else
				if action = 2 then
					temp_next_state := 3;
				else
					if action = 3 then
						temp_next_state := 5;
					end if;
				end if;
			end if;
		end if;
	end if;	
	next_state := temp_next_state;	
end procedure;				


begin
rewards <= (to_float(0.0,w),to_float(0.0,w),to_float(0.0,w),to_float(0.0,w),to_float(-1.0,w),to_float(0.0,w),to_float(0.0,w),to_float(0.0,w),to_float(1.0,w));


--action index =0 : up
--action index =1 : down
--action index =2 : left
--action index =3 : right

actions <= ("1001","1011","1010","1101","1111","1110","0101","0111","0110");


process(clk) 
	variable x : real;
	variable random_num : float(8 downto -23);
	variable rand_action : integer;
	variable epsilon : float(8 downto -23) := to_float(100.0, w);
	variable decay_rate: float(8 downto -23) := to_float(1.0, w);
	variable temp_q: float( 8 downto -23):=to_float(0.0,w);
	variable temp_best_action: integer range 0 to 4:=0;
	variable step_reward: float(8 downto -23) := to_float(-0.01, w);
	
	variable temp_q_next: float( 8 downto -23):=to_float(0.0,w);
	variable temp_best_action_next: integer range 0 to 4:=0;
	
	variable next_state_var: integer range 0 to 8:=0;
	
	variable seed1 : positive:=1;
	variable seed2 : positive:=1;
	
	variable action : integer range 0 to 8 := 0;
	variable cur_state : integer range 0 to 8:= 0;
	variable next_state : integer range 0 to 8:= 0;
	variable q_table : q_array := (others => to_float(0.0, w));
	
	variable cur_reward: float(8 downto -23);
	variable instance: float(8 downto -23);

	
	begin
	---epsilon:= to_float(100,epsilon);
	--decay_rate:= to_float(1,decay_rate);


	if rising_edge(clk) then
		
		assert stop = '0' report "unexpected value for stop" & integer'image(conv_integer(stop));
		if(stop ='0') then
			report "stop =  " & std_logic'image(stop);
			
			if (cur_state = 8) then
				report "YOU WIN!";
				cur_state := 0;
			
			elsif (cur_state = 4) then
				report "GAME OVER!";
				cur_state := 0;
			else
			
			-- generating random 
			
		---	seed1:=1;
		---	seed2:=1;
			uniform(seed1, seed2, x);
			random_num := to_float(integer(floor(x * 100.0)), random_num );
			report "Random number in 0 .. 100: " & integer'image(integer(floor(x * 100.0)));
			report "epsilon*decay rate " & real'image(to_real(epsilon*decay_rate));
			
			assert TO_REAL(random_num) < to_real(epsilon*decay_rate) report "go for EXPLORATION";
			if(random_num < epsilon*decay_rate) then
				uniform(seed1, seed2, x);
				report "EXPLORATION "; 
				
				--action =0 : up
				--action =1 : down
				--action =2 : left
				--action =3 : right

				
				if cur_state = 0 then
					report "0";
					rand_action := integer(floor(x * 2.0));
					report "rand action isss" & integer'image(rand_action);
					if rand_action = 0 then
						report "rand action 0 choosed";
						next_state := 3;
						action := 0;
						
					else
						if rand_action = 1 then
						report "rand action 1 choosed";
							next_state := 1;
							action := 3;
						end if;
					end if;
				end if;
				
				if cur_state = 2 then
					report "2";
					rand_action := integer(floor(x * 2.0));
					if rand_action = 0 then
						next_state := 5;
						action := 0;
					else
						if rand_action = 1 then
							next_state := 1;
							action := 2;
						end if;
					end if;
				end if;
				
				if cur_state = 6 then
					report "6";
					rand_action := integer(floor(x * 2.0));
					if rand_action = 0 then
					next_state := 3;
					action := 1;
					else
						if rand_action = 1 then
							next_state := 7;
							action := 3;
						end if;
					end if;	
				end if;
				

				
				if cur_state = 1 then
					report "1";
					rand_action := integer(floor(x * 3.0));
					if rand_action = 0 then
						next_state := 4;
						action := 0;
					else
						if rand_action = 1 then
							next_state := 2;
							action := 3;
						else
							if rand_action = 2 then
								next_state := 0;
								action := 2;
							end if;
						end if;
					end if;
				end if;
				
				if cur_state = 3 then
					report "3";
					rand_action := integer(floor(x * 3.0));
					if rand_action = 0 then
						next_state := 6;
						action := 0;
					else
						if rand_action = 1 then
							next_state := 4;
							action := 3;
						else
							if rand_action = 2 then
								next_state := 0;
								action := 1;
							end if;
						end if;
					end if;
				end if;
				
				if cur_state = 5 then
					report "5";
					rand_action := integer(floor(x * 3.0));
					if rand_action = 0 then
						next_state := 8;
						action := 0;
					else
						if rand_action = 1 then
							next_state := 4;
							action := 2;
						else
							if rand_action = 2 then
								next_state := 2;
								action := 1;
							end if;
						end if;
					end if;
				end if;
				
				if cur_state = 7 then
					report "7";
					rand_action := integer(floor(x * 3.0));
					if rand_action = 0 then
						next_state := 6;
						action := 2;
					else
						if rand_action = 1 then
							next_state := 4;
							action := 1;
						else
							if rand_action = 2 then
								next_state := 8;
								action := 3;
							end if;
						end if;
					end if;
				end if;


				if cur_state = 4 then
					report "4";
					
					rand_action := integer(floor(x * 4.0));
					if rand_action = 0 then
						next_state := 7;
						action := 0;
					else
						if rand_action = 1 then
							next_state := 1;
							action := 1;
						else
							if rand_action = 2 then
								next_state := 3;
								action := 2;
							else
								if rand_action = 3 then
									next_state := 5;
									action := 3;
								end if;
							end if;
						end if;
					end if;
				end if;
				 	report "rand action " & integer'image(rand_action);
			
				
				else
					
					report "!!!EXPLOTATION " ;
					report "cur_state@@@@" & integer'image(cur_state);
					get_max_q(q_table,cur_state,actions(cur_state),temp_q,temp_best_action);
					action :=temp_best_action;
					get_next_state(cur_state,temp_best_action,next_state_var);
					next_state:=next_state_var;

				
			end if;
			
				report "cur state " & integer'image(cur_state);
				
		   
				
				report "action choosen " & integer'image(action);
			
			cur_reward:= rewards(next_state) + step_reward;
			report "rewards(next_statr) is " & real'image(to_real(rewards(next_state)));
			report "cur reward" & real'image(to_real(cur_reward));
			get_max_q(q_table,next_state,actions(next_state),temp_q_next,temp_best_action_next);
			
			instance:=cur_reward + landa * temp_q_next; 
			
			q_table(cur_state*4+action):=(1-alpha)*q_table(cur_state*4+action) + alpha*(instance);
			report "instance updated " & real'image(to_real(instance));
			report "q updated " & real'image(to_real(q_table(cur_state*4+action)));
			
			
			
			if decay_rate>to_float(0.01,w) then 
				report "DECAY RATE DECREASED";
				decay_rate:=decay_rate - to_float(0.05,w);
			end if;
			cur_state := next_state;
			report "next state" & integer'image(next_state);
		
		end if;
		
		
	end if;
	
	end if;

out_state<= cur_state;	
end process;
				
			
end Behavioral;



