LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PixelGen IS
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

END ENTITY PixelGen;

ARCHITECTURE arch OF PixelGen IS

	COMPONENT font_rom IS
		port(
			clk: in std_logic;
			addr: in std_logic_vector(10 downto 0);
			data: out std_logic_vector(7 downto 0)
		);
	END COMPONENT font_rom;
	
	--Coordenadas X e Y do pixel atual
   SIGNAL pix_x, pix_y: UNSIGNED(11 DOWNTO 0);
	
	-- posicao letra
	signal pos_letra : STD_LOGIC_VECTOR (8 DOWNTO 0);
	
	--Endereço que será acessado na memória de caracteres
   SIGNAL rom_addr: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL F_ROW,F_COLUMN: STD_LOGIC_VECTOR(11 DOWNTO 0);	
	
	--Código ASCII do caractere atual (parte do endereço)
   SIGNAL char_addr: STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	--Parte do caractere (0~15) que está sendo exibida na linha atual Y
   SIGNAL row_addr: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	--Pixel relativo a coordenada X atual
   SIGNAL bit_addr: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	--Conteúdo armazenado no endereço indicado por 'rom_addr'
   SIGNAL font_word: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	--Valor do bit 'bit_addr' na palavra 'font_word'
   SIGNAL font_bit: STD_LOGIC;
	
	--Valor das componentes rgb
   SIGNAL font_rgb: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	--Flag que indica se a frase deve ser exibida
   SIGNAL txt_on: STD_LOGIC;

BEGIN
	
	F_ROW <= std_logic_vector(to_unsigned(F_ROW_INT, F_ROW'length));
	F_COLUMN <= std_logic_vector(to_unsigned(F_COLUMN_INT, F_COLUMN'length));
	
	-- Coordenadas XY atuais
	pix_x <= UNSIGNED(F_COLUMN(11 DOWNTO 0));
	pix_y <= UNSIGNED(F_ROW);
	
	-- posicao letra
	pos_letra <= F_COLUMN(11 DOWNTO 3);
	
	-- Memória dos caracteres
	font_unit: font_rom PORT MAP(clk=>not F_CLOCK, addr=>rom_addr, data=>font_word);
	
	-- Determinação do endereço que será acessado
	row_addr <= STD_LOGIC_VECTOR(pix_y(3 DOWNTO 0));
	rom_addr <= char_addr & row_addr;

	txt_on <= '1' WHEN (pix_x >= 800 AND pix_x <= 1200) AND (pix_y >= 500 AND pix_y <= 513) ELSE
			  '0';
	char_addr <=
			"1110011" WHEN pos_letra = "001101100" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- s
			"1101000" WHEN pos_letra = "001101101" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- h
			"1101111" WHEN pos_letra = "001101110" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- o
			"1101111" WHEN pos_letra = "001101111" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- o
			"1110100" WHEN pos_letra = "001110000" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- t
			"0000000" WHEN pos_letra = "001110001" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- 
			"1110100" WHEN pos_letra = "001110010" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- t
			"1101111" WHEN pos_letra = "001110011" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- o
			"0000000" WHEN pos_letra = "001110100" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- 
			"1110011" WHEN pos_letra = "001110101" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- s
			"1110100" WHEN pos_letra = "001110110" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- t
			"1100001" WHEN pos_letra = "001110111" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- a
			"1110010" WHEN pos_letra = "001111000" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- r
			"1110100" WHEN pos_letra = "001111001" AND (GAME_STATUS = 0 OR GAME_STATUS = 2) ELSE -- t
			"0000000" WHEN pos_letra = "001111010" AND (GAME_STATUS = 2) ELSE -- 
			"1101110" WHEN pos_letra = "001111011" AND (GAME_STATUS = 2) ELSE -- n
			"1100101" WHEN pos_letra = "001111100" AND (GAME_STATUS = 2) ELSE -- e
			"1111000" WHEN pos_letra = "001111101" AND (GAME_STATUS = 2) ELSE -- x
			"1110100" WHEN pos_letra = "001111110" AND (GAME_STATUS = 2) ELSE -- t
			"0000000" WHEN pos_letra = "001111111" AND (GAME_STATUS = 2) ELSE -- 
			"1101100" WHEN pos_letra = "010000000" AND (GAME_STATUS = 2) ELSE -- l
			"1100101" WHEN pos_letra = "010000001" AND (GAME_STATUS = 2) ELSE -- e
			"1110110" WHEN pos_letra = "010000010" AND (GAME_STATUS = 2) ELSE -- v
			"1100101" WHEN pos_letra = "010000011" AND (GAME_STATUS = 2) ELSE -- e
			"1101100" WHEN pos_letra = "010000100" AND (GAME_STATUS = 2) ELSE -- l
			"1100111" WHEN pos_letra = "001101100" AND (GAME_STATUS = 3) ELSE -- g
			"1100001" WHEN pos_letra = "001101101" AND (GAME_STATUS = 3) ELSE -- a
			"1101101" WHEN pos_letra = "001101110" AND (GAME_STATUS = 3) ELSE -- m
			"1100101" WHEN pos_letra = "001101111" AND (GAME_STATUS = 3) ELSE -- e
			"0000000" WHEN pos_letra = "001110000" AND (GAME_STATUS = 3) ELSE -- 
			"1101111" WHEN pos_letra = "001110001" AND (GAME_STATUS = 3) ELSE -- o
			"1110110" WHEN pos_letra = "001110010" AND (GAME_STATUS = 3) ELSE -- v
			"1100101" WHEN pos_letra = "001110011" AND (GAME_STATUS = 3) ELSE -- e
			"1110010" WHEN pos_letra = "001110100" AND (GAME_STATUS = 3) ELSE -- r
			
			"0000000";
					
	
   
	
	bit_addr <= NOT STD_LOGIC_VECTOR(pix_x(2 DOWNTO 0));
	font_bit <= font_word(to_integer(UNSIGNED( bit_addr))); 
	
	font_rgb <="111" WHEN font_bit='1' ELSE "000";

	PROCESS(F_ON,font_rgb,txt_on)
	BEGIN
		
		IF F_ON ='0' or txt_on='0' THEN
			 R_OUT <= '0';
			 G_OUT <= '0';
			 B_OUT <= '0';
		ELSE
			 R_OUT <= font_rgb(0);
			 G_OUT <= font_rgb(1);
			 B_OUT <= font_rgb(2);		 
		END IF;
	END PROCESS; 
	
END ARCHITECTURE arch;