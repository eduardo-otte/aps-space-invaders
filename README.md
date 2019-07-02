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
#### Entradas
- ship_hit_p1 : `INTEGER`
- ship_hit_p2 : `INTEGER`
- fired_p1 : `STD_LOGIC`
- fired_p2 : `STD_LOGIC`
- living_ships : `INTEGER`
#### Saídas
- game_status : `INTEGER - 2 bits`
- level : `INTEGER - 3 bits`
- lives_p1 : `INTEGER - 2 bits`
- lives_p2 : `INTEGER - 2 bits`

### Input controllers
#### Entradas
- fire_px : `STD_LOGIC`
- move_l_px : `STD_LOGIC`
- move_r_px : `STD_LOGIC`
#### Saídas
- fired_px : `STD_LOGIC`
- movement_px : `INTEGER - 2 bits` (-1 - esquerda, 0 - parado, 1 - direita)

### Player ship controllers
#### Entradas
- movement_px : `INTEGER - 2 bits` (-1 - esquerda, 0 - parado, 1 - direita)
- ship_hit_px : `INTEGER`
#### Saídas
- ship_x_px : `INTEGER`
- ship_y_px : `INTEGER`

### Player shot controllers
#### Entradas
- ship_x_px : `INTEGER`
- ship_y_px : `INTEGER`
- fired_px : `STD_LOGIC`
- enemy_ship_hit_px : `STD_LOGIC`
#### Saídas
- shot_x_px : `INTEGER`
- shot_y_px : `INTEGER`
- fired_buzzer_px : `STD_LOGIC`

### Player collision controllers
#### Entradas
- ship_x_px : `INTEGER`
- ship_y_px : `INTEGER`
- enemy_shots_x : `INTEGER_VECTOR`
- enemy_shots_y : `INTEGER_VECTOR`
#### Saídas
- ship_hit_px : `INTEGER`

### Player buzzer controllers
#### Entradas
- game_status : `INTEGER`
- enemy_ship_hit_px : `STD_LOGIC`
- ship_hit_px : `INTEGER`
- fired_buzzer_p1 : `STD_LOGIC`
#### Saídas
- buzzer_control_px : `STD_LOGIC`

### Enemy ship controllers
#### Entradas
- level : `INTEGER`
- enemy_ship_hit : `INTEGER`
#### Saídas
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`
- living_ships : `INTEGER`

### Enemy shot controllers
#### Entradas
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`

#### Saídas
- enemy_shots_x : `INTEGER_VECTOR`
- enemy_shots_y : `INTEGER_VECTOR`

### Enemy colission controllers
#### Entradas
- shot_x_p1 : `INTEGER`
- shot_y_p1 : `INTEGER`
- shot_x_p2 : `INTEGER`
- shot_y_p2 : `INTEGER`
- enemy_ships_x : `INTEGER_VECTOR`
- enemy_ships_y : `INTEGER_VECTOR`

#### Saídas
- enemy_ship_hit : `INTEGER`
- enemy_ship_hit_p1 : `INTEGER` 
- enemy_ship_hit_p2 : `INTEGER` 

### Score controller
#### Entradas
- level : `INTEGER`
- enemy_ship_hit_p1 : `INTEGER` 
- enemy_ship_hit_p2 : `INTEGER` 
#### Saídas
- score : `INTEGER`

### Light controller
#### Entradas
- game_status : `INTEGER - 2 bits`
#### Saídas
- fired_px : `STD_LOGIC_VECTOR`

### Display controller
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
- display_data :  'A DEFINIR'
