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
        game_status : IN INTEGER RANGE -10 TO 1200;
        enemy_ship_hit : INTEGER RANGE -10 TO 100;
        ship_hit : IN STD_LOGIC;
        fired_buzzer : IN STD_LOGIC;
        buzzer_control : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE buzzer_controller OF buzzer_controller IS
    signal prev_game_status : INTEGER RANGE -10 TO 1200 := 0;
    signal time_counter : INTEGER RANGE 0 TO 50000000 := 0;
    signal sound_half_period : INTEGER RANGE 0 TO 50000000:= 50 * (CLOCK_FREQUENCY / 1000);
    signal sound_cycles_counter : INTEGER RANGE 0 TO 4095 := 0;
    signal sound_cycles : INTEGER RANGE 0 TO 4095;
    signal play_sound : STD_LOGIC := '0';
    signal buzzer_control_signal : STD_LOGIC := '0';
BEGIN
    buzzer_control <= buzzer_control_signal;

    -- Inicio do jogo, final do jogo, acerto de um inimigo, acerto da nave do player e a cada tiro disparado pelo player.
    -- Todas os períodos calculados p/ clock @ 50 MHz
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Toca o som
            IF play_sound = '1' THEN
                IF sound_cycles_counter < sound_cycles THEN
                    IF time_counter >= sound_half_period THEN
                        buzzer_control_signal <= not buzzer_control_signal;
                        sound_cycles_counter <= sound_cycles_counter + 1;
                        time_counter <= 0;
                    ELSE
                        time_counter <= time_counter + 1;
                    END IF;
                ELSE
                    play_sound <= '0';
                END IF;
            -- Verifica entradas e define qual som tocar
            ELSE
                IF game_status = 1 THEN
                    -- Jogador disparou
                    IF fired_buzzer = '1' THEN
                        sound_half_period <= 2450000; -- G3
                        time_counter <= 0;
                        sound_cycles <= 196;
                        sound_cycles_counter <= 0;
                        play_sound <= '1';
                    -- Jogador foi alvejado
                    ELSIF ship_hit = '1' THEN
                        sound_half_period <= 3800000; -- D#4
                        time_counter <= 0;
                        sound_cycles <= 310;
                        sound_cycles_counter <= 0;
                        play_sound <= '1';
                    -- Inimigo foi alvejado
                    ELSIF enemy_ship_hit >= 0 THEN
                        sound_half_period <= 5500000; -- A4
                        time_counter <= 0;
                        sound_cycles <= 440;
                        sound_cycles_counter <= 0;
                        play_sound <= '1';
                    END IF;
                ELSIF game_status = 1 and prev_game_status /= 1 THEN
                    sound_half_period <= 5000000; -- G4
                    time_counter <= 0;
                    sound_cycles <= 1568;
                    sound_cycles_counter <= 0;
                    play_sound <= '1';
                ELSIF game_status = 3 and prev_game_status /= 3 THEN
                    sound_half_period <= 6000000; -- Bb4
                    time_counter <= 0;
                    sound_cycles <= 1865;
                    sound_cycles_counter <= 0;
                    play_sound <= '1';
                ELSE
                    play_sound <= '0';
                END IF;
            END IF;

            prev_game_status <= game_status;

        END IF;
    END PROCESS;
END;