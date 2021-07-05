
/**
* Object: obj_player | Event: Create
*/

image_speed = 0.5;

/**
* Object: obj_player | Event: Step
*/

var key_right = keyboard_check(vk_right);
var key_left = keyboard_check(vk_left);
var key_down = keyboard_check(vk_down);
var key_up = keyboard_check(vk_up);

// alla pressione di un tasto di movimento inizia l'animazione
if (key_right + key_left + key_up + key_down != 0) { 
    image_speed = 0.5;
} else {
    sprite_index = spr_player;  // nome dello sprite
    image_speed = 0;            // velocità di animazione dello sprite
	image_index = 0;            // tile (frame) dell'animazione
}

// sceglie l'animazione in base al tasto premuto
if (key_right) {
	sprite_index = spr_penguin_right;
}
	
if (key_left) {
	sprite_index = spr_penguin_left;
}

if (key_up) {
	sprite_index = spr_penguin_up;
}

if (key_down) {
	sprite_index = spr_penguin_down;
}