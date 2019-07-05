LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY temp IS
    GENERIC(
        INITIAL_PLAYER_LIVES : INTEGER := 3
    );
    PORT(
        -- Inputs
        clk : IN STD_LOGIC;
        ship_hit_p1 : IN STD_LOGIC;
        ship_hit_p2 : IN STD_LOGIC;
        fired_p1 : IN STD_LOGIC;
        fired_p2 : IN STD_LOGIC;
        enemy_in_base : IN STD_LOGIC;
        living_ships : IN INTEGER;
        -- Outputs
        game_status : OUT INTEGER;
        level : OUT INTEGER;
        lives_p1 : OUT INTEGER;
        lives_p2 : OUT INTEGER;
        shot_clock : OUT STD_LOGIC;
        player_ship_clock : OUT STD_LOGIC;
        enemy_ship_clock : OUT STD_LOGIC
    );
END;

ARCHITECTURE temp OF temp IS
    signal game_status_signal : INTEGER := 0;
    signal lives_p1_signal : INTEGER := INITIAL_PLAYER_LIVES;
    signal lives_p2_signal : INTEGER := INITIAL_PLAYER_LIVES;
    signal level_signal : INTEGER := 0;

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
            END IF;

            -- Lose life when hit
            IF ship_hit_p1 = '1' THEN
                lives_p1_signal <= lives_p1_signal - 1;
            END IF;
            IF ship_hit_p2 = '1' THEN
                lives_p2_signal <= lives_p2_signal - 1;
            END IF;

            -- Go to next level when all enemy ships destroyed
            IF living_ships = 0 THEN
                level_signal <= level_signal + 1;
                game_status_signal <= 2;
            END IF;

            -- ***GAME OVER*** conditions
            IF ((lives_p1_signal = 0 and lives_p2_signal = 0) or enemy_in_base = '1') THEN
                game_status <= 3;
            END IF;
        END IF;
    END PROCESS;
END;