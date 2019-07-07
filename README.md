# APS - Space Invaders
APS da disciplina de Lógica Reconfigurável - Space Invaders para 2 jogadores em FPGA

## Interações com o usuário
### Botões
#### Saídas
- move_l_px : `STD_LOGIC`
- move_r_px : `STD_LOGIC`
- fire_px : `STD_LOGIC`

### Display
#### Entradas
- display_data : a definir

### Buzzers
#### Entradas
- buzzer_control_px : `STD_LOGIC`

### Luzes
- light_control : `STD_LOGIC_VECTOR`

## Componentes
### Game controller
#### Descrição
- Recebe fired_p1 e fired_p2 para iniciar cada fase ("Shoot to Start")
- Conta o número de vidas de cada jogador e subtrai a cada ship_hit_px. Controlando dessa forma o Game over.
- Checa se zerou o número de naves inimigas (living_ships) e controla a passagem de nível a partir disso.
- Controla o clock do movimento da nave do player, das naves inimigas e dos tiros (através de contadores de tempo).
- Se o pulso "enemy_in_base" estiver em alto, as naves inimigas chegaram na base (nível dos players), ou seja, GAME OVER.
- `game_status`: 0 = "Shoot to start", 1 = "Game in progress", 2 = "Level transition", 3 = "Game over"

#### Entradas
- ship_hit_p1 : `STD_LOGIC`
- ship_hit_p2 : `STD_LOGIC`
- fired_p1 : `STD_LOGIC`
- fired_p2 : `STD_LOGIC`
- living_ships : `INTEGER`
- enemy_in_base : `STD_LOGIC`

#### Saídas
- game_status : `INTEGER - 2 bits`
- level : `INTEGER - 3 bits`
- lives_p1 : `INTEGER - 2 bits`
- lives_p2 : `INTEGER - 2 bits`
- shot_clock : `STD_LOGIC`
- player_ship_clock : `STD_LOGIC`
- enemy_ship_clock : `STD_LOGIC`

### Input controllers
#### Descrição 
- Faz o debounce dos botões de entrada e processa esse dado. Envia um pulso na variavel fired_px quando for feito um disparo ou envia um inteiro quando for apertado um botão de movimento (-1 -> esquerda, 0 -> parado, 1 -> direita). Esse bloco é repetido duas vezes, uma vez para cada player.
#### Entradas
- fire_px : `STD_LOGIC`
- move_l_px : `STD_LOGIC`
- move_r_px : `STD_LOGIC`
#### Saídas
- fired_px : `STD_LOGIC`
- movement_px : `INTEGER - 2 bits` (-1 - esquerda, 0 - parado, 1 - direita)

### Player ship controllers
#### Descrição
- Recebe o dado de movimento do input controller  (-1 -> esquerda, 0 -> parado, 1 -> direita) e altera a posição atual da nave. Não deve permitir movimentos para fora da tela. 
- Um movimento a cada pulso do player_ship_clock
- Quando receber o dado de que a nave foi acertada, deve resetar a nave para a posição inicial.
#### Entradas
- movement_px : `INTEGER - 2 bits` (-1 - esquerda, 0 - parado, 1 - direita)
- player_ship_clock : `STD_LOGIC`
- ship_hit_px : `STD_LOGIC`
#### Saídas
- ship_x_px : `INTEGER`
- ship_y_px : `INTEGER`

### Player shot controllers
#### Descrição
- Recebe o pulso de tiro quando o botão for apertado e a posição da nave (este bloco será duplicado, um para cada player).
- Deve permitir somente um tiro de cada vez.
- Faz o movimento vertical do tiro a cada pulso do shot_clock ( velocidade controlada e variável de acordo com o level)
#### Entradas
- shot_clock : `STD_LOGIC`
- ship_x_px : `INTEGER`
- ship_y_px : `INTEGER`
- fired_px : `STD_LOGIC`
- enemy_ship_hit_px : `STD_LOGIC`
#### Saídas
- shot_x_px : `INTEGER`
- shot_y_px : `INTEGER`
- fired_buzzer_px : `STD_LOGIC`

### Player collision controllers
#### Descrição
- Checa se houve a colisão de um tiro inimigo com a nave do player, envia um pulso na saída se a nave tiver sido acertada.
#### Entradas
- ship_x_px : `INTEGER`
- ship_y_px : `INTEGER`
- enemy_shots_x : `INTEGER_VECTOR`
- enemy_shots_y : `INTEGER_VECTOR`
#### Saídas
- ship_hit_px : `STD_LOGIC`

### Player buzzer controllers
#### Descrição
- Envia uma frequência para o buzzer no inicio do jogo, no final do jogo, acerto de um inimigo, acerto da nave do player e a cada tiro disparado pelo player.
- `game_status`: see `game_controller` definition
#### Entradas
- game_status : `INTEGER`
- enemy_ship_hit_px : `STD_LOGIC`
- ship_hit_px : `STD_LOGIC`
- fired_buzzer_p1 : `STD_LOGIC`
#### Saídas
- buzzer_control_px : `STD_LOGIC`

### Enemy ship controllers
#### Descrição
- Ao inicio de cada nível, cria fileiras de inimigos com base no nível
- Movimenta as fileiras de inimigos a cada "enemy_clock".
- Recebe o inteiro "enemy_ship_hit" (qual inimigo foi acertado) e altera no vetor a posição desse inimigo para -1, representando que ele morreu.
- A cada acerto de nave inimiga, diminui 1 em living_ships (contador de inimigos vivos).
- verifica se as naves chegaram ao nível do dos players (base). Se eles chegarem, deve enviar um pulso "enemy_in_base" (game over).
#### Entradas
- enemy_ship_clock : `STD_LOGIC`
- level : `INTEGER`
- enemy_ship_hit : `INTEGER`
#### Saídas
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`
- living_ships : `INTEGER`
- enemy_in_base : `STD_LOGIC`

### Enemy shot controllers
#### Descrição
- A cada movimento de uma nava inimiga, verifica se ela atira baseado na probabilidade de ocorrer o tiro (a verificação deve ocorrer para todas as naves inimigas).
- Se houver um novo tiro, a sua posição deverá ser enviada no enemy_shots_x e enemy_shots_y.
- Faz o movimento de cada um dos tiros já existentes, com base no shot_clock.

#### Entradas
- enemy_clock : `STD_LOGIC`
- shot_clock : `STD_LOGIC`
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`

#### Saídas
- enemy_shots_x : `INTEGER_VECTOR`
- enemy_shots_y : `INTEGER_VECTOR`

### Enemy colision controllers
#### Descrição
- Checa se houve colisão dos tiros dos players com alguma das naves inimigas.
- Se houve um acerto, envia qual nave foi acertada na saída enemy_ship_hit. Manda um pulso no enemy_ship_hit_p1 se foi o p1 que acertou o tiro ou no enemy_ship_hit_p2 se foi o p2 que acertou.
#### Entradas
- shot_x_p1 : `INTEGER`
- shot_y_p1 : `INTEGER`
- shot_x_p2 : `INTEGER`
- shot_y_p2 : `INTEGER`
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`

#### Saídas
- enemy_ship_hit : `INTEGER`
- enemy_ship_hit_p1 : `STD_LOGIC` 
- enemy_ship_hit_p2 : `STD_LOGIC` 

### Score controller
#### Descrição
- Soma pontos ao score baseado no nível atual a cada acerto de um inimigo.
#### Entradas
- level : `INTEGER`
- enemy_ship_hit_p1 : `STD_LOGIC` 
- enemy_ship_hit_p2 : `STD_LOGIC` 
#### Saídas
- score : `INTEGER`

### Light controller
#### Descrição
- Controla um led RGB que indicará o status do jogo e piscará quando o jogador for atingido.
- `game_status`: see `game_controller` definition
#### Entradas
- game_status : `INTEGER - 2 bits`
- ship_hit_p1 : `STD_LOGIC`
- ship_hit_p2 : `STD_LOGIC`
#### Saídas
- light_control_p1 : `STD_LOGIC_VECTOR`
- light_control_p2 : `STD_LOGIC_VECTOR`

### Display controller
- Mostra tudo no display através do cabo VGA
- `game_status`: see `game_controller` definition
#### Entradas
- game_status : `INTEGER - 2 bits`
- level : `INTEGER - 3 bits`
- lives_p1 : `INTEGER - 2 bits`
- lives_p2 : `INTEGER - 2 bits`
- score : `INTEGER`
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`
- enemy_shots_x : `INTEGER_VECTOR`
- enemy_shots_y : `INTEGER_VECTOR`
- shot_x_p1 : `INTEGER`
- shot_y_p1 : `INTEGER`
- shot_x_p2 : `INTEGER`
- shot_y_p2 : `INTEGER`
- ship_x_p1 : `INTEGER`
- ship_y_p1 : `INTEGER`
- ship_x_p2 : `INTEGER`
- ship_y_p2 : `INTEGER`
#### Saídas
- display_data : `A DEFINIR`
