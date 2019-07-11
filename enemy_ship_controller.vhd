LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use work.integer_vector.all;

Entity enemy_ship_controller IS
	generic (
		CLK_RATE : INTEGER := 50000000;
		TEMPO_MOVE_ENEMY_MIN_MS : INTEGER RANGE -10 TO 1200 := 200;
		NUM_MAX_ENEMY: INTEGER RANGE -10 TO 1200 := 64;
		NUM_MAX_ENEMY_PER_LINE: INTEGER RANGE 0 TO 10 := 8;
		DISPLAY_HIGH: INTEGER RANGE -10 TO 1200 := 900;
		PX_BOARDER_LEFT: INTEGER RANGE -10 TO 1200 := 90;
		PX_BORDA_TOP: INTEGER RANGE -10 TO 1200 := 130;
		PX_BORDA_BOTTON: INTEGER RANGE -10 TO 1200 := 130;
		ENEMY_SIZE: INTEGER RANGE 0 TO 100 := 80;
		NUMBER_OF_HORIZONTAL_JUMPS: INTEGER RANGE -10 TO 1200 := 20;
		PX_PER_HORIZONTAL_JUMP: INTEGER RANGE -10 TO 1200 := 20;
		LINES_IN_Y_AT_LV1: INTEGER RANGE 0 TO 8 := 2;
		LINES_IN_Y_AT_LV2: INTEGER RANGE 0 TO 8 := 4;
		LINES_IN_Y_AT_LV3: INTEGER RANGE 0 TO 8 := 6;
		NUMBER_OF_LEVELS: INTEGER RANGE 0 TO 5 := 3
	);
	port(	
		clk : IN std_LOGIC;
		enemy_ship_clock:   	IN STD_LOGIC;
		level:  IN INTEGER RANGE 0 TO 5;
		enemy_ship_hit:  IN INTEGER RANGE -10 TO 100;

		enemy_ships_x: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		enemy_ships_y: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		living_ships : 			OUT INTEGER RANGE 0 TO 100;
		enemy_in_base: 			OUT STD_LOGIC
	);
END entity;

Architecture arch OF enemy_ship_controller IS
signal last_level: INTEGER RANGE 0 TO 5 := NUMBER_OF_LEVELS+1;
constant tempo_minimo_move_enemy : INTEGER := TEMPO_MOVE_ENEMY_MIN_MS * (CLK_RATE / 1000);
BEGIN
	process(clk, enemy_ship_clock)
		variable contador_tempo_ship : INTEGER := 0;
		--variable last_level: INTEGER RANGE 0 TO 5 := NUMBER_OF_LEVELS+1; -- This number has to be out of number of level of the game
		variable should_go_right: std_logic := '1'; -- 0 means to go right and 1 to 
		variable jumps_horizontaly_done: INTEGER RANGE -10 TO 1200 := 0;
		-- 
		variable display_updated: std_logic := '0';
		variable volatile_enemy_ships_x : INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		variable volatile_enemy_ships_y : INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		variable volatile_living_ships: INTEGER RANGE 0 TO 100 := 0;
		variable volatile_enemy_in_base: STD_LOGIC := '0';
		begin
			if rising_edge(clk) then
				-- Creates a new level
				IF level /= last_level then
					last_level <= level;
					if level = 1 then
						for i in 0 to NUM_MAX_ENEMY-1 loop
							if volatile_enemy_ships_y(i) /= -1 then
								volatile_enemy_ships_y(i) := -1;
								volatile_enemy_ships_x(i) := -1;
							end if;
						end loop;
						volatile_enemy_ships_x(0) := 1*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(1) := 2*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(2) := 3*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(3) := 1*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(4) := 2*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(5) := 3*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(6) := 1*(ENEMY_SIZE+20);
						volatile_enemy_ships_x(7) := 2*(ENEMY_SIZE+20);
						--volatile_enemy_ships_x(8) := 3*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(0) := 1*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(1) := 1*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(2) := 1*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(3) := 2*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(4) := 2*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(5) := 2*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(6) := 3*(ENEMY_SIZE+20);
						volatile_enemy_ships_y(7) := 3*(ENEMY_SIZE+20);
						--volatile_enemy_ships_y(8) := 3*(ENEMY_SIZE+20);
						
						volatile_living_ships := LINES_IN_Y_AT_LV1*NUM_MAX_ENEMY_PER_LINE;
						should_go_right := '0';
					elsif level = 0 then
						for i in 0 to NUM_MAX_ENEMY-1 loop
							if volatile_enemy_ships_y(i) /= -1 then
								volatile_enemy_ships_y(i) := -1;
								volatile_enemy_ships_x(i) := -1;
							end if;
						end loop;
						volatile_living_ships := 0;
						should_go_right := '0';
					end if;
				end if;
					-- Movement for each enemy_ship_clock
				IF contador_tempo_ship > tempo_minimo_move_enemy THEN
					-- Downward jump code
					if jumps_horizontaly_done >= NUMBER_OF_HORIZONTAL_JUMPS then
						for i in 0 to NUM_MAX_ENEMY_PER_LINE-1 loop
							-- Check if the ship is alive
							if volatile_enemy_ships_y(i) > 0 then
								-- Ships jump down
								volatile_enemy_ships_y(i) := volatile_enemy_ships_y(i) + ENEMY_SIZE;
							end if;
							-- Detection of ship getting to the player
							if volatile_enemy_ships_y(i) > DISPLAY_HIGH - PX_BORDA_BOTTON then
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
					contador_tempo_ship := 0;
				ELSE
					contador_tempo_ship := contador_tempo_ship +1;
				END IF;
			end if;
			
			enemy_ships_x <= volatile_enemy_ships_x;
			enemy_ships_y <= volatile_enemy_ships_y;
			living_ships <= volatile_living_ships; -- Falta ir recalculando
			enemy_in_base <= volatile_enemy_in_base;
	end process; 
		
END Architecture;
