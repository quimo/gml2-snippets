/**
* Object: obj_player | Event: Create
*/

distance = 5;
collision_gap = distance + 1;

/**
* Object: obj_player | Event: Step
* La collisione è rilevata solo se
* gli oggetti che vengono a contatto
* hanno flaggato l'attributo "Solid"
*/

var key_right = keyboard_check(vk_right);
var key_left = keyboard_check(vk_left);
var key_down = keyboard_check(vk_down);
var key_up = keyboard_check(vk_up);

// rilevazione movimento orizzontale
var x_axis = key_right - key_left;

// rilevazione movimento verticale
var y_axis = key_down - key_up;

// restituisce la direzione del movimento (gradi)
var movement_direction = point_direction(0, 0, x_axis, y_axis); 

/* 
* se un tasto movimento è premuto e se la posizione
* che il player andrà ad occupare dopo il movimento è libera
* sposto il player (presenta il problema di avere una posizione
* non sempre precisa del player dopo la collisione)
*/
if ((key_right && place_free(x + collision_gap, y)) || (key_left && place_free(x - collision_gap, y))) {
	x += lengthdir_x(distance, movement_direction);
}
if ((key_up && place_free(x, y - collision_gap)) || (key_down && place_free(x, y + collision_gap))) {
	y += lengthdir_y(distance, movement_direction);
}

