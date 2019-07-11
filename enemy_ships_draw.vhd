library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE ENEMY_SHIP IS
	PROCEDURE ES_DRAW(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;
							SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);
							SIGNAL DRAW: OUT STD_LOGIC);
END ENEMY_SHIP;

PACKAGE BODY ENEMY_SHIP IS
constant alien_size : integer := 80;
PROCEDURE ES_DRAW(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS
BEGIN

	IF(XPOS >= 0 AND YPOS >=0) THEN
		IF(Xpos >= 0 AND Xcur>Xpos+408 AND Xcur<(Xpos+alien_size+408) AND Ycur>Ypos+42 AND Ycur<(Ypos+42+alien_size))THEN
			--Antenas------------------------------------------------------------------------------
			IF(Xcur>(Xpos+408+17*alien_size/100) AND Xcur<(Xpos+408+27*alien_size/100) AND Ycur>(Ypos+5*alien_size/100+42) AND Ycur<(Ypos+42+13*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+71*alien_size/100) AND Xcur<(Xpos+408+82*alien_size/100) AND Ycur>(Ypos+5*alien_size/100+42) AND Ycur<(Ypos+42+13*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+26*alien_size/100) AND Xcur<(Xpos+408+37*alien_size/100) AND Ycur>(Ypos+42+12*alien_size/100) AND Ycur<(Ypos+42+28*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+62*alien_size/100) AND Xcur<(Xpos+408+73*alien_size/100) AND Ycur>(Ypos+42+12*alien_size/100) AND Ycur<(Ypos+42+28*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			-- primeira linha corpo -----------------------------
			ELSIF(Xcur>(Xpos+408+17*alien_size/100) AND Xcur<(Xpos+408+82*alien_size/100) AND Ycur>(Ypos+42+24*alien_size/100) AND Ycur<(Ypos+42+38*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			-- segunda linha corpo -------------------------------
			ELSIF(Xcur>(Xpos+408+8*alien_size/100) AND Xcur<(Xpos+408+27*alien_size/100) AND Ycur>(Ypos+42+37*alien_size/100) AND Ycur<(Ypos+42+51*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+36*alien_size/100) AND Xcur<(Xpos+408+63*alien_size/100) AND Ycur>(Ypos+42+37*alien_size/100) AND Ycur<(Ypos+42+51*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+72*alien_size/100) AND Xcur<(Xpos+408+94*alien_size/100) AND Ycur>(Ypos+42+37*alien_size/100) AND Ycur<(Ypos+42+51*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
			-- terceira linha corpo -----------------------------
			ELSIF(Xcur>(Xpos+408+5*alien_size/100) AND Xcur<(Xpos+408+94*alien_size/100) AND Ycur>(Ypos+42+49*alien_size/100) AND Ycur<(Ypos+42+63*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
			-- quarta linha do corpo ------------------------------
			ELSIF(Xcur>(Xpos+408+5*alien_size/100) AND Xcur<(Xpos+408+10*alien_size/100) AND Ycur>(Ypos+42+62*alien_size/100) AND Ycur<(Ypos+42+74*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+18*alien_size/100) AND Xcur<(Xpos+408+82*alien_size/100) AND Ycur>(Ypos+42+62*alien_size/100) AND Ycur<(Ypos+42+74*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+89*alien_size/100) AND Xcur<(Xpos+408+94*alien_size/100) AND Ycur>(Ypos+42+62*alien_size/100) AND Ycur<(Ypos+42+74*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			--- pernas			
			ELSIF(Xcur>(Xpos+408+5*alien_size/100) AND Xcur<(Xpos+408+10*alien_size/100) AND Ycur>(Ypos+42+73*alien_size/100) AND Ycur<(Ypos+42+87*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+17*alien_size/100) AND Xcur<(Xpos+408+28*alien_size/100) AND Ycur>(Ypos+42+73*alien_size/100) AND Ycur<(Ypos+42+87*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+71*alien_size/100) AND Xcur<(Xpos+408+82*alien_size/100) AND Ycur>(Ypos+42+73*alien_size/100) AND Ycur<(Ypos+42+87*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+89*alien_size/100) AND Xcur<(Xpos+408+94*alien_size/100) AND Ycur>(Ypos+42+73*alien_size/100) AND Ycur<(Ypos+42+87*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+26*alien_size/100) AND Xcur<(Xpos+408+45*alien_size/100) AND Ycur>(Ypos+42+86*alien_size/100) AND Ycur<(Ypos+42+98*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSIF(Xcur>(Xpos+408+55*alien_size/100) AND Xcur<(Xpos+408+72*alien_size/100) AND Ycur>(Ypos+42+86*alien_size/100) AND Ycur<(Ypos+42+98*alien_size/100))THEN
				RGB<="1111";
				DRAW<='1';
				
			ELSE
				DRAW<='0';
			END IF;
		END IF;
	END IF;
 
END ES_DRAW;
END ENEMY_SHIP;