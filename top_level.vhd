LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY top_level IS
    PORT(
        clk : IN STD_LOGIC;
        move_l_p1 : IN STD_LOGIC;
        move_r_p1 : IN STD_LOGIC;
        fire_p1 : IN STD_LOGIC;
        move_l_p2 : IN STD_LOGIC;
        move_r_p2: IN STD_LOGIC;
        fire_p2 : IN STD_LOGIC;
        light_control_p1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        light_control_p2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		-- Saídas dos buzzers
	);
END;

ARCHITECTURE top_level OF top_level IS
    COMPONENT input_controller
	PORT(
		clk : IN STD_LOGIC;
		move_l : IN STD_LOGIC;
		move_r : IN STD_LOGIC;
		fire : IN STD_LOGIC;
		fired : OUT STD_LOGIC;
		movement : OUT INTEGER
	);
	END COMPONENT input_controller;

    COMPONENT score_controller IS
		PORT(
		clk : IN STD_LOGIC;
		level : IN INTEGER;
		enemy_ship_hit_p1 : IN STD_LOGIC;
		enemy_ship_hit_p2 : IN STD_LOGIC;
		score : OUT INTEGER
	);
	END COMPONENT score_controller;

    COMPONENT light_controller IS
		GENERIC(
			counter_size  :  INTEGER := 21 --counter size (19 bits gives 10.5ms with 50MHz clock)
		);
		PORT(
			clk : IN STD_LOGIC;
			ship_hit_p1 : IN STD_LOGIC;
			ship_hit_p2 : IN STD_LOGIC;
			game_status : IN INTEGER; -- 0 = "Shoot to start", 1 = "Game in progress", 2 = "Level transition", 3 = "Game over"
			light_control_p1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			light_control_p2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)  
		);
	END COMPONENT light_controller;

    COMPONENT game_controller IS
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
			lives_p2 : OUT INTEGER
		);
		END COMPONENT game_controller;

    COMPONENT enemy_shoot_controler IS
		GENERIC (
			NUM_MAX_SHOOT: INTEGER := 15;
			NUM_MAX_ENEMY: INTEGER := 64;
			NUMBER_OF_LEVELS: INTEGER := 3
		);
		PORT(
			clk : IN STD_LOGIC;
			enemy_clock, shot_clock : IN STD_LOGIC;
			enemy_ships_x, enemy_ships_y : IN INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
			level : IN INTEGER;
			enemy_shots_x : OUT INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0);
			enemy_shots_y : OUT INTEGER_VECTOR((NUM_MAX_SHOOT)-1 downto 0) 
		);
	END COMPONENT enemy_shoot_controler;

    COMPONENT enemy_ship_controller IS
		GENERIC (
			NUM_MAX_ENEMY : INTEGER := 64;
			NUM_MAX_ENEMY_PER_LINE : INTEGER := 8;
			DISPLAY_HIGH : INTEGER := 900;
			PX_BOARDER_LEFT : INTEGER := 130;
			PX_BORDA_TOP : INTEGER := 130;
			PX_BORDA_BOTTON : INTEGER := 130;
			ENEMY_WIDTH : INTEGER := 80;
			LINES_IN_Y_AT_LV1 : INTEGER := 2;
			LINES_IN_Y_AT_LV2 : INTEGER := 4;
			LINES_IN_Y_AT_LV3 : INTEGER := 6;
			NUMBER_OF_LEVELS : INTEGER := 3
		);
		PORT(
			clk : IN STD_LOGIC;
			enemy_ship_clock:   	IN STD_LOGIC;
			level, enemy_ship_hit:  IN INTEGER;
			enemy_ships_x: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
			enemy_ships_y: 			OUT INTEGER_VECTOR((NUM_MAX_ENEMY)-1 downto 0);
			living_ships : 			OUT INTEGER;
			enemy_in_base: 			OUT STD_LOGIC
		);
	END COMPONENT enemy_ship_controller;

    COMPONENT enemy_colision_controler IS
    	PORT(
    		game_rst: IN STD_LOGIC; -- Acho que precisa deste caso para resetar as naves ou coisas do tipo
    		shot_x_p1, shot_y_p1, shot_x_p2, shot_y_p2: IN INTEGER;
    		-- Need to import to this component what is integer_vector
    		enemy_ships_x, enemy_ships_y: 	IN INTEGER_VECTOR;
    		enemy_ship_hit: OUT INTEGER;
    		enemy_ship_hit_p1, enemy_ship_hit_p2: OUT STD_LOGIC	
		);
	END COMPONENT enemy_colision_controler;

    --signals
    signal_fired_p1, signal_fired_p2 : std_LOGIC := '0';
    signal_movement_p1, signal_movement_p2 : INTEGER := 0;
    signal_level, signal_score : INTEGER := 0;
    signal_game_status : INTEGER := 0;
    signal_light_control_p1,signal_light_control_p2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal_ship_hit_p1, signal_ship_hit_p2 : STD_LOGIC := '0';
    signal_enemy_in_base : STD_LOGIC := '0';
    signal_enemy_ship_hit_p1, signal_enemy_ship_hit_p2 : STD_LOGIC := '0';
    signal_lives_p1, signal_lives_p2 : INTEGER := 0;
    signal_living_ships : INTEGER := 0;


BEGIN

    light_control_p1 <= signal_light_control_p1;
    light_control_p2 <= signal_light_control_p2;

    input_controller_p1: input_controller
	port map (
		clk => clk;
		move_l => move_l_p1;
		move_r => move_r_p1;
		fire => fire_p1;
		fired => signal_fired_p1;
		movement => signal_movement_p1
	);

    input_controller_p2: input_controller
	port map (
		clk => clk;
		move_l => move_l_p2;
		move_r => move_r_p2;
		fire => fire_p2;
		fired => signal_fired_p2;
		movement => signal_movement_p2
	);

    score_controller : score_controller
	port map(
		clk => clk;
		level => signal_level;
		enemy_ship_hit_p1 => signal_enemy_ship_hit_p1;
		enemy_ship_hit_p2 => signal_enemy_ship_hit_p2;
		score => signal_score
	);

    light_controller : light_controller
	generic map (INITIAL_PLAYER_LIVES => 3)
	port map(
		clk => clk;
		ship_hit_p1 => signal_ship_hit_p1;
		ship_hit_p2 => signal_ship_hit_p2;
		game_status => signal_game_status; -- 0 = "Shoot to start", 1 = "Game in progress", 2 = "Level transition", 3 = "Game over"
		light_control_p1 => signal_light_control_p1;
		light_control_p2 => signal_light_control_p2
	);

    game_controller : game_controller
	generic map (INITIAL_PLAYER_LIVES => 3 );
	port map(
		clk => clk;
		ship_hit_p1 => signal_ship_hit_p1;
		ship_hit_p2 => signal_ship_hit_p2;
		fired_p1 => signal_fired_p1;
		fired_p2 => signal_fired_p2;
		enemy_in_base => signal_enemy_in_base;
		living_ships => signal_living_ships;
		game_status => signal_game_status;
		level => signal_level;
		lives_p1 => signal_lives_p1;
		lives_p2 => signal_lives_p2
	);

    enemy_shoot_controler : enemy_shoot_controler
	generic map (
		NUM_MAX_SHOOT => 15;
		NUM_MAX_ENEMY => 64;
		NUMBER_OF_LEVELS => 3   
	);
	generic port (
		clk => clk;
		-- tirar esses clocks fora?
		-- enemy_clock => 
		-- shot_clock => IN STD_LOGIC;
		enemy_ships_x => ;
		enemy_ships_y => ;
		level => signal_level;
		enemy_shots_x => ;
		enemy_shots_y =>  
	);

    moleGenerator : moleGenerator
	generic map (
		NUM_MAX_ENEMY => 64;
		NUM_MAX_ENEMY_PER_LINE => 8;
		DISPLAY_HIGH => 900;
		PX_BOARDER_LEFT => 130;
		PX_BORDA_TOP => 130;
		PX_BORDA_BOTTON => 130;
		ENEMY_WIDTH => 80;
		LINES_IN_Y_AT_LV1 => 2;
		LINES_IN_Y_AT_LV2 => 4;
		LINES_IN_Y_AT_LV3 => 6;
		NUMBER_OF_LEVELS => 3
	);
	port map(
		clk => ;
		enemy_ship_clock => ;
		level, enemy_ship_hit => ;
		enemy_ships_x => ;
		enemy_ships_y => ;
		living_ships => ;
		enemy_in_base => 
	);

    enemy_colision_controler : enemy_colision_controler
	port map (
		game_rst: ;
		shot_x_p1 => 
		shot_y_p1 =>
		shot_x_p2 => 
		shot_y_p2 => ;
		enemy_ships_x => 
		enemy_ships_y => ;
		enemy_ship_hit => ;
		enemy_ship_hit_p1 => 
		enemy_ship_hit_p2 =>
	);







END;
