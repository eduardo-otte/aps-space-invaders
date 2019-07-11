LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY aps_game_controller IS
    GENERIC(
        INITIAL_PLAYER_LIVES : INTEGER RANGE 0 TO 5 := 3;
		  CLK_RATE : INTEGER := 50000000;
		  TEMPO_MOVE_SHOT_MIN_MS : INTEGER RANGE -10 TO 1200 := 100;
--		  TEMPO_MOVE_PLAYER_MIN_MS : INTEGER RANGE -10 TO 1200 := 500
		  TEMPO_MOVE_ENEMY_MIN_MS : INTEGER RANGE -10 TO 1200 := 100;
		  LEVEL_MAXIMO : INTEGER RANGE 0 TO 5 :=3
    );
    PORT(
        -- Inputs
        clk : IN STD_LOGIC;
        ship_hit_p1 : IN STD_LOGIC;
        ship_hit_p2 : IN STD_LOGIC;
        fired_p1 : IN STD_LOGIC;
        fired_p2 : IN STD_LOGIC;
        enemy_in_base : IN STD_LOGIC;
        living_ships : IN INTEGER RANGE 0 TO 100;
        -- Outputs
        game_status : OUT INTEGER RANGE 0 TO 3;
        level : OUT INTEGER RANGE 0 TO 5;
        lives_p1 : OUT INTEGER RANGE 0 TO 5;
        lives_p2 : OUT INTEGER RANGE 0 TO 5;
        shot_clock : OUT STD_LOGIC;
        --player_ship_clock : OUT STD_LOGIC;
        enemy_ship_clock : OUT STD_LOGIC
		  );
END;

ARCHITECTURE aps_game_controller OF aps_game_controller IS
    signal game_status_signal : INTEGER RANGE 0 TO 5 := 0;
    signal lives_p1_signal : INTEGER RANGE 0 TO 5 := INITIAL_PLAYER_LIVES;
    signal lives_p2_signal : INTEGER RANGE 0 TO 5 := INITIAL_PLAYER_LIVES;
    signal level_signal : INTEGER RANGE 0 TO 5 := 0;
	 constant tempo_minimo_move_tiro : INTEGER := TEMPO_MOVE_SHOT_MIN_MS * (CLK_RATE / 1000);
	 constant tempo_minimo_move_enemy : INTEGER := TEMPO_MOVE_ENEMY_MIN_MS * (CLK_RATE / 1000);
	 signal signal_enemy_ship_clock : STD_LOGIC:='0';
   --signal signal_player_ship_clock: STD_LOGIC:='0';
	 signal signal_shot_clock : STD_LOGIC:='0';
BEGIN
    game_status <= game_status_signal;
    lives_p1 <= lives_p1_signal;
    lives_p2 <= lives_p2_signal;

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Shoot to start game/level
            IF ((game_status_signal = 0 or game_status_signal = 2) and (fired_p1 = '1' or fired_p2 = '1')) THEN
                game_status_signal <= 1;
					 level_signal <= level_signal + 1;
				 
				 -- Go to next level when all enemy ships destroyed
            ELSIF (living_ships = 0 AND game_status_signal = 1) THEN
                game_status_signal <= 2;
					 
            -- ***GAME OVER*** conditions
            ELSIF (game_status_signal = 1 AND (lives_p1_signal = 0 OR lives_p2_signal = 0 or enemy_in_base = '1')) THEN
                game_status_signal <= 3;
            END IF;

            -- Lose life when hit
            IF ship_hit_p1 = '1' THEN
                lives_p1_signal <= lives_p1_signal - 1;
            END IF;
            IF ship_hit_p2 = '1' THEN
                lives_p2_signal <= lives_p2_signal - 1;
            END IF;
		  END IF;
    END PROCESS;


	 -- Controlador de tempo
	PROCESS(clk)
		variable contador_tempo_tiro : INTEGER:= 0;
		variable contador_tempo_ship : INTEGER:= 0;
		BEGIN
			IF rising_edge(clk) THEN
				-- Clk tiro
				IF contador_tempo_tiro > (tempo_minimo_move_tiro * (LEVEL_MAXIMO+1 - level_signal)) THEN
					signal_shot_clock <= '1';
					contador_tempo_tiro := 0;
				ELSE
					contador_tempo_tiro := contador_tempo_tiro +1;
					signal_shot_clock <= '0';
				END IF;

				-- Clk inimigo
				IF contador_tempo_ship > (tempo_minimo_move_enemy * (LEVEL_MAXIMO+1 - level_signal)) THEN
					signal_enemy_ship_clock <= '1';
					contador_tempo_ship := 0;
				ELSE
					signal_enemy_ship_clock <= '0';
					contador_tempo_ship := contador_tempo_ship +1;
				END IF;
			END IF;

	END PROCESS;
	 level <= level_signal;
	 shot_clock <= '0';
	 enemy_ship_clock <='0';

END;
