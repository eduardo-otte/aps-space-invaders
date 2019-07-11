LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

--player_shot_controllers

ENTITY player_shot_controllers IS
	 GENERIC(
		MAX_SCREEN_SIZE_Y: INTEGER RANGE -10 TO 1200 := 900
	 );
    PORT(
		clk : IN STD_LOGIC;
		shot_clock : IN STD_LOGIC;
      enemy_ship_hit : IN STD_LOGIC;
      fired : IN STD_LOGIC;
		ship_x : IN INTEGER RANGE -10 TO 1200;
      ship_y : IN INTEGER RANGE -10 TO 1200;
		fired_buzzer : OUT STD_LOGIC;
		shot_x : OUT INTEGER RANGE -10 TO 1200;
		shot_y : OUT INTEGER RANGE -10 TO 1200 );
END;

ARCHITECTURE player_shot_controllers of player_shot_controllers IS
	signal fired_buzzer_signal : STD_LOGIC := '0';
	signal shot_x_signal : INTEGER RANGE -10 TO 1200;
	signal shot_y_signal : INTEGER RANGE -10 TO 1200;		

BEGIN

	fired_buzzer <= fired_buzzer_signal;
	shot_x <= shot_x_signal;
	shot_y <= shot_y_signal;
	
	PROCESS(clk,enemy_ship_hit)
	BEGIN
		if rising_edge(clk) then
			if (shot_clock = '1') then
				if(shot_x_signal/=-1 AND shot_y_signal/=-1) then
					shot_y_signal <= shot_y_signal-1;
				end if;
			end if; 
			
			if(fired = '1' AND shot_x_signal=-1 AND shot_y_signal=-1) then
				shot_x_signal <= ship_x;
				shot_y_signal <= ship_y;
				fired_buzzer_signal <= '1';
			else
				fired_buzzer_signal <= '0';
			end if;
			
			if (enemy_ship_hit='1') then 
				shot_x_signal <= -1;
				shot_y_signal <= -1;
			end if;
			
		end if;	
	END PROCESS;
	
	
 
end architecture;