/**
* Object: obj_player | Event: Create
* 1) creare un oggetto "Tile set" e assegnargli uno sprite 128 x 64 (il primo frame 64 x 64 deve essere vuoto)
* 2) creare un livello "Tile layer" (nella room) cui assegnare il tile set 
*/

distance = 5;

// recupera l'id del tile set presente sul layer "Collision"
collision_tileset = layer_tilemap_get_id(layer_get_id("Collision"));

function checkTilesCollision(x_axis, y_axis) {
	
    var movement = 0;
	
	// movimento orrizzontale
	if (x_axis != 0) {
		if (x_axis == 1) {
			// destra
			var hitpoint = bbox_right;
		} else {
			// sinistra
			var hitpoint = bbox_left;
		}
		// verifica se esiste una collisione in cima o in fondo alla hitbox del player
		var collided_top = tilemap_get_at_pixel(collision_tileset, hitpoint + distance, bbox_top);
		var collided_bottom = tilemap_get_at_pixel(collision_tileset, hitpoint + distance, bbox_bottom);
		if (collided_top == 0 && collided_bottom == 0) {
			// se non c'è collisione sposta il player
			movement = distance;
		}
	}
	
	// movimento verticale
	if (y_axis != 0) {
		if (y_axis == 1) {
			// basso
			var hitpoint = bbox_bottom;
		} else {
			// alto
			var hitpoint = bbox_top;
		}
		// verifica se esiste una collisione a destra o a sinistra alla hitbox del player
		var collided_left = tilemap_get_at_pixel(collision_tileset, bbox_left, hitpoint + distance);
		var collided_right = tilemap_get_at_pixel(collision_tileset, bbox_right, hitpoint + distance);
		if (collided_left == 0 && collided_right == 0) {
			// se non c'è collisione sposta il player
			movement = distance;
		}
	}
	
	return movement;
}

/**
* Object: obj_player | Event: Step
*/

// rilevazione movimento orizzontale
var x_axis = keyboard_check(vk_right) - keyboard_check(vk_left);

// rilevazione movimento verticale
var y_axis = keyboard_check(vk_down) - keyboard_check(vk_up);

// restituisce la direzione del movimento (gradi)
var movement_direction = point_direction(0, 0, x_axis, y_axis); 

// verifica se esiste una collisione e restituisce lo spostamento
var movement = checkTilesCollision(x_axis, y_axis);

// sposta il player
x += lengthdir_x(movement, movement_direction);
y += lengthdir_y(movement, movement_direction);