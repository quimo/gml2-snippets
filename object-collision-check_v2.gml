/**
* Object: obj_player | Event: Create
*/

distance = 5;

/**
* Object: obj_player | Event: Step
* la rilevazione della collisione avviene
* sulla "Collision mask" dello sprite
*/

// rilevazione movimento orizzontale
var x_axis = keyboard_check(vk_right) - keyboard_check(vk_left);

// rilevazione movimento verticale
var y_axis = keyboard_check(vk_down) - keyboard_check(vk_up);

// restituisce la direzione del movimento (gradi)
var movement_direction = point_direction(0, 0, x_axis, y_axis); 

// se mi muovo in orizzontale
if (x_axis != 0) {
    // controllo se nella posizione in cui sarà il player esiste una istanza di un "muro"
	var collided_obj = instance_place(x + (distance * x_axis), y, objWall);
	if (collided_obj != noone) {
        // se avviene la collisione porto il player a filo col "muro"
        // (risolve il problema della v1)
		x = collided_obj.x - (sprite_width * x_axis);
	} else {
        // se non avviene la collisione lo sposto
		x += lengthdir_x(distance, movement_direction);
	}	
}

// se mi muovo in verticale
if (y_axis != 0) {
    // controllo se nella posizione in cui sarà il player esiste una istanza di un "muro"
	var collided_obj = instance_place(x, y + (distance * y_axis), objWall);
	if (collided_obj != noone) {
        // se avviene la collisione porto il player a filo col "muro"
         // (risolve il problema della v1)
		y = collided_obj.y - (sprite_height * y_axis);
	} else {
        // se non avviene la collisione lo sposto
		y += lengthdir_y(distance, movement_direction);
	}	
}

