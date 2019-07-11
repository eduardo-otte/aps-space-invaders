library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PLAYER_SHIP.all;
use work.ENEMY_SHIP.all;
use work.INTEGER_VECTOR.all;

ENTITY SYNC IS
GENERIC (
	ALIEN_NUMBER : INTEGER RANGE 0 TO 100 := 32;
	SHOTS_NUMBER : INTEGER RANGE 0 TO 20 := 10;
	SHOT_SIZE_X : INTEGER RANGE -10 TO 1200 := 10;
	SHOT_SIZE_Y : INTEGER RANGE -10 TO 1200 := 40;
	BATTLEFIELD_SIZE : INTEGER RANGE -10 TO 1200 := 900
	);
PORT(
	CLK: IN STD_LOGIC;
	HSYNC: OUT STD_LOGIC;
	VSYNC: OUT STD_LOGIC;
	GAME_STATUS: IN INTEGER RANGE 0 TO 3;
	LEVEL : IN INTEGER RANGE 0 TO 7;
	LIVES_P1: IN INTEGER RANGE 0 TO 3;
	LIVES_P2: IN INTEGER RANGE 0 TO 3;
	SCORE: IN INTEGER RANGE -10 TO 1200;
	ENEMY_SHIPS_X : IN INTEGER_VECTOR(ALIEN_NUMBER-1 downto 0);
	ENEMY_SHIPS_Y : IN INTEGER_VECTOR(ALIEN_NUMBER-1 downto 0);
	ENEMY_SHOTS_X : IN INTEGER_VECTOR(SHOTS_NUMBER-1 downto 0);
	ENEMY_SHOTS_Y : IN INTEGER_VECTOR(SHOTS_NUMBER-1 downto 0);
	SHOT_X_P1 : IN INTEGER RANGE 0 TO 1200;
	SHOT_Y_P1 : IN INTEGER RANGE 0 TO 1200;
	SHOT_X_P2 : IN INTEGER RANGE 0 TO 1200;
	SHOT_Y_P2 : IN INTEGER RANGE 0 TO 1200;
	SHIP_X_P1 : IN INTEGER RANGE 0 TO 1200;
	SHIP_Y_P1 : IN INTEGER RANGE 0 TO 1200;
	SHIP_X_P2 : IN INTEGER RANGE 0 TO 1200;
	SHIP_Y_P2 : IN INTEGER RANGE 0 TO 1200;
	R: OUT STD_LOGIC_VECTOR(3 downto 0);
	G: OUT STD_LOGIC_VECTOR(3 downto 0);
	B: OUT STD_LOGIC_VECTOR(3 downto 0)
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS

COMPONENT PixelGen IS
	PORT(
		F_CLOCK : IN STD_LOGIC; -- Entrada de clock (50 MHz)
		F_ON : IN STD_LOGIC; --Indica a região ativa do frame
		F_ROW_INT : IN INTEGER RANGE 0 TO 1066; -- Índice da linha que está sendo processada
		F_COLUMN_INT : IN INTEGER RANGE 0 TO 1688; -- Índice da coluna que está sendo processada
		GAME_STATUS: IN INTEGER RANGE 0 TO 3;
		R_OUT : OUT STD_LOGIC; -- Componente R
		G_OUT : OUT STD_LOGIC; -- Componente G
		B_OUT : OUT STD_LOGIC -- Componente B
	);
END COMPONENT PixelGen;

-----                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 @ 60 Hz pixel clock 108 MHz
SIGNAL RGB: STD_LOGIC_VECTOR(3 downto 0);

SIGNAL ALIEN_X,ALIEN_Y: INTEGER RANGE 0 TO 1688:=0;
SIGNAL DRAW_ALIEN0,DRAW_ALIEN1,DRAW_ALIEN2,DRAW_ALIEN3,DRAW_ALIEN4,DRAW_ALIEN5,DRAW_ALIEN6,DRAW_ALIEN7,DRAW_ALIEN8,DRAW_P1,DRAW_P2:STD_LOGIC:='0';
SIGNAL DRAW_ALIEN9,DRAW_ALIEN10,DRAW_ALIEN11,DRAW_ALIEN12,DRAW_ALIEN13,DRAW_ALIEN14,DRAW_ALIEN15:STD_LOGIC:='0';
--1280 visible pixels + 48 pixels FP + 248 pixels BP + 112 sync pulse
SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0;
--1024 visible pixels + 1 pixels FP + 38 pixels BP + 3 sync pulse
SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;

---TEXTO ATIVO
SIGNAL TEXT_ON : STD_LOGIC := '0';
SIGNAL R_OUT_TEXT,G_OUT_TEXT,B_OUT_TEXT : std_LOGIC := '0';

BEGIN
	TEXT_COMPONENT: PixelGen PORT MAP (CLK,TEXT_ON,VPOS,HPOS,GAME_STATUS,R_OUT_TEXT,G_OUT_TEXT,B_OUT_TEXT);
	PS_DRAW(HPOS,VPOS,SHIP_X_P1,SHIP_Y_P1,RGB,DRAW_P1);
	PS_DRAW(HPOS,VPOS,SHIP_X_P2,SHIP_Y_P2,RGB,DRAW_P2);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(0),ENEMY_SHIPS_Y(0),RGB,DRAW_ALIEN0);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(1),ENEMY_SHIPS_Y(1),RGB,DRAW_ALIEN1);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(2),ENEMY_SHIPS_Y(2),RGB,DRAW_ALIEN2);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(3),ENEMY_SHIPS_Y(3),RGB,DRAW_ALIEN3);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(4),ENEMY_SHIPS_Y(4),RGB,DRAW_ALIEN4);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(5),ENEMY_SHIPS_Y(5),RGB,DRAW_ALIEN5);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(6),ENEMY_SHIPS_Y(6),RGB,DRAW_ALIEN6);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(7),ENEMY_SHIPS_Y(7),RGB,DRAW_ALIEN7);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(8),ENEMY_SHIPS_Y(8),RGB,DRAW_ALIEN8);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(9),ENEMY_SHIPS_Y(9),RGB,DRAW_ALIEN9);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(10),ENEMY_SHIPS_Y(10),RGB,DRAW_ALIEN10);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(11),ENEMY_SHIPS_Y(11),RGB,DRAW_ALIEN11);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(12),ENEMY_SHIPS_Y(12),RGB,DRAW_ALIEN12);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(13),ENEMY_SHIPS_Y(13),RGB,DRAW_ALIEN13);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(14),ENEMY_SHIPS_Y(14),RGB,DRAW_ALIEN14);
	ES_DRAW(HPOS,VPOS,ENEMY_SHIPS_X(15),ENEMY_SHIPS_Y(15),RGB,DRAW_ALIEN15);
	
	
	PROCESS(CLK)
	variable DIDNT_DRAW : STD_LOGIC := '1';
	BEGIN
		IF(CLK'EVENT AND CLK='1')THEN
			IF(GAME_STATUS = 1) THEN
				DIDNT_DRAW := '1';
			
				IF(DRAW_P1='1')THEN
					R<=(others=>'0');
					G<=(others=>'0');
					B<=(others=>'1');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_P2='1')THEN
					R<=(others=>'1');
					G<=(others=>'0');
					B<=(others=>'0');
					DIDNT_DRAW := '0';	
				ELSIF(DRAW_ALIEN0='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';		
				ELSIF(DRAW_ALIEN1='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN2='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';		
				ELSIF(DRAW_ALIEN3='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN4='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';		
				ELSIF(DRAW_ALIEN5='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN6='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN7='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';		
				ELSIF(DRAW_ALIEN8='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN9='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN10='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN11='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';		
				ELSIF(DRAW_ALIEN12='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN13='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF(DRAW_ALIEN14='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';		
				ELSIF(DRAW_ALIEN15='1')THEN
					R<=(others=>'0');
					G<=(others=>'1');
					B<=(others=>'0');
					DIDNT_DRAW := '0';
				ELSIF	(SHOT_X_P1 >= 0 AND HPOS > SHOT_X_P1+408 AND HPOS < SHOT_X_P1+408+SHOT_SIZE_X AND 
					 SHOT_Y_P1 >= 0 AND VPOS > SHOT_Y_P1+42 AND VPOS < SHOT_Y_P1+42+SHOT_SIZE_Y) THEN
					R<=(others=>'1');
					G<=(others=>'0');
					B<=(others=>'1');
					DIDNT_DRAW := '0';
				ELSIF (SHOT_X_P2 >= 0 AND HPOS > SHOT_X_P2+408 AND HPOS < SHOT_X_P2+408+SHOT_SIZE_X AND 
					 SHOT_Y_P2 >= 0 AND VPOS > SHOT_Y_P2+42 AND VPOS < SHOT_Y_P2+42+SHOT_SIZE_Y) THEN
					R<=(others=>'1');
					G<=(others=>'0');
					B<=(others=>'1');
					DIDNT_DRAW := '0';
				ELSE
					DIDNT_DRAW := '1';
				END IF;
				
				
				IF(DIDNT_DRAW = '1') THEN
					FOR I IN 0 TO SHOTS_NUMBER -1 LOOP
						IF	(ENEMY_SHOTS_X(I) >= 0 AND HPOS > ENEMY_SHOTS_X(I)+408 AND HPOS < ENEMY_SHOTS_X(I)+408+SHOT_SIZE_X AND 
							 ENEMY_SHOTS_Y(I) >= 0 AND VPOS > ENEMY_SHOTS_Y(I)+42 AND VPOS < ENEMY_SHOTS_Y(I)+42+SHOT_SIZE_Y)	THEN
							R<=(others=>'1');
							G<=(others=>'1');
							B<=(others=>'1');
							DIDNT_DRAW := '0';
							exit;
						ELSE 
							DIDNT_DRAW := '1';
						END IF;
					END LOOP;
				END IF;

				IF(VPOS>42+BATTLEFIELD_SIZE AND HPOS < 408+BATTLEFIELD_SIZE)THEN
					R<="1100";
					G<="1000";
					B<="0010";
					DIDNT_DRAW := '0';
				END IF;
				
				IF (DIDNT_DRAW = '1') THEN	
					R<=(others=>'0');
					G<=(others=>'0');
					B<=(others=>'0');
				END IF;
				
			ELSIF(GAME_STATUS = 2 OR GAME_STATUS = 0 OR GAME_STATUS = 3) THEN
				TEXT_ON <= '1';
				R<=(others=>R_OUT_TEXT);
				G<=(others=>G_OUT_TEXT);
				B<=(others=>B_OUT_TEXT);
			ELSE
				R<=(others=>'0');
				G<=(others=>'0');
				B<=(others=>'0');
			END IF;	
			
			IF(HPOS<1688)THEN
				HPOS<=HPOS+1;
			ELSE
				HPOS<=0;
				IF(VPOS<1066)THEN
				  VPOS<=VPOS+1;
				  ELSE
				  VPOS<=0;  
				END IF;
			END IF;
			IF((HPOS>0 AND HPOS<408) OR (VPOS>0 AND VPOS<42))THEN
				R<=(others=>'0');
				G<=(others=>'0');
				B<=(others=>'0');
			END IF;
			IF(HPOS>48 AND HPOS<160)THEN----HSYNC
				HSYNC<='0';
			ELSE
				HSYNC<='1';
			END IF;
			IF(VPOS>0 AND VPOS<4)THEN----------vsync
				VSYNC<='0';
			ELSE
				VSYNC<='1';
			END IF;
			
		 END IF;
	 END PROCESS;
 END MAIN;