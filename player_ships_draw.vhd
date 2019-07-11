library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE PLAYER_SHIP IS
	PROCEDURE PS_DRAW(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;
							SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);
							SIGNAL DRAW: OUT STD_LOGIC);
END PLAYER_SHIP;

PACKAGE BODY PLAYER_SHIP IS
constant ship_size : integer := 80;
PROCEDURE PS_DRAW(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS
BEGIN

	IF(XPOS >= 0 AND YPOS >=0) THEN
		IF(Xcur>Xpos+408 AND Xcur<(Xpos+408+ship_size) AND Ycur>Ypos+42 AND Ycur<(Ypos+42+ship_size))THEN
			--Primeiro retangulo------------------------------------------------------------------------------
			IF(Xcur>(Xpos+408+47*ship_size/100) AND Xcur<(Xpos+408+52*ship_size/100) AND Ycur>(Ypos+42) AND Ycur<(Ypos+42+19*ship_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			-- segundo retangulo -----------------------------
			ELSIF(Xcur>(Xpos+408+38*ship_size/100) AND Xcur<(Xpos+408+61*ship_size/100) AND Ycur>(Ypos+42+17*ship_size/100) AND Ycur<(Ypos+42+50*ship_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			-- terceiro retangulo -------------------------------
			ELSIF(Xcur>(Xpos+408+7*ship_size/100) AND Xcur<(Xpos+408+92*ship_size/100) AND Ycur>(Ypos+42+49*ship_size/100) AND Ycur<(Ypos+42+60*ship_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			-- quarto retangulo ------------------------------
			ELSIF(Xcur>(Xpos+408+5*ship_size/100) AND Xcur<(Xpos+408+95*ship_size/100) AND Ycur>(Ypos+42+58*ship_size/100) AND Ycur<(Ypos+42+95*ship_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSE
				DRAW<='0';
			END IF;
		END IF;
	END IF;
 
END PS_DRAW;
END PLAYER_SHIP;