----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:14:28 07/02/2019 
-- Design Name: 
-- Module Name:    testing - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.uniform;
use ieee.math_real.floor;

use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testing is
end testing;

architecture Behavioral of testing is

signal A, B, Y : float (8 downto -23) ;


begin

Y <= A + B;
Y <= A * B;

end Behavioral;

