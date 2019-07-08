LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

Entity enemy_colision_controler IS
	port(
		game_rst: 				 		IN STD_LOGIC; -- Acho que precisa deste caso para resetar as naves ou coisas do tipo
		shot_x_p1, shot_y_p1, shot_x_p2, shot_y_p2: IN INTEGER;
		-- Need to import to this component what is integer_vector
		enemy_ships_x, enemy_ships_y: 	IN INTEGER_VECTOR;

		enemy_ship_hit: OUT INTEGER;
		enemy_ship_hit_p1, enemy_ship_hit_p2: OUT STD_LOGIC
	);
END entity;

Architecture arch OF enemy_colision_controler IS
BEGIN
	process(game_rst, shot_x_p1, shot_x_p2, enemy_ships_x, enemy_ships_y)
		
		-- TODO
	
	end process; 
		
END Architecture;