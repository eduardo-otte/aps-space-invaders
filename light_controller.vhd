LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY light_controller IS
	 GENERIC(
		  counter_size  :  INTEGER RANGE -10 TO 1200 := 21 --counter size (19 bits gives 10.5ms with 50MHz clock)
	 );
    PORT(
        -- Inputs
        clk : IN STD_LOGIC;
        ship_hit_p1 : IN STD_LOGIC;
        ship_hit_p2 : IN STD_LOGIC;
        game_status : IN INTEGER RANGE 0 TO 3;
		  -- 0 = "Shoot to start", 1 = "Game in progress", 2 = "Level transition", 3 = "Game over"
		  -- Outputs
        light_control_p1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        light_control_p2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END;

ARCHITECTURE a_light_controller OF light_controller IS
    SIGNAL light_p1_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL light_p2_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
	 SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output

BEGIN
    light_control_p1 <= light_p1_signal;
    light_control_p2 <= light_p2_signal;

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (game_status = 0) THEN
					 counter_out <= (OTHERS => '0');
                light_p1_signal <= "001";
					 light_p2_signal <= "001";
				END IF;
				
				iF (game_status = 1) THEN
					 counter_out <= counter_out + 1; 
                light_p1_signal(1) <= '1';
					 light_p2_signal(1) <= '1';
					 
					 IF(ship_hit_p1 = '1') THEN
						  light_p1_signal(2) <= '1';
						  counter_out <= (OTHERS => '0');
					 ELSIF(ship_hit_p2 = '1') THEN
						  light_p2_signal(2) <= '1';
						  counter_out <= (OTHERS => '0');
					 END IF;
					 
					 IF(counter_out(counter_size) = '1') THEN
						  light_p1_signal(2) <= '0';
						  light_p2_signal(2) <= '0';
						  counter_out <= (OTHERS => '0');
					 END IF;
				END IF;
				
				iF (game_status = 3) THEN
					 counter_out <= (OTHERS => '0');
                light_p1_signal <= "100";
					 light_p2_signal <= "100";
				END IF;
				
            iF (game_status = 2) THEN
					 counter_out <= counter_out + 1;
					 IF(counter_out(counter_size) = '1') THEN
						  light_p1_signal(0) <= light_p1_signal(1);
						  light_p2_signal(1) <= light_p1_signal(0);
						  counter_out <= (OTHERS => '0');
					 END IF;
				END IF;
        END IF;
    END PROCESS;
END;