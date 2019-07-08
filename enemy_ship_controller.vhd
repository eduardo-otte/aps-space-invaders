LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

Entity enemy_ship_controler IS
	port(	
		game_rst: 				IN STD_LOGIC -- Acho que precisa deste caso para resetar as naves ou coisas do tipo
		enemy_ship_clock:   	IN STD_LOGIC;
		level, enemy_ship_hit:  IN INTEGER;

		-- Need to import to this component what is integer_vector
		enemy_ships_x: 			OUT INTEGER_VECTOR;
		enemy_ships_y: 			OUT INTEGER_VECTOR;
		living_ships : 			OUT INTEGER;
		enemy_in_base: 			OUT STD_LOGIC
	);
END entity;

Architecture arch OF enemy_ship_controler IS
BEGIN
	process(game_rst, enemy_ship_clock, level, enemy_ship_hit)
		
		-- TODO
	
	end process; 
		
END Architecture;