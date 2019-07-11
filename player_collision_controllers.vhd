LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE work.integer_vector.all;

--player_collision_controllers

ENTITY player_collision_controllers IS
	 GENERIC(
			NUM_MAX_SHOTS: INTEGER RANGE -10 TO 1200 :=15;
			SHIP_SIZE : INTEGER RANGE -10 TO 1200 := 80
	 );
    PORT(
		clk : IN STD_LOGIC;
		enemy_shots_x : IN INTEGER_VECTOR((NUM_MAX_SHOTS)-1 downto 0);
		enemy_shots_y : IN INTEGER_VECTOR((NUM_MAX_SHOTS)-1 downto 0);
		ship_x : IN INTEGER RANGE -10 TO 1200;
    ship_y : IN INTEGER RANGE -10 TO 1200;
		ship_hit : OUT STD_LOGIC);
END;

ARCHITECTURE player_collision_controllers of player_collision_controllers IS
	signal ship_hit_signal : STD_LOGIC;

BEGIN

	ship_hit <= ship_hit_signal;

PROCESS(clk)
BEGIN
	IF rising_edge(clk) THEN
		for I in 0 TO NUM_MAX_SHOTS-1 LOOP
			IF((enemy_shots_x(I) >= ship_x AND (enemy_shots_x(I) <= ship_x+SHIP_SIZE)) AND (enemy_shots_y(I) = ship_y)) THEN
				ship_hit_signal <= '1';
			ELSE
				ship_hit_signal <= '0';
			END IF;
	  end LOOP;
	END IF;

end process;

end;
