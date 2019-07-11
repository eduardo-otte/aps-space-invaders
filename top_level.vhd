LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
use work.INTEGER_VECTOR.all;

	ENTITY top_level IS
    GENERIC (
		COUNTER_SIZE: INTEGER := 21;
		NUM_MAX_SHOOT: INTEGER RANGE 0 TO 20 := 10;
		NUM_MAX_ENEMY: INTEGER RANGE 0 TO 100 := 16;
		TEMPO_MOVE_ENEMY_MIN_MS : INTEGER RANGE -10 TO 1200 := 500;
		TEMPO_MOVE_SHOT_MIN_MS : INTEGER RANGE -10 TO 1200 := 500;
		SHIP_SIZE : INTEGER RANGE 0 TO 100 := 80;
		INITIAL_PLAYER_LIVES : INTEGER RANGE 0 TO 5 := 3;
		NUMBER_OF_LEVELS : INTEGER RANGE 0 TO 5 := 3;
		NUM_MAX_ENEMY_PER_LINE : INTEGER RANGE 0 TO 10 := 9;
		BATTLEFIELD_SIZE : INTEGER RANGE -10 TO 1200 := 900;
		PX_BOARDER_LEFT : INTEGER RANGE -10 TO 1200 := 90;
		PX_BORDA_TOP : INTEGER RANGE -10 TO 1200 := 130;
		PX_BORDA_BOTTON : INTEGER RANGE -10 TO 1200 := 130;
		NUMBER_OF_HORIZONTAL_JUMPS : INTEGER RANGE -10 TO 1200 := 30;
		PX_PER_HORIZONTAL_JUMP : INTEGER RANGE -10 TO 1200 := 10;
		LINES_IN_Y_AT_LV1 : INTEGER RANGE 0 TO 8 := 2;
		LINES_IN_Y_AT_LV2 : INTEGER RANGE 0 TO 8 := 4;
		LINES_IN_Y_AT_LV3 : INTEGER RANGE 0 TO 8 := 6;
		CLK_RATE : INTEGER := 50000000;
		SHOT_WIDTH: INTEGER RANGE -10 TO 1200 := 10;
		SHOT_HEIGHT: INTEGER RANGE -10 TO 1200 := 40
    );
	 
    PORT(
        clk : IN STD_LOGIC;
        move_l_p1 : IN STD_LOGIC;
        move_r_p1 : IN STD_LOGIC;
        fire_p1 : IN STD_LOGIC;
        move_l_p2 : IN STD_LOGIC;
        move_r_p2: IN STD_LOGIC;
        fire_p2 : IN STD_LOGIC;
        light_control_p1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        light_control_p2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			VGA_HS,VGA_VS:OUT STD_LOGIC;
			VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(3 downto 0);

		-- Saídas dos buzzers
			buzzer_control_p1 : OUT STD_LOGIC;
			buzzer_control_p2 : OUT STD_LOGIC
	);
END;

ARCHITECTURE a_top_level OF top_level IS

    COMPONENT input_controller
	PORT(
		clk : IN STD_LOGIC;
		move_l : IN STD_LOGIC;
		move_r : IN STD_LOGIC;
		fire : IN STD_LOGIC;
		fired : OUT STD_LOGIC;
		movement : OUT INTEGER RANGE -10 TO 1200
	);
	END COMPONENT input_controller;

    COMPONENT score_controller IS
		PORT(
		clk : IN STD_LOGIC;
		level : IN INTEGER RANGE 0 TO 5;
		enemy_ship_hit_p1 : IN STD_LOGIC;
		enemy_ship_hit_p2 : IN STD_LOGIC;
		score : OUT INTEGER RANGE -10 TO 1200
	);
	END COMPONENT score_controller;
	
	COMPONENT buzzer_controller IS
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
	END COMPONENT buzzer_controller;
	
	COMPONENT VGA IS
	GENERIC (
		ALIEN_NUMBER : INTEGER RANGE 0 TO 100 := 32;
		SHOTS_NUMBER : INTEGER RANGE 0 TO 20 := 10;
		SHOT_SIZE_X : INTEGER RANGE -10 TO 1200 := 10;
		SHOT_SIZE_Y : INTEGER RANGE -10 TO 1200 := 40;
		BATTLEFIELD_SIZE : INTEGER RANGE -10 TO 1200 := 900;
		INITIAL_PLAYER_LIVES : INTEGER RANGE -10 TO 1200 := 3;
		NUMBER_OF_LEVELS : INTEGER RANGE 0 TO 5 := 3
	);
	PORT(
		CLOCK_50: IN STD_LOGIc;
		GAME_STATUS: IN INTEGER RANGE 0 TO 3;
		LEVEL : IN INTEGER RANGE 0 TO NUMBER_OF_LEVELS;
		LIVES_P1: IN INTEGER RANGE 0 TO INITIAL_PLAYER_LIVES;
		LIVES_P2: IN INTEGER RANGE 0 TO INITIAL_PLAYER_LIVES;
		SCORE: IN INTEGER RANGE -10 TO 1200;
		ENEMY_SHIPS_X : IN INTEGER_VECTOR(ALIEN_NUMBER-1 downto 0);
		ENEMY_SHIPS_Y : IN INTEGER_VECTOR(ALIEN_NUMBER-1 downto 0);
		ENEMY_SHOTS_X : IN INTEGER_VECTOR(SHOTS_NUMBER-1 downto 0);
		ENEMY_SHOTS_Y : IN INTEGER_VECTOR(SHOTS_NUMBER-1 downto 0);
		SHOT_X_P1 : IN INTEGER RANGE -10 TO 1200;
		SHOT_Y_P1 : IN INTEGER RANGE -10 TO 1200;
		SHOT_X_P2 : IN INTEGER RANGE -10 TO 1200;
		SHOT_Y_P2 : IN INTEGER RANGE -10 TO 1200;
		SHIP_X_P1 : IN INTEGER RANGE -10 TO 1200;
		SHIP_Y_P1 : IN INTEGER RANGE -10 TO 1200;
		SHIP_X_P2 : IN INTEGER RANGE -10 TO 1200;
		SHIP_Y_P2 : IN INTEGER RANGE -10 TO 1200;
		VGA_HS,VGA_VS:OUT STD_LOGIC;
		VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
	END COMPONENT VGA;

    COMPONENT light_controller IS
		GENERIC(
			counter_size  :  INTEGER RANGE -10 TO 1200 := 21 --counter size (19 bits gives 10.5ms with 50MHz clock)
		);
		PORT(
			clk : IN STD_LOGIC;
			ship_hit_p1 : IN STD_LOGIC;
			ship_hit_p2 : IN STD_LOGIC;
			game_status : IN INTEGER RANGE 0 TO 3; -- 0 = "Shoot to start", 1 = "Game in progress", 2 = "Level transition", 3 = "Game over"
			light_control_p1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			light_control_p2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT light_controller;

    COMPONENT aps_game_controller IS
		GENERIC(
        INITIAL_PLAYER_LIVES : INTEGER RANGE 0 TO 5 := 3;
		  CLK_RATE : INTEGER := 50000000;
		  TEMPO_MOVE_SHOT_MIN_MS : INTEGER RANGE -10 TO 1200 := 500;
--		  TEMPO_MOVE_PLAYER_MIN_MS : INTEGER RANGE -10 TO 1200 := 500
		  TEMPO_MOVE_ENEMY_MIN_MS : INTEGER RANGE -10 TO 1200 := 500;
		  LEVEL_MAXIMO : INTEGER RANGE 0 TO 5 :=3
		);
		PORT(
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
		END COMPONENT aps_game_controller;
		
		COMPONENT player_collision_controllers IS
			 GENERIC(
					NUM_MAX_SHOTS: INTEGER RANGE 0 TO 20 :=15;
					SHIP_SIZE : INTEGER RANGE 0 TO 100 := 80
			 );
			 PORT(
					clk : IN STD_LOGIC;
					enemy_shots_x : IN INTEGER_VECTOR((NUM_MAX_SHOTS)-1 downto 0);
					enemy_shots_y : IN INTEGER_VECTOR((NUM_MAX_SHOTS)-1 downto 0);
					ship_x : IN INTEGER RANGE -10 TO 1200;
					ship_y : IN INTEGER RANGE -10 TO 1200;
					ship_hit : OUT STD_LOGIC);
		END COMPONENT player_collision_controllers;
		
		COMPONENT player_ship_controllers IS
			 GENERIC (
				MIM_SCREEN_SIZE_X : INTEGER RANGE -10 TO 1200 := 0;
				MAX_SCREEN_SIZE_X : INTEGER RANGE -10 TO 1200 := 900;
				SIZE_SHIP : INTEGER RANGE 0 TO 100 :=80
			 );
			 PORT(
				clk: IN STD_LOGIC;
				movement : IN INTEGER RANGE -10 TO 1200;
				ship_hit : IN STD_LOGIC;
				ship_x : OUT INTEGER RANGE -10 TO 1200;
				ship_y : OUT INTEGER RANGE -10 TO 1200
			 );
		END COMPONENT player_ship_controllers;
		
		COMPONENT player_shot_controllers IS
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
		END COMPONENT player_shot_controllers;

    COMPONENT enemy_shoot_controller IS
		GENERIC (
			NUM_MAX_SHOOT: INTEGER RANGE 0 TO 20 := 15;
			NUM_MAX_ENEMY: INTEGER RANGE 0 TO 100 := 64;
			NUMBER_OF_LEVELS: INTEGER RANGE 0 TO 5 := 3
		);
		PORT(
			clk : IN STD_LOGIC;
			enemy_clock, shot_clock : IN STD_LOGIC;
			enemy_ships_x, enemy_ships_y : IN INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
			level : IN INTEGER RANGE 0 TO 5;
			enemy_shots_x : OUT INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0);
			enemy_shots_y : OUT INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0)
		);
	END COMPONENT enemy_shoot_controller;
	
    COMPONENT enemy_colision_controller IS
		GENERIC(
			NUM_MAX_ENEMY: INTEGER RANGE 0 TO 100 := 64;
			ENEMY_SIZE: INTEGER RANGE 0 TO 100 := 80;
			SHOT_WIDTH: INTEGER RANGE -10 TO 1200 := 10;
			SHOT_HEIGHT: INTEGER RANGE -10 TO 1200 := 80
		);
    	PORT(
    		shot_x_p1, shot_y_p1, shot_x_p2, shot_y_p2: IN INTEGER RANGE -10 TO 1200;
    		-- Need to import to this component what is integer_vector
    		enemy_ships_x, enemy_ships_y: 	IN INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
    		enemy_ship_hit: OUT INTEGER RANGE -10 TO 100;
    		enemy_ship_hit_p1, enemy_ship_hit_p2: OUT STD_LOGIC
		);
	END COMPONENT enemy_colision_controller;

    COMPONENT enemy_ship_controller IS
		GENERIC (
			NUM_MAX_ENEMY: INTEGER RANGE 0 TO 100 := 64;
			NUM_MAX_ENEMY_PER_LINE: INTEGER RANGE -10 TO 1200 := 8;
			DISPLAY_HIGH: INTEGER RANGE -10 TO 1200 := 900;
			PX_BOARDER_LEFT: INTEGER RANGE -10 TO 1200 := 90;
			PX_BORDA_TOP: INTEGER RANGE -10 TO 1200 := 130;
			PX_BORDA_BOTTON: INTEGER RANGE -10 TO 1200 := 130;
			ENEMY_SIZE: INTEGER RANGE -10 TO 1200 := 80;
			NUMBER_OF_HORIZONTAL_JUMPS: INTEGER RANGE -10 TO 1200 := 5;
			PX_PER_HORIZONTAL_JUMP: INTEGER RANGE -10 TO 1200 := 10;
			LINES_IN_Y_AT_LV1: INTEGER RANGE -10 TO 1200 := 2;
			LINES_IN_Y_AT_LV2: INTEGER RANGE -10 TO 1200 := 4;
			LINES_IN_Y_AT_LV3: INTEGER RANGE -10 TO 1200 := 6;
			NUMBER_OF_LEVELS: INTEGER RANGE 0 TO 5 := 3
		);
		PORT(
			clk : IN STD_LOGIC;
			--enemy_ship_clock:   	IN STD_LOGIC;
			enemy_ship_hit:  IN INTEGER RANGE -10 TO 100;
			level:  IN INTEGER RANGE 0 TO 5;
			enemy_ships_x: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
			enemy_ships_y: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
			living_ships : 			OUT INTEGER RANGE 0 TO 100;
			enemy_in_base: 			OUT STD_LOGIC
		);
	END COMPONENT enemy_ship_controller;



    --signals
    SIGNAL signal_fired_p1, signal_fired_p2,signal_shot_clock,signal_enemy_clock : std_LOGIC := '0';
    SIGNAL signal_movement_p1, signal_movement_p2 : INTEGER RANGE -10 TO 1200 := 0;
    SIGNAL signal_level : INTEGER RANGE 0 TO 5 := 0;
	 SIGNAL signal_score : INTEGER RANGE -10 TO 1200 := 0;
	 SIGNAL signal_buzzer_control_p1, signal_buzzer_control_p2 : std_LOGIC := '0';
    SIGNAL signal_game_status : INTEGER RANGE 0 TO 3:= 0;
    SIGNAL signal_light_control_p1,signal_light_control_p2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL signal_ship_hit_p1, signal_ship_hit_p2 : STD_LOGIC := '0';
	 SIGNAL signal_fired_buzzer_p1, signal_fired_buzzer_p2 : STD_LOGIC := '0';
    SIGNAL signal_enemy_in_base : STD_LOGIC := '0';
    SIGNAL signal_enemy_ship_hit_p1, signal_enemy_ship_hit_p2 : STD_LOGIC := '0';
    SIGNAL signal_lives_p1, signal_lives_p2 : INTEGER RANGE 0 TO 5 := 0;
	 SIGNAL  signal_living_ships : INTEGER RANGE 0 TO 100 := 0;
	 SIGNAL  level_rst : std_LOGIC := '0';
    SIGNAL signal_enemy_ships_x, signal_enemy_ships_y : INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
    SIGNAL signal_enemy_shots_x, signal_enemy_shots_y : INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0);
    SIGNAL signal_enemy_ship_hit:   INTEGER RANGE -10 TO 100 := 0;
    SIGNAL signal_shot_x_p1, signal_shot_y_p1, signal_shot_x_p2, signal_shot_y_p2: INTEGER RANGE -10 TO 1200 := 0;
	 SIGNAL signal_ship_x_p1, signal_ship_y_p1, signal_ship_x_p2, signal_ship_y_p2 : INTEGER RANGE -10 TO 1200 := 0;

BEGIN


		buzzer_control_p1<=signal_buzzer_control_p1;
		buzzer_control_p2<=signal_buzzer_control_p2;
    light_control_p1 <= signal_light_control_p1;
    light_control_p2 <= signal_light_control_p2;

    input_controller_p1: input_controller
	port map (
		clk => clk,
		move_l => move_l_p1,
		move_r => move_r_p1,
		fire => fire_p1,
		fired => signal_fired_p1,
		movement => signal_movement_p1
	);

    input_controller_p2: input_controller
	port map (
		clk => clk,
		move_l => move_l_p2,
		move_r => move_r_p2,
		fire => fire_p2,
		fired => signal_fired_p2,
		movement => signal_movement_p2
	);
	
		buzzer_p1: buzzer_controller 
		generic map(
		 COUNTER_SIZE  => COUNTER_SIZE,
		 CLOCK_FREQUENCY =>CLK_RATE
		)
		port map (
		 clk => clk,
		 game_status => signal_game_status,
		 enemy_ship_hit => signal_enemy_ship_hit,
		 ship_hit => signal_ship_hit_p1,
		 fired_buzzer => signal_fired_buzzer_p1,
		 buzzer_control => signal_buzzer_control_p1
		);

		buzzer_p2: buzzer_controller 
		generic map(
		 COUNTER_SIZE  => COUNTER_SIZE,
		 CLOCK_FREQUENCY =>CLK_RATE
		)
		port map (
		 clk => clk,
		 game_status => signal_game_status,
		 enemy_ship_hit => signal_enemy_ship_hit,
		 ship_hit => signal_ship_hit_p2,
		 fired_buzzer => signal_fired_buzzer_p2,
		 buzzer_control => signal_buzzer_control_p2
		);
	
	
	player1_collision_controller : player_collision_controllers
	generic map(
			NUM_MAX_SHOTS => num_MAX_SHOOT,
			SHIP_SIZE => SHIP_SIZE
	 )
	 port map(
			clk => clk,
			enemy_shots_x => signal_enemy_shots_x,
			enemy_shots_y => signal_enemy_shots_y,
			ship_x => signal_ship_x_p1,
			ship_y => signal_ship_y_p1,
			ship_hit => signal_ship_hit_p1
	);
	
	player2_collision_controller : player_collision_controllers
	generic map(
			NUM_MAX_SHOTS => num_MAX_SHOOT,
			SHIP_SIZE => SHIP_SIZE
	 )
	 port map(
			clk => clk,
			enemy_shots_x => signal_enemy_shots_x,
			enemy_shots_y => signal_enemy_shots_y,
			ship_x => signal_ship_x_p2,
			ship_y => signal_ship_y_p2,
			ship_hit => signal_ship_hit_p2
	);
	
	player1_ship_controller : player_ship_controllers 
	 generic map (
		MIM_SCREEN_SIZE_X => 0,
		MAX_SCREEN_SIZE_X => BATTLEFIELD_SIZE,
		SIZE_SHIP => SHIP_SIZE
	 )
    port map(
		clk => clk,
		movement => signal_movement_p1,
      ship_hit => signal_ship_hit_p1,
		ship_x => signal_ship_x_p1,
		ship_y => signal_ship_y_p1
    );
	 
	player2_ship_controller : player_ship_controllers 
	 generic map (
		MIM_SCREEN_SIZE_X => 0,
		MAX_SCREEN_SIZE_X => BATTLEFIELD_SIZE,
		SIZE_SHIP => SHIP_SIZE
	 )
    port map(
		clk => clk,
		movement => signal_movement_p2,
      ship_hit => signal_ship_hit_p2,
		ship_x => signal_ship_x_p2,
		ship_y => signal_ship_y_p2
    );
 
	player1_shot_controller : player_shot_controllers 
	generic map(
		MAX_SCREEN_SIZE_Y => BATTLEFIELD_SIZE
	 )
	 port map(
		clk => clk,
		shot_clock => signal_shot_clock,
		enemy_ship_hit => signal_enemy_ship_hit_p1,
		fired =>signal_fired_p1,
		ship_x => signal_ship_x_p1,
		ship_y => signal_ship_y_p1,
		fired_buzzer => signal_fired_buzzer_p1,
		shot_x => signal_shot_x_p1,
		shot_y => signal_shot_y_p1
	);
	
	player2_shot_controller : player_shot_controllers 
	generic map(
		MAX_SCREEN_SIZE_Y => BATTLEFIELD_SIZE
	 )
	 port map(
		clk => clk,
		shot_clock => signal_shot_clock,
		enemy_ship_hit => signal_enemy_ship_hit_p2,
		fired =>signal_fired_p2,
		ship_x => signal_ship_x_p2,
		ship_y => signal_ship_y_p2,
		fired_buzzer => signal_fired_buzzer_p2,
		shot_x => signal_shot_x_p2,
		shot_y => signal_shot_y_p2
	);
	
	C_display_controller : VGA
	generic map(
	ALIEN_NUMBER => NUM_MAX_ENEMY,
	SHOTS_NUMBER => NUM_MAX_SHOOT,
	SHOT_SIZE_X => SHOT_WIDTH,
	SHOT_SIZE_Y => SHOT_hEIGHT,
	BATTLEFIELD_SIZE => BATTLEFIELD_SIZE,
	INITIAL_PLAYER_LIVES => INITIAL_PLAYER_LIVES,
	NUMBER_OF_LEVELS => NUMBER_OF_LEVELS
	)
	port map(
	CLOCK_50=> clk,
	GAME_STATUS => signal_game_status,
	LEVEL => signal_level,
	LIVES_P1 => signal_lives_p1,
	LIVES_P2 => signal_lives_p2,
	SCORE => signal_score,
	ENEMY_SHIPS_X => signal_enemy_ships_x,
	ENEMY_SHIPS_Y => signal_enemy_ships_y,
	ENEMY_SHOTS_X => signal_enemy_shots_x,
	ENEMY_SHOTS_Y => signal_enemy_shots_y,
	SHOT_X_P1 => signal_shot_x_p1,
	SHOT_Y_P1 => signal_shot_y_p1,
	SHOT_X_P2 => signal_shot_x_p2,
	SHOT_Y_P2 => signal_shot_y_p2,
	SHIP_X_P1 => signal_ship_x_p1,
	SHIP_Y_P1 => signal_ship_y_p1,
	SHIP_X_P2 => signal_ship_x_p2,
	SHIP_Y_P2 => signal_ship_y_p2,
	VGA_HS => VGA_HS,
	VGA_VS => VGA_VS,
	VGA_R => VGA_R,
	VGA_B => VGA_B,
	VGA_G => VGA_G
	);
	
	

    C_score_controller : score_controller
	port map(
		clk => clk,
		level => signal_level,
		enemy_ship_hit_p1 => signal_enemy_ship_hit_p1,
		enemy_ship_hit_p2 => signal_enemy_ship_hit_p2,
		score => signal_score
	);

    C_light_controller : light_controller
	port map(
		clk => clk,
		ship_hit_p1 => signal_ship_hit_p1,
		ship_hit_p2 => signal_ship_hit_p2,
		game_status => signal_game_status, -- 0 = "Shoot to start", 1 = "Game in progress", 2 = "Level transition", 3 = "Game over"
		light_control_p1 => signal_light_control_p1,
		light_control_p2 => signal_light_control_p2
	);

    C_game_controller : aps_game_controller
	generic map (
        INITIAL_PLAYER_LIVES => INITIAL_PLAYER_LIVES,
		  CLK_RATE => CLK_RATE,
		  TEMPO_MOVE_SHOT_MIN_MS => TEMPO_MOVE_SHOT_MIN_MS,
--		  TEMPO_MOVE_PLAYER_MIN_MS => 500,
		  TEMPO_MOVE_ENEMY_MIN_MS => TEMPO_MOVE_ENEMY_MIN_MS,
		  LEVEL_MAXIMO => NUMBER_OF_LEVELS
	)
	port map(
		clk => clk,
		ship_hit_p1 => signal_ship_hit_p1,
		ship_hit_p2 => signal_ship_hit_p2,
		fired_p1 => signal_fired_p1,
		fired_p2 => signal_fired_p2,
		enemy_in_base => signal_enemy_in_base,
		living_ships => signal_living_ships,
		game_status => signal_game_status,
		level => signal_level,
		lives_p1 => signal_lives_p1,
		lives_p2 => signal_lives_p2,
		shot_clock => signal_shot_clock,
		enemy_ship_clock => signal_enemy_clock
	);

    C_enemy_shoot_controller : enemy_shoot_controller
	generic map (
		NUM_MAX_SHOOT => NUM_MAX_SHOOT,
		NUM_MAX_ENEMY => NUM_MAX_ENEMY,
		NUMBER_OF_LEVELS => NUMBER_OF_LEVELS
	)
	port map (
		clk => clk,
		-- tirar esses clocks fora?
	   enemy_clock => signal_enemy_clock,
	   shot_clock => signal_shot_clock,
		enemy_ships_x => signal_enemy_ships_x,
		enemy_ships_y => signal_enemy_ships_y,
		level => signal_level,
		enemy_shots_x => signal_enemy_shots_x,
		enemy_shots_y =>signal_enemy_shots_y
	);
	
 C_enemy_colision_controler : enemy_colision_controller
	generic map (
		NUM_MAX_ENEMY => NUM_MAX_ENEMY,
		ENEMY_SIZE => SHIP_SIZE,
		SHOT_WIDTH => SHOT_WIDTH,
		SHOT_HEIGHT => SHOT_HEIGHT
	)	 
	port map (
		shot_x_p1 => signal_shot_x_p1,
		shot_y_p1 => signal_shot_y_p1,
		shot_x_p2 =>signal_shot_x_p2,
		shot_y_p2 => signal_shot_y_p2,
		enemy_ships_x => signal_enemy_ships_x,
		enemy_ships_y => signal_enemy_ships_y,
		enemy_ship_hit => signal_enemy_ship_hit,
		enemy_ship_hit_p1 =>signal_enemy_ship_hit_p1,
		enemy_ship_hit_p2 =>signal_enemy_ship_hit_p2
	);

    C_enemy_ship_controller : enemy_ship_controller
	generic map (
		NUM_MAX_ENEMY => NUM_MAX_ENEMY,
		NUM_MAX_ENEMY_PER_LINE => NUM_MAX_ENEMY_PER_LINE,
		DISPLAY_HIGH => BATTLEFIELD_SIZE,
		PX_BOARDER_LEFT => PX_BOARDER_LEFT,
		PX_BORDA_TOP => PX_BORDA_TOP,
		PX_BORDA_BOTTON => PX_BORDA_BOTTON,
		ENEMY_SIZE => SHIP_SIZE,
		NUMBER_OF_HORIZONTAL_JUMPS => NUMBER_OF_HORIZONTAL_JUMPS,
		PX_PER_HORIZONTAL_JUMP => PX_PER_HORIZONTAL_JUMP,
		LINES_IN_Y_AT_LV1 => LINES_IN_Y_AT_LV1,
		LINES_IN_Y_AT_LV2 => LINES_IN_Y_AT_LV2,
		LINES_IN_Y_AT_LV3 => LINES_IN_Y_AT_LV3,
		NUMBER_OF_LEVELS => NUMBER_OF_LEVELS
	)
	port map(
		clk => clk,
		--enemy_ship_clock =>
		level => signal_level,
    enemy_ship_hit => signal_enemy_ship_hit,
		enemy_ships_x => signal_enemy_ships_x,
		enemy_ships_y => signal_enemy_ships_y,
		living_ships => signal_living_ships,
		enemy_in_base => signal_enemy_in_base
	);

END a_top_level;
