LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

Entity enemy_shot_controler IS
	port(	
		game_rst: 				 		IN STD_LOGIC; -- Acho que precisa deste caso para resetar as naves ou coisas do tipo
		enemy_clock, shot_clock: 		IN STD_LOGIC;
		-- Need to import to this component what is integer_vector
		enemy_ships_x, enemy_ships_y: 	IN INTEGER_VECTOR;

		-- Need to import to this component what is integer_vector
		enemy_shots_x: 			OUT INTEGER_VECTOR; -- Should be std_logic_vector, I think
		enemy_shots_y: 			OUT INTEGER_VECTOR -- Should be std_logic_vector, I think
	);
END entity;

Architecture arch OF enemy_shot_controler IS
BEGIN
	process(game_rst, enemy_clock, shot_clock, enemy_ship_hit)
		
		-- TODO
	
	end process; 
		
END Architecture;