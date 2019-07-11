LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use work.integer_vector.all;

Entity enemy_shoot_controller IS
	generic (
		NUM_MAX_SHOOT: INTEGER RANGE -10 TO 1200 := 15;
		NUM_MAX_ENEMY: INTEGER RANGE -10 TO 1200 := 36;
		NUMBER_OF_LEVELS: INTEGER RANGE 0 TO 5 := 3
	);
	port(	
		clk : IN std_LOGIC;
		enemy_clock, shot_clock: 		IN STD_LOGIC;
		enemy_ships_x, enemy_ships_y: 	IN INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
		level:  IN INTEGER RANGE 0 TO 5;

		enemy_shots_x: 					OUT INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0);
		enemy_shots_y: 					OUT INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0)
	);
END entity;

Architecture arch OF enemy_shoot_controller IS
BEGIN
	process(clk)
		variable current_enemy_x_position: INTEGER RANGE -10 TO 1200 := 0;
		variable current_enemy_y_position: INTEGER RANGE -10 TO 1200:= 0;
		variable last_level: integer := NUMBER_OF_LEVELS+1; -- This number has to be out of number of level of the game
		variable number_of_shoots_at_screen: integer := 0;
		-- Auxiliary volatiles
		variable volatile_enemy_shots_x : INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0);
		variable volatile_enemy_shots_y : INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0);

		--Random maker
		variable rand_num : integer RANGE 0 TO 1000;
		variable seed : integer := 1;
		begin
			if rising_edge(clk) then
				-- Condition to reset shots at screen when level changes. Also it is used to reset
				IF level /= last_level then
					last_level := level;
					for i in 0 to NUM_MAX_SHOOT-1 loop
						volatile_enemy_shots_x(i) := -1;
						volatile_enemy_shots_y(i) := -1;
						number_of_shoots_at_screen := 0;
					end loop;
				end if;
				
				-- Generate shots from enemies
				if enemy_clock = '1' then 
					for i in 0 to NUM_MAX_ENEMY-1 loop
						-- Checks if enemy is really alive
						if (enemy_ships_x(i) > 0) and (number_of_shoots_at_screen < 15) then
							seed := (seed * 7) - 3; -- my random generator
							rand_num := seed+2*NUMBER_OF_LEVELS*3;
							-- probability if 2/30
							if (rand_num > (2*level)) then
								-- Implements as a queue so it is impossible to explode the vector
								-- Uses ship position to the shoots
								-- MIGHT HAVE BUGS.... IF SOMEHOW A BULLET DISAPPEARS, CALL ME, FAST!
								volatile_enemy_shots_x := enemy_ships_x(i) & volatile_enemy_shots_x(NUM_MAX_SHOOT-1 downto 1);
								volatile_enemy_shots_y := enemy_ships_y(i) & volatile_enemy_shots_y(NUM_MAX_SHOOT-1 downto 1);
								number_of_shoots_at_screen := number_of_shoots_at_screen + 1;
							end if;
						end if;
					end loop;
				end if;
				
				-- Make shoots go down
				if shot_clock = '1' then
					for i in 0 to NUM_MAX_SHOOT-1 loop
						if volatile_enemy_shots_y(i) > 0 then
							volatile_enemy_shots_y(i) := volatile_enemy_shots_y(i) - 1;
							-- Check if enemy bullet left screen and remove it from the array
							if volatile_enemy_shots_y(i) < 10 then
								volatile_enemy_shots_y(i) := -1;
								volatile_enemy_shots_x(i) := -1;
								number_of_shoots_at_screen := number_of_shoots_at_screen - 1;
							end if;
						end if;
						
					end loop;
				end if;
			end if;
		enemy_shots_x <= volatile_enemy_shots_x;
		enemy_shots_y <= volatile_enemy_shots_y;
	end process; 
END Architecture;