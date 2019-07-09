LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use work.integer_vector.all;

Entity enemy_ship_controller IS
	generic (
		NUM_MAX_ENEMY: INTEGER := 64;
		NUM_MAX_ENEMY_PER_LINE: INTEGER := 8;
		DISPLAY_HIGH: INTEGER := 900;
		PX_BOARDER_LEFT: INTEGER := 90;
		PX_BORDA_TOP: INTEGER := 130;
		PX_BORDA_BOTTON: INTEGER := 130;
		ENEMY_SIZE: INTEGER := 80;
		NUMBER_OF_HORIZONTAL_JUMPS: INTEGER := 5;
		PX_PER_HORIZONTAL_JUMP: INTEGER := 10;
		LINES_IN_Y_AT_LV1: INTEGER := 2;
		LINES_IN_Y_AT_LV2: INTEGER := 4;
		LINES_IN_Y_AT_LV3: INTEGER := 6;
		NUMBER_OF_LEVELS: INTEGER := 3
	);
	port(	
		clk : IN std_LOGIC;
		enemy_ship_clock:   	IN STD_LOGIC;
		level, enemy_ship_hit:  IN INTEGER;

		enemy_ships_x: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		enemy_ships_y: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		living_ships : 			OUT INTEGER;
		enemy_in_base: 			OUT STD_LOGIC
	);
END entity;

Architecture arch OF enemy_ship_controller IS
BEGIN
	process(clk, enemy_ship_clock)
		variable last_level: integer := NUMBER_OF_LEVELS+1; -- This number has to be out of number of level of the game
		variable should_go_right: std_logic := '0'; -- 0 means to go right and 1 to 
		variable jumps_horizontaly_done: integer := 0;
		-- 
		variable volatile_enemy_ships_x : INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		variable volatile_enemy_ships_y : INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		variable volatile_living_ships: integer := 0;
		variable volatile_enemy_in_base: STD_LOGIC := '0';
		begin
			if rising_edge(clk) then
				-- Creates a new level
				IF level /= last_level then
					last_level := level;
					if level = 1 then
						for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
							for j in 0 to LINES_IN_Y_AT_LV1-1 loop
								volatile_enemy_ships_x((LINES_IN_Y_AT_LV1*i)+j) := PX_BOARDER_LEFT+(ENEMY_SIZE*i);
								volatile_enemy_ships_y((LINES_IN_Y_AT_LV1*i)+j) := 900-(PX_BOARDER_LEFT+(ENEMY_SIZE*j));
							end loop;
						end loop;
						volatile_living_ships := LINES_IN_Y_AT_LV1*NUM_MAX_ENEMY_PER_LINE;
						should_go_right := '0';
					elsif level = 2 then
						for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
							for j in 0 to LINES_IN_Y_AT_LV2-1 loop
								volatile_enemy_ships_x((LINES_IN_Y_AT_LV2*i)+j) := PX_BOARDER_LEFT+(ENEMY_SIZE*i);
								volatile_enemy_ships_y((LINES_IN_Y_AT_LV2*i)+j) := 900-(PX_BOARDER_LEFT+(ENEMY_SIZE*j));
							end loop;
						end loop;
						volatile_living_ships := LINES_IN_Y_AT_LV2*NUM_MAX_ENEMY_PER_LINE;
						should_go_right := '0';
					elsif level = 3 then
						for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
							for j in 0 to LINES_IN_Y_AT_LV1-1 loop
								volatile_enemy_ships_x((LINES_IN_Y_AT_LV2*i)+j) := PX_BOARDER_LEFT+(ENEMY_SIZE*i);
								volatile_enemy_ships_y((LINES_IN_Y_AT_LV2*i)+j) := 900-(PX_BOARDER_LEFT+(ENEMY_SIZE*j));
							end loop;
						end loop;
						volatile_living_ships := LINES_IN_Y_AT_LV3*NUM_MAX_ENEMY_PER_LINE;
						should_go_right := '0';
					elsif level = 0 then
						for i in 0 to NUM_MAX_ENEMY-1 loop
							if volatile_enemy_ships_y(i) /= -1 then
								volatile_enemy_ships_y(i) := -1;
							end if;
						end loop;
						volatile_living_ships := 0;
						should_go_right := '0';
					end if;
				end if;
				-- Movement for each enemy_ship_clock
				if enemy_ship_clock = '1' then
					-- Downward jump code
					if jumps_horizontaly_done > NUMBER_OF_HORIZONTAL_JUMPS-1 then
						for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
							-- Check if the ship is alive
							if volatile_enemy_ships_y(i) > 0 then
								-- Ships jump down
								volatile_enemy_ships_y(i) := volatile_enemy_ships_y(i) - ENEMY_SIZE;
							end if;
							-- Detection of ship getting to the player
							if volatile_enemy_ships_y(i) < PX_BORDA_BOTTON then
								volatile_enemy_in_base := '1';
							end if;
						end loop;
						jumps_horizontaly_done := 0;
						should_go_right := not should_go_right;
					else
					-- Horizontal jump code
						if should_go_right = '1' then
							jumps_horizontaly_done := jumps_horizontaly_done +1;
							for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
								if volatile_enemy_ships_x(i) > 0 then
									volatile_enemy_ships_x(i) := volatile_enemy_ships_x(i) + PX_PER_HORIZONTAL_JUMP;
								end if;
							end loop;
						else 
							jumps_horizontaly_done := jumps_horizontaly_done +1;
							for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
								if volatile_enemy_ships_x(i) > 0 then
									volatile_enemy_ships_x(i) := volatile_enemy_ships_x(i) - PX_PER_HORIZONTAL_JUMP;
								end if;
							end loop;
						end if;
					end if;
				end if;
			end if;
			
			enemy_ships_x <= volatile_enemy_ships_x;
			enemy_ships_y <= volatile_enemy_ships_y;
			living_ships <= volatile_living_ships; -- Falta ir recalculando
			enemy_in_base <= volatile_enemy_in_base;
	end process; 
		
END Architecture;
