LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

--player_ship_controllers

ENTITY player_ship_controllers IS
	 GENERIC (
		MIM_SCREEN_SIZE_X : INTEGER RANGE -10 TO 1200 := 0;
		MAX_SCREEN_SIZE_X : INTEGER RANGE -10 TO 1200 := 900;
		SIZE_SHIP : INTEGER RANGE -10 TO 1200 :=80
	 );
    PORT(
		clk: IN STD_LOGIC;
		movement : IN INTEGER RANGE -10 TO 1200;
      ship_hit : IN STD_LOGIC;
		ship_x : OUT INTEGER RANGE -10 TO 1200;
		ship_y : OUT INTEGER RANGE -10 TO 1200
    );
END;

ARCHITECTURE player_ship_controllers of player_ship_controllers IS
	--constant initial_position_x: INTEGER RANGE -10 TO 1200 :=(MAX_SCREEN_SIZE_X-MIM_SCREEN_SIZE_X)/2;
	constant initial_position_x: INTEGER RANGE -10 TO 1200 := 0;
	constant initial_position_y: INTEGER RANGE -10 TO 1200 :=MAX_SCREEN_SIZE_X - SIZE_SHIP;	
	signal ship_x_signal : INTEGER RANGE -10 TO 1200 := initial_position_x;

BEGIN
	ship_x <= ship_x_signal;
	ship_y <= initial_position_y;
		
	PROCESS(clk)
	BEGIN
		if rising_edge(clk) then
			if ((movement = -1) and (ship_x_signal > MIM_SCREEN_SIZE_X)) then
				ship_x_signal <= ship_x_signal - 10;
			elsif ((movement = 1 ) and (ship_x_signal < MAX_SCREEN_SIZE_X - SIZE_SHIP)) then
				ship_x_signal <= ship_x_signal + 10;
			end if;
			
			if (ship_hit = '1') then
				ship_x_signal <= initial_position_x;
			end if;
			
		end if;
	END PROCESS;

END;
	
	

	
	

	