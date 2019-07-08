library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

PACKAGE INTEGER_VECTOR IS
	type INTEGER_VECTOR is array (integer range<>) of integer range -10 to 1000;
END PACKAGE;