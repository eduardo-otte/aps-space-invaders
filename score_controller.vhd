LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY score_controller IS
    PORT(
        clk : IN STD_LOGIC;
        level : IN INTEGER RANGE 0 TO 5;
        enemy_ship_hit_p1 : IN STD_LOGIC;
        enemy_ship_hit_p2 : IN STD_LOGIC;
        score : OUT INTEGER RANGE -10 TO 1200
    );
END;

ARCHITECTURE score_controller OF score_controller IS
    signal score_signal : INTEGER RANGE -10 TO 1200 := 0;

BEGIN
    score <= score_signal;

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF enemy_ship_hit_p1 = '1' THEN
                score_signal <= score_signal + level;
            END IF;

            IF enemy_ship_hit_p2 = '1' THEN
                score_signal <= score_signal + level;
            END IF;
        END IF;
    END PROCESS;
END;