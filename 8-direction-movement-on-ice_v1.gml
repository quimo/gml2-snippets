/**
* Object: obj_player | Event: Create
*/

player_speed_h = 0;
player_speed_v = 0;
player_speed_max = 4;
player_acceleration = 0.1;
player_deceleration = 0.04;
player_stop_movement_threshold = 60;
player_stop_movement_timing = 0;
player_sprite_dimension = 32;

/**
* Object: obj_player | Event: Intersect Boundary
*/

if (x <= (player_sprite_dimension/2)) x = (player_sprite_dimension/2);
if (x >= (room_width - (player_sprite_dimension/2))) x = room_width - (player_sprite_dimension/2);
if (y <= (player_sprite_dimension/2)) y = (player_sprite_dimension/2);
if (y >= (room_height - (player_sprite_dimension/2))) y = room_height - (player_sprite_dimension/2);

/**
* Object: obj_player | Event: Step
*/

var key_right = keyboard_check(vk_right);
var key_left = keyboard_check(vk_left);
var key_down = keyboard_check(vk_down);
var key_up = keyboard_check(vk_up);

if (key_right + key_left + key_up + key_down != 0) {
	// se sto premendo tasti di movimento il timer per la frenata si resetta
	player_stop_movement_timing = 0;
} else {
	// se non premo nessun tasto il timer scorre
	player_stop_movement_timing++;
}
// se è passato il tempo prestabilito frena
if (player_stop_movement_timing >= player_stop_movement_threshold) {
	if (player_speed_h > 0) {
		if (player_speed_h < 1) {
			player_speed_h = 0;
		} else {
			player_speed_h -= player_deceleration;
		}
	} else if (player_speed_h < 0) {
		if (player_speed_h > -1) {
			player_speed_h = 0;
		} else {
			player_speed_h += player_deceleration;
		}
	}
	if (player_speed_v > 0) {
		if (player_speed_v < 1) {
			player_speed_v = 0;
		} else {
			player_speed_v -= player_deceleration;
		}
	} else if (player_speed_v < 0) {
		if (player_speed_v > -1) {
			player_speed_v = 0;	
		} else {
			player_speed_v += player_deceleration;
		}
	}
} 

// se premo i tasti movimento il player si sposta
if (key_right) {
	// accelero a destra
	if (player_speed_h < player_speed_max) player_speed_h += player_acceleration;
}
	
if (key_left) {
	// accelero a sinistra
	if (player_speed_h > -player_speed_max) player_speed_h -= player_acceleration;
}

if (key_up) {
	// accelero in alto
	if (player_speed_v > -player_speed_max) player_speed_v -= player_acceleration;
}

if (key_down) {
	// accelero in basso
	if (player_speed_v < player_speed_max) player_speed_v += player_acceleration;
}

// sposto il player (non applica alcuna correzione per il movimento in diagonale)
x += player_speed_h;
y += player_speed_v;

