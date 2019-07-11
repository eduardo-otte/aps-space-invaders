LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use work.integer_vector.all;

Entity enemy_colision_controller IS
	GENERIC(
		NUM_MAX_ENEMY: INTEGER RANGE 0 TO 100 := 64;
		ENEMY_SIZE: INTEGER RANGE -10 TO 1200 := 80;
		SHOT_WIDTH: INTEGER RANGE -10 TO 1200 := 10;
		SHOT_HEIGHT: INTEGER RANGE -10 TO 1200 := 80
	);
	port(
		clk : IN STD_LOGIC;
		shot_x_p1, shot_y_p1, shot_x_p2, shot_y_p2: IN INTEGER RANGE -10 TO 1200;
		enemy_ships_x, enemy_ships_y: IN INTEGER_VECTOR (NUM_MAX_ENEMY-1 downto 0);

		enemy_ship_hit, enemy_ship_shot_hit: OUT INTEGER RANGE -10 TO 100;
		enemy_ship_hit_p1, enemy_ship_hit_p2: OUT STD_LOGIC
	);
END entity;

Architecture arch OF enemy_colision_controller IS
BEGIN
	process(clk)
		variable enemy_ship_hit_success: INTEGER RANGE -10 TO 100 := -1;
		variable enemy_ship_hit_p1_success : STD_LOGIC := '0';
		variable enemy_ship_hit_p2_success : STD_LOGIC := '0';
		
		begin
			if rising_edge(clk) then
				for j in 0 to NUM_MAX_ENEMY-1 loop
					-- Player 1 shoot
					if shot_x_p1 > enemy_ships_x(j) and shot_x_p1 < enemy_ships_x(j)+ ENEMY_SIZE-SHOT_WIDTH and shot_y_p1 > enemy_ships_y(j) and shot_y_p1 < enemy_ships_y(j)+ENEMY_SIZE-SHOT_HEIGHT then
						enemy_ship_hit_p1_success := '1';
						enemy_ship_hit_success := j;
					-- Player 2 shoot
					elsif shot_x_p2 > enemy_ships_x(j) and shot_x_p2 < enemy_ships_x(j)+ ENEMY_SIZE-SHOT_WIDTH and shot_y_p2 > enemy_ships_y(j) and shot_y_p2 < enemy_ships_y(j)+ENEMY_SIZE-SHOT_HEIGHT then
						enemy_ship_hit_p2_success := '1';
						enemy_ship_hit_success := j;
					end if;
				end loop;
			end if;	
			
			enemy_ship_hit <= enemy_ship_hit_success;
			enemy_ship_hit_p1 <= enemy_ship_hit_p1_success;
			enemy_ship_hit_p2 <= enemy_ship_hit_p2_success;		
	end process; 	
	enemy_ship_shot_hit <= 0;
END Architecture;