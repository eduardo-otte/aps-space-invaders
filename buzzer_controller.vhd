LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY buzzer_controller IS
    GENERIC(
        COUNTER_SIZE  :  INTEGER := 21;
        CLOCK_FREQUENCY : INTEGER := 50000000
    ); 
    PORT(
        clk : IN STD_LOGIC;
        game_status : IN INTEGER;
        enemy_ship_hit : IN STD_LOGIC;
        fired_buzzer : IN STD_LOGIC;
        buzzer_control : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE buzzer_controller OF buzzer_controller IS
    signal time_counter : INTEGER(0 to COUNTER_SIZE) := 0;
    signal sound_period : INTEGER := 50 * (CLOCK_FREQUENCY / 1000);
    signal play_sound : STD_LOGIC := '0';
BEGIN
    -- Verifica entradas e define qual som tocar
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN

        END IF;
    END PROCESS;

    -- Toca o som
    PROCESS(clk) THEN
    BEGIN
        IF rising_edge(clk) THEN

        END IF;
    END PROCESS;
END;