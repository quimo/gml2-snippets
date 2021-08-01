/**
* - Creare un livello "Istance" di nome "Lives”
* - Creare un oggetto "obj_lives" e posizionarlo nel livello
* - Importare uno sprite "spr_hearth" (cuoricino) ma NON ASSOCIARLO all'oggetto
*/

/**
* Object: obj_lives | Event: Draw GUI
*/

var x_pos;
for (i = 1; i <= obj_player.lives; i++) {
	if (i == 1) {
		x_pos = 32
	} else {
		x_pos = (32*i) - (6*(i-1));
	}	
	draw_sprite(spr_hearth, 0, x_pos, 32);
}

/**
* Object: obj_player | Event: Create
*/

lives = 3;

/**
* Object: obj_player | Event: Step
*/

var collision = instance_place(x + distance, y, obj_enemy);
if (collision != noone) {
    if (lives > 0) {
        lives--;
    } else {
        game_end();
    }  
}