LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY input_controller IS
    PORT(
        clk : IN STD_LOGIC;
        move_l : IN STD_LOGIC;
        move_r : IN STD_LOGIC;
        fire : IN STD_LOGIC;
        fired : OUT STD_LOGIC;
        movement : OUT INTEGER
    );
END;

ARCHITECTURE input_controller OF input_controller IS
    COMPONENT debounce
	  GENERIC(
		 counter_size  :  INTEGER := 23); --counter size (19 bits gives 10.5ms with 50MHz clock)
	  PORT(
		 clk     : IN  STD_LOGIC;
		 botao   : IN  STD_LOGIC;
		 resultado  : OUT STD_LOGIC);
	END COMPONENT debounce;

    -- Debounce signals
    signal move_l_deb : STD_LOGIC := '0';
    signal move_r_deb : STD_LOGIC := '0';
    signal fire_deb : STD_LOGIC := '0';

    -- Output signals
    signal fired_signal : STD_LOGIC := '0';
    signal movement_signal : INTEGER := 0;

BEGIN
    deb_move_l : debounce
	generic map (counter_size => 23)
	port map (
        clk => clk ,
        botao => move_l,
        resultado => move_l_deb
    );

    deb_move_r : debounce
	generic map (counter_size => 23)
	port map (
        clk => clk ,
        botao => move_r,
        resultado => move_r_deb
    );

    deb_fire : debounce
	generic map (counter_size => 23)
	port map (
        clk => clk ,
        botao => fire,
        resultado => fire_deb
    );

    movement <= movement_signal;
    fired <= fired_signal;

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF move_l_deb = '1' and move_r_deb = '0' THEN
                movement_signal <= -1;
            ELSIF move_l_deb = '0' and move_r_deb = '1' THEN
                movement_signal <= 1;
            ELSIF (move_l_deb = '0' and move_r_deb = '0') 
            or (move_l_deb = '1' and move_r_deb = '1') THEN
                movement_signal <= 0;
            END IF;

            IF fire_deb = '1' THEN
                fired_signal <= '1';
            ELSE
                fired_signal <= '0';
            END IF;
        END IF;
    END PROCESS;

END;