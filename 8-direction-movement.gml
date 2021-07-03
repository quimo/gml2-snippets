/**
* Object: obj_player | Event: Create
*/

distance = 5;

/**
* Object: obj_player | Event: Step
*/

// rilevazione movimento orizzontale
var x_axis = keyboard_check(vk_right) - keyboard_check(vk_left);

// rilevazione movimento verticale
var y_axis = keyboard_check(vk_down) - keyboard_check(vk_up);

// restituisce la direzione del movimento (gradi)
var movement_direction = point_direction(0, 0, x_axis, y_axis); 

// se un tasto movimento è premuto...
if ( x_axis != 0 || y_axis != 0) {
	// sposto l'oggetto nella direzione indicata
	x += lengthdir_x(distance, movement_direction);
	y += lengthdir_y(distance, movement_direction);
}

// se è premuto un tasto "orizzontale"
if (x_axis != 0){
        // flip orizzontale
		image_xscale = x_axis;
}

// se è premuto un tasto "verticale"
if (y_axis != 0){
        // flip verticale
		image_yscale = y_axis;
}