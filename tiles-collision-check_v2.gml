/**
* Object: obj_player | Event: Create
* 1) creare un oggetto "Tile set" e assegnargli uno sprite 128 x 64 (il primo frame 64 x 64 deve essere vuoto)
* 2) creare un livello "Tile layer" (nella room) cui assegnare il tile set 
*/


#macro tile_dimension 64
 
distance = 5;

// recupera l'id del tile set presente sul layer "Collision"
collision_tileset = layer_tilemap_get_id(layer_get_id("Collision"));

function move_x(x_axis) {
	
    var movement_x = 0;
	
	// movimento orizzontale
	if (x_axis != 0) {
		if (x_axis == 1) {
			// destra
			var hitpoint = bbox_right;
			// verifico se esiste una collisione agli estremi sopra e sotto della hitbox del player
			var collided_top = tilemap_get_at_pixel(collision_tileset, hitpoint + distance, bbox_top);
			var collided_bottom = tilemap_get_at_pixel(collision_tileset, hitpoint + distance, bbox_bottom);
		} else {
			// sinistra
			var hitpoint = bbox_left;
			var collided_top = tilemap_get_at_pixel(collision_tileset, hitpoint - distance, bbox_top);
			var collided_bottom = tilemap_get_at_pixel(collision_tileset, hitpoint - distance, bbox_bottom);
		}

		if (collided_top == 0 && collided_bottom == 0) {
			// se non c'è collisione sposto il player
			movement_x = distance;
		} else {
			if (x_axis == 1) {
				// destra
				var collision_tile_x = tilemap_get_cell_x_at_pixel(collision_tileset, hitpoint + distance, y);
				var collision_x = (collision_tile_x - 1) * tile_dimension;
				
			} else {
				// sinistra
				var collision_tile_x = tilemap_get_cell_x_at_pixel(collision_tileset, hitpoint - distance, y);
				var collision_x = (collision_tile_x + 1) * tile_dimension;
			}
			x = collision_x;
		}
	}
	return movement_x;
}
	
	
function move_y(y_axis) {
	
	var movement_y = 0;
	
	// movimento verticale
	if (y_axis != 0) {
		if (y_axis == 1) {
			// basso
			var hitpoint = bbox_bottom;
			// verifico se esiste una collisione agli estremi destra e sinistra della hitbox del player
			var collided_left = tilemap_get_at_pixel(collision_tileset, bbox_left, hitpoint + distance);
			var collided_right = tilemap_get_at_pixel(collision_tileset, bbox_right, hitpoint + distance);
		} else {
			// alto
			var hitpoint = bbox_top;
			// verifico se esiste una collisione agli estremi destra e sinistra della hitbox del player
			var collided_left = tilemap_get_at_pixel(collision_tileset, bbox_left, hitpoint - distance);
			var collided_right = tilemap_get_at_pixel(collision_tileset, bbox_right, hitpoint - distance);
		}
		
		if (collided_left == 0 && collided_right == 0) {
			// se non c'è collisione sposto il player
			movement_y = distance;
		} else {
			if (y_axis == 1) {
				// basso
				var collision_tile_y = tilemap_get_cell_y_at_pixel(collision_tileset, x, hitpoint + distance);
				var collision_y = (collision_tile_y - 1) * tile_dimension;
			} else {
				// alto
				var collision_tile_y = tilemap_get_cell_y_at_pixel(collision_tileset, x, hitpoint - distance);
				var collision_y = (collision_tile_y + 1) * tile_dimension;
			}
			y = collision_y;
		}
	}
	
	return movement_y;
	
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
var movement_x = move_x(x_axis);
var movement_y = move_y(y_axis);

// sposta il player
x += lengthdir_x(movement_x, movement_direction);
y += lengthdir_y(movement_y, movement_direction);