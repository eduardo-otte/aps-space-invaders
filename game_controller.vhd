LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY game_controller IS
    PORT(
        -- Inputs
        clk : IN STD_LOGIC;
        ship_hit_p1 : IN STD_LOGIC;
        ship_hit_p2 : IN STD_LOGIC;
        fired_p1 : IN STD_LOGIC;
        fired_p2 : IN STD_LOGIC;
        enemy_in_base : IN STD_LOGIC;
        living_ships : IN INTEGER;
        game_status : INTEGER;
        -- Outputs
        level : OUT INTEGER;
        lives_p1 : OUT INTEGER;
        lives_p2 : OUT INTEGER;
        shot_clock : OUT STD_LOGIC;
        player_ship_clock : OUT STD_LOGIC;
        enemy_ship_clock : OUT STD_LOGIC
    );
END;

ARCHITECTURE game_controller OF game_controller IS

BEGIN
    PROCESS(clk)
    BEGIN

    END PROCESS;
END;